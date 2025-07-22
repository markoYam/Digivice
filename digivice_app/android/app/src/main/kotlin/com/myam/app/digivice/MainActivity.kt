package com.myam.app.digivice

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.SecureRandom
import java.util.Base64
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.digivice.encryption/decrypt"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "decrypt" -> {
                    val encryptedData = call.argument<String>("encryptedData")
                    val keyResponse = call.argument<String>("keyResponse")
                    
                    if (encryptedData != null && keyResponse != null) {
                        try {
                            val decryptedText = decryptAES256CBC(encryptedData, keyResponse)
                            result.success(decryptedText)
                        } catch (e: Exception) {
                            result.error("DECRYPT_ERROR", "Failed to decrypt: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "encryptedData and keyResponse are required", null)
                    }
                }
                "encrypt" -> {
                    val plainData = call.argument<String>("plainData")
                    val keyRequest = call.argument<String>("keyRequest")
                    
                    if (plainData != null && keyRequest != null) {
                        try {
                            val encryptedText = encryptAES256CBC(plainData, keyRequest)
                            result.success(encryptedText)
                        } catch (e: Exception) {
                            result.error("ENCRYPT_ERROR", "Failed to encrypt: ${e.message}", null)
                        }
                    } else {
                        result.error("INVALID_ARGUMENTS", "plainData and keyRequest are required", null)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun decryptAES256CBC(encryptedData: String, keyResponse: String): String {
        // Separar IV y datos cifrados (formato: iv_hex:encrypted_hex)
        val parts = encryptedData.split(":")
        if (parts.size != 2) {
            throw IllegalArgumentException("Invalid encrypted data format. Expected: iv_hex:encrypted_hex")
        }
        
        val ivHex = parts[0]
        val encryptedHex = parts[1]
        
        // Convertir Hexadecimal a bytes
        val originalIv = hexToBytes(ivHex)
        val encryptedBytes = hexToBytes(encryptedHex)
        
        // Derivar clave usando SHA-256
        val keyBytes = deriveKeyFromSHA256(keyResponse)
        
        // Configurar cifrado AES-256-CBC
        val cipher = Cipher.getInstance("AES/CBC/PKCS7Padding")
        val secretKey = SecretKeySpec(keyBytes, "AES")
        val ivSpec = IvParameterSpec(originalIv)
        
        // Desencriptar
        cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec)
        val decryptedBytes = cipher.doFinal(encryptedBytes)
        
        return String(decryptedBytes, Charsets.UTF_8)
    }
    
    private fun deriveKeyFromSHA256(input: String): ByteArray {
        val digest = MessageDigest.getInstance("SHA-256")
        return digest.digest(input.toByteArray(Charsets.UTF_8))
    }
    
    private fun encryptAES256CBC(plainData: String, keyRequest: String): String {
        // Derivar clave usando SHA-256
        val keyBytes = deriveKeyFromSHA256(keyRequest)
        
        // Generar IV aleatorio de 16 bytes
        val iv = ByteArray(16)
        SecureRandom().nextBytes(iv)
        
        // Configurar cifrado AES-256-CBC
        val cipher = Cipher.getInstance("AES/CBC/PKCS7Padding")
        val secretKey = SecretKeySpec(keyBytes, "AES")
        val ivSpec = IvParameterSpec(iv)
        
        // Cifrar
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec)
        val encryptedBytes = cipher.doFinal(plainData.toByteArray(Charsets.UTF_8))
        
        // Convertir a Hexadecimal (formato: iv_hex:encrypted_hex)
        val ivBase64 = Base64.getEncoder().encodeToString(iv)
        val encryptedBase64 = Base64.getEncoder().encodeToString(encryptedBytes)

        return "$ivBase64:$encryptedBase64"
    }
    
    private fun hexToBytes(hex: String): ByteArray {
        val len = hex.length
        val data = ByteArray(len / 2)
        for (i in 0 until len step 2) {
            data[i / 2] = ((Character.digit(hex[i], 16) shl 4) + Character.digit(hex[i + 1], 16)).toByte()
        }
        return data
    }
    
    private fun bytesToHex(bytes: ByteArray): String {
        return bytes.joinToString("") { "%02x".format(it) }
    }
}
