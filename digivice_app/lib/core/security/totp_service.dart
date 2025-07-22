import 'dart:developer';

import 'package:digivice_app/core/time/ntp_time_service.dart';
import 'package:injectable/injectable.dart';
import 'package:otp/otp.dart';

@singleton
class TotpService {
  TotpService(this.ntpTimeService);

  final NtpTimeService ntpTimeService;

  /// Generates a TOTP code based on the provided secret and parameters
  Future<String> generateTotp({
    required String secret,
    int timeStep = 30,
    int digits = 6,
    Algorithm algorithm = Algorithm.SHA1,
    bool useNtpTime = true,
  }) async {
    try {
      // get current time, either from NTP or local system
      DateTime currentTime;
      if (useNtpTime) {
        try {
          currentTime = await ntpTimeService.getNtpTime();
        } on Exception catch (_) {
          currentTime = ntpTimeService.estimatedNtpTime;
        }
      } else {
        currentTime = DateTime.now();
      }

      // Generate TOTP code
      log('🔑 TOTP Generation Debug:');
      log('  - Secret: $secret');
      log('  - Secret length: ${secret.length}');
      log('  - Time: $currentTime');
      log('  - Timestamp: ${currentTime.millisecondsSinceEpoch}');
      log('  - TimeStep: $timeStep');
      log('  - Digits: $digits');
      log('  - Algorithm: $algorithm');

      final code = OTP.generateTOTPCodeString(
        secret,
        currentTime.millisecondsSinceEpoch,
        length: digits,
        interval: timeStep,
        algorithm: algorithm,
        isGoogle: true, // Use Google Authenticator format
      );

      log('✅ Generated TOTP: $code');
      return code;
    } catch (e) {
      log('Failed to generate TOTP: $e');
      throw Exception('Failed to generate TOTP: $e');
    }
  }

  /// validates a TOTP code against the provided secret
  Future<bool> validateTotp({
    required String code,
    required String secret,
    int timeStep = 30,
    int digits = 6,
    Algorithm algorithm = Algorithm.SHA1,
    bool useNtpTime = true,
    int windowSize = 1,
  }) async {
    try {
      DateTime currentTime;
      if (useNtpTime) {
        try {
          currentTime = await ntpTimeService.getNtpTime();
        } on Exception catch (_) {
          currentTime = ntpTimeService.estimatedNtpTime;
        }
      } else {
        currentTime = DateTime.now();
      }

      // Validar código TOTP con ventana de tolerancia
      for (var i = -windowSize; i <= windowSize; i++) {
        final testTime = currentTime.add(Duration(seconds: i * timeStep));
        final expectedCode = OTP.generateTOTPCodeString(
          secret,
          testTime.millisecondsSinceEpoch,
          length: digits,
          interval: timeStep,
          algorithm: algorithm,
        );

        if (code == expectedCode) {
          return true;
        }
      }

      return false;
    } on Exception catch (_) {
      return false;
    }
  }

  /// gets TOTP information including code, time step, and remaining time
  Future<Map<String, dynamic>> getTotpInfo({
    required String secret,
    int timeStep = 30,
    bool useNtpTime = true,
  }) async {
    try {
      DateTime currentTime;
      if (useNtpTime) {
        try {
          currentTime = await ntpTimeService.getNtpTime();
        } on Exception catch (_) {
          currentTime = ntpTimeService.estimatedNtpTime;
        }
      } else {
        currentTime = DateTime.now();
      }

      final currentTimeSeconds = currentTime.millisecondsSinceEpoch ~/ 1000;
      final timeSlot = currentTimeSeconds ~/ timeStep;
      final timeRemaining = timeStep - (currentTimeSeconds % timeStep);

      final code = await generateTotp(
        secret: secret,
        timeStep: timeStep,
        useNtpTime: false, // Ya tenemos el tiempo
      );

      return {
        'code': code,
        'timeStep': timeStep,
        'currentTime': currentTime.toIso8601String(),
        'timeSlot': timeSlot,
        'timeRemaining': timeRemaining,
        'validUntil': currentTime
            .add(Duration(seconds: timeRemaining))
            .toIso8601String(),
        'secretLength': secret.length,
        'usingNtpTime': useNtpTime,
      };
    } on Exception catch (e) {
      return {
        'error': e.toString(),
        'usingNtpTime': useNtpTime,
      };
    }
  }

  /// generates a window of TOTP codes around the current time
  Future<List<Map<String, dynamic>>> generateTotpWindow({
    required String secret,
    int windowSize = 2,
    int timeStep = 30,
    bool useNtpTime = true,
  }) async {
    try {
      DateTime currentTime;
      if (useNtpTime) {
        try {
          currentTime = await ntpTimeService.getNtpTime();
        } on Exception catch (_) {
          currentTime = ntpTimeService.estimatedNtpTime;
        }
      } else {
        currentTime = DateTime.now();
      }

      final codes = <Map<String, dynamic>>[];

      for (var i = -windowSize; i <= windowSize; i++) {
        final testTime = currentTime.add(Duration(seconds: i * timeStep));
        final code = OTP.generateTOTPCodeString(
          secret,
          testTime.millisecondsSinceEpoch,
          // length: 6,
          interval: timeStep,
          algorithm: Algorithm.SHA1,
        );

        codes.add({
          'code': code,
          'time': testTime.toIso8601String(),
          'offset': i * timeStep,
          'isCurrent': i == 0,
          'isPast': i < 0,
          'isFuture': i > 0,
        });
      }

      return codes;
    } catch (e) {
      throw Exception('Failed to generate TOTP window: $e');
    }
  }

  /// gets the time until the next TOTP code
  Future<int> getTimeUntilNextCode({
    int timeStep = 30,
    bool useNtpTime = true,
  }) async {
    try {
      DateTime currentTime;
      if (useNtpTime) {
        try {
          currentTime = await ntpTimeService.getNtpTime();
        } on Exception catch (_) {
          currentTime = ntpTimeService.estimatedNtpTime;
        }
      } else {
        currentTime = DateTime.now();
      }

      final currentTimeSeconds = currentTime.millisecondsSinceEpoch ~/ 1000;
      return timeStep - (currentTimeSeconds % timeStep);
    } on Exception catch (_) {
      return 0;
    }
  }
}
