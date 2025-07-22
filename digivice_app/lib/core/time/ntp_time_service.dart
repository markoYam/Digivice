import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:ntp/ntp.dart';

@singleton
class NtpTimeService {
  static const String _defaultNtpServer = 'pool.ntp.org';
  static const Duration _defaultTimeout = Duration(seconds: 10);

  DateTime? _lastSyncedTime;
  DateTime? _lastLocalTime;
  Duration? _timeOffset;

  /// gets the current NTP time from a specified server
  Future<DateTime> getNtpTime({
    String ntpServer = _defaultNtpServer,
    Duration timeout = _defaultTimeout,
  }) async {
    try {
      final ntpTime = await NTP.now(
        timeout: timeout,
        lookUpAddress: ntpServer,
      );

      // save the last synced time and calculate offset
      _lastSyncedTime = ntpTime;
      _lastLocalTime = DateTime.now();
      _timeOffset = ntpTime.difference(_lastLocalTime!);

      return ntpTime;
    } on Exception catch (_) {
      // If there was a previous sync, estimate time
      if (_timeOffset != null && _lastLocalTime != null) {
        final estimatedTime = DateTime.now().add(_timeOffset!);
        return estimatedTime;
      }

      return DateTime.now();
    }
  }

  /// get NTP time from multiple servers and return the median
  Future<DateTime> getNtpTimeFromMultipleServers({
    List<String> ntpServers = const [
      'pool.ntp.org',
      'time.google.com',
      'time.cloudflare.com',
      'time.apple.com',
    ],
    Duration timeout = _defaultTimeout,
  }) async {
    final results = <DateTime>[];

    // try to get time from each server
    final futures = ntpServers.map((server) async {
      try {
        return await getNtpTime(ntpServer: server, timeout: timeout);
      } on Exception catch (_) {
        return null;
      }
    });

    final responses = await Future.wait(futures);

    // Filter successful responses
    for (final response in responses) {
      if (response != null) {
        results.add(response);
      }
    }

    if (results.isEmpty) {
      throw Exception('Failed to get NTP time from any server');
    }

    // If there is only one response, use it
    if (results.length == 1) {
      return results.first;
    }

    // If there are multiple responses, use the median to avoid outliers
    results.sort();
    final median = results[results.length ~/ 2];

    return median;
  }

  /// Verifies if the local time is synchronized with NTP (within a margin)
  Future<bool> isTimeSynchronized({
    int maxDifferenceSeconds = 30,
    String ntpServer = _defaultNtpServer,
  }) async {
    try {
      final ntpTime = await getNtpTime(ntpServer: ntpServer);
      final localTime = DateTime.now();
      final difference = ntpTime.difference(localTime).abs();

      final isSync = difference.inSeconds <= maxDifferenceSeconds;

      return isSync;
    } on Exception catch (_) {
      return false;
    }
  }

  /// gets detailed synchronization information
  Future<Map<String, dynamic>> getTimeSyncInfo({
    String ntpServer = _defaultNtpServer,
  }) async {
    try {
      final startTime = DateTime.now();
      final ntpTime = await getNtpTime(ntpServer: ntpServer);
      final endTime = DateTime.now();
      final localTime = DateTime.now();

      final roundTripTime = endTime.difference(startTime);
      final timeOffset = ntpTime.difference(localTime);

      return {
        'ntpServer': ntpServer,
        'ntpTime': ntpTime.toIso8601String(),
        'localTime': localTime.toIso8601String(),
        'timeOffset': timeOffset.inMilliseconds,
        'roundTripTime': roundTripTime.inMilliseconds,
        'synchronized': timeOffset.abs().inSeconds <= 30,
        'lastSyncTime': _lastSyncedTime?.toIso8601String(),
      };
    } on Exception catch (e) {
      return {
        'error': e.toString(),
        'ntpServer': ntpServer,
        'localTime': DateTime.now().toIso8601String(),
        'synchronized': false,
      };
    }
  }

  Duration? get currentTimeOffset => _timeOffset;

  DateTime get estimatedNtpTime {
    if (_timeOffset != null) {
      return DateTime.now().add(_timeOffset!);
    }
    return DateTime.now();
  }

  void clearSyncCache() {
    _lastSyncedTime = null;
    _lastLocalTime = null;
    _timeOffset = null;
    log('NTP sync cache cleared');
  }
}
