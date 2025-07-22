import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

@singleton
class NativeDecryptionService {
  static const MethodChannel _channel = MethodChannel(
    'com.digivice.encryption/decrypt',
  );

  // converts Base64 encrypted data to hex format
  String _convertBase64ToHex(String encryptedDataBase64) {
    try {
      final parts = encryptedDataBase64.split(':');
      if (parts.length != 2) {
        throw const FormatException(
          'Invalid format: expected iv_base64:encrypted_base64',
        );
      }

      // Convert IV from Base64 to bytes and then to hex
      final ivBytes = base64.decode(parts[0]);
      final ivHex = ivBytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join();

      // Convert encrypted data from Base64 to bytes and then to hex
      final encryptedBytes = base64.decode(parts[1]);
      final encryptedHex = encryptedBytes
          .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
          .join();

      return '$ivHex:$encryptedHex';
    } catch (e) {
      throw FormatException('Failed to convert Base64 to Hex: $e');
    }
  }

  // Decrypts a message using the native channel
  Future<String> decryptMessage({
    required String encryptedData,
    required String keyResponse,
  }) async {
    try {
      var hexEncryptedData = encryptedData;

      if (encryptedData.contains('=') ||
          encryptedData.contains('+') ||
          encryptedData.contains('/')) {
        hexEncryptedData = _convertBase64ToHex(encryptedData);
      }

      final dynamic result = await _channel.invokeMethod('decrypt', {
        'encryptedData': hexEncryptedData,
        'keyResponse': keyResponse,
      });
      return result as String;
    } on PlatformException catch (e) {
      throw Exception('Failed to decrypt: ${e.message}');
    }
  }

  // Encrypts a message using the native channel
  Future<String> encryptMessage({
    required String plainData,
    required String keyRequest,
  }) async {
    try {
      final dynamic result = await _channel.invokeMethod('encrypt', {
        'plainData': plainData,
        'keyRequest': keyRequest,
      });
      return result as String;
    } on PlatformException catch (e) {
      throw Exception('Failed to encrypt: ${e.message}');
    }
  }
}
