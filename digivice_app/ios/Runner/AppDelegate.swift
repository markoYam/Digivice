import UIKit
import Flutter
import CommonCrypto

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let decryptChannel = FlutterMethodChannel(name: "com.digivice.encryption/decrypt",
                                            binaryMessenger: controller.binaryMessenger)
    
    decryptChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      switch call.method {
      case "decrypt":
        guard let args = call.arguments as? [String: Any],
              let encryptedData = args["encryptedData"] as? String,
              let keyResponse = args["keyResponse"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", 
                            message: "encryptedData and keyResponse are required", 
                            details: nil))
          return
        }
        
        do {
          let decryptedText = try self?.decryptAES256CBC(encryptedData: encryptedData, keyResponse: keyResponse)
          result(decryptedText)
        } catch {
          result(FlutterError(code: "DECRYPT_ERROR", 
                            message: "Failed to decrypt: \(error.localizedDescription)", 
                            details: nil))
        }
        
      case "encrypt":
        guard let args = call.arguments as? [String: Any],
              let plainData = args["plainData"] as? String,
              let keyRequest = args["keyRequest"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENTS", 
                            message: "plainData and keyRequest are required", 
                            details: nil))
          return
        }
        
        do {
          let encryptedText = try self?.encryptAES256CBC(plainData: plainData, keyRequest: keyRequest)
          result(encryptedText)
        } catch {
          result(FlutterError(code: "ENCRYPT_ERROR", 
                            message: "Failed to encrypt: \(error.localizedDescription)", 
                            details: nil))
        }
        
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  private func decryptAES256CBC(encryptedData: String, keyResponse: String) throws -> String {
    // Separar IV y datos cifrados (formato: iv_hex:encrypted_hex)
    let parts = encryptedData.components(separatedBy: ":")
    guard parts.count == 2 else {
      throw NSError(domain: "DecryptionError", code: 1, 
                   userInfo: [NSLocalizedDescriptionKey: "Invalid encrypted data format. Expected: iv_hex:encrypted_hex"])
    }
    
    let ivHex = parts[0]
    let encryptedHex = parts[1]
    
    // Convertir Hexadecimal a datos
    guard let originalIv = Data(hexString: ivHex),
          let encryptedBytes = Data(hexString: encryptedHex) else {
      throw NSError(domain: "DecryptionError", code: 2, 
                   userInfo: [NSLocalizedDescriptionKey: "Invalid Hexadecimal format"])
    }
    
    // Manejar IVs de 12 bytes (96 bits) o 16 bytes (128 bits)
    let iv: Data
    switch originalIv.count {
    case 12:
      // Expandir IV de 12 bytes a 16 bytes rellenando con ceros
      var expandedIv = originalIv
      expandedIv.append(Data(count: 4)) // Agregar 4 bytes de ceros
      iv = expandedIv
    case 16:
      iv = originalIv
    default:
      throw NSError(domain: "DecryptionError", code: 3, 
                   userInfo: [NSLocalizedDescriptionKey: "Invalid IV length: \(originalIv.count). Expected 12 or 16 bytes for AES."])
    }
    
    // Derivar clave usando SHA-256
    let keyData = deriveKeyFromSHA256(input: keyResponse)
    
    // Desencriptar usando AES-256-CBC
    let decryptedData = try aesDecrypt(data: encryptedBytes, key: keyData, iv: iv)
    
    guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
      throw NSError(domain: "DecryptionError", code: 4, 
                   userInfo: [NSLocalizedDescriptionKey: "Failed to convert decrypted data to string"])
    }
    
    return decryptedString
  }
  
  private func deriveKeyFromSHA256(input: String) -> Data {
    let inputData = input.data(using: .utf8)!
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    inputData.withUnsafeBytes {
      _ = CC_SHA256($0.baseAddress, CC_LONG(inputData.count), &hash)
    }
    return Data(hash)
  }
  
  private func encryptAES256CBC(plainData: String, keyRequest: String) throws -> String {
    // Derivar clave usando SHA-256
    let keyData = deriveKeyFromSHA256(input: keyRequest)
    
    // Generar IV aleatorio de 16 bytes
    var iv = Data(count: 16)
    let result = iv.withUnsafeMutableBytes {
      SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!)
    }
    guard result == errSecSuccess else {
      throw NSError(domain: "EncryptionError", code: 1, 
                   userInfo: [NSLocalizedDescriptionKey: "Failed to generate random IV"])
    }
    
    // Convertir texto plano a datos
    guard let plainBytes = plainData.data(using: .utf8) else {
      throw NSError(domain: "EncryptionError", code: 2, 
                   userInfo: [NSLocalizedDescriptionKey: "Failed to convert plain text to data"])
    }
    
    // Cifrar usando AES-256-CBC
    let encryptedData = try aesEncrypt(data: plainBytes, key: keyData, iv: iv)
    
    // Convertir a Hexadecimal (formato: iv_hex:encrypted_hex)
    let ivHex = iv.hexString
    let encryptedHex = encryptedData.hexString
    
    return "\(ivHex):\(encryptedHex)"
  }
  
  private func aesEncrypt(data: Data, key: Data, iv: Data) throws -> Data {
    let cryptLength = size_t(data.count + kCCBlockSizeAES128)
    var cryptData = Data(count: cryptLength)
    
    let keyLength = size_t(kCCKeySizeAES256)
    let operation: CCOperation = UInt32(kCCEncrypt)
    let algorithm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
    let options: CCOptions = UInt32(kCCOptionPKCS7Padding)
    
    var numBytesEncrypted: size_t = 0
    
    let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
      data.withUnsafeBytes { dataBytes in
        iv.withUnsafeBytes { ivBytes in
          key.withUnsafeBytes { keyBytes in
            CCCrypt(operation,
                   algorithm,
                   options,
                   keyBytes.baseAddress, keyLength,
                   ivBytes.baseAddress,
                   dataBytes.baseAddress, data.count,
                   cryptBytes.baseAddress, cryptLength,
                   &numBytesEncrypted)
          }
        }
      }
    }
    
    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
      cryptData.removeSubrange(numBytesEncrypted..<cryptData.count)
      return cryptData
    } else {
      throw NSError(domain: "EncryptionError", code: 3, 
                   userInfo: [NSLocalizedDescriptionKey: "Encryption failed with status: \(cryptStatus)"])
    }
  }
  
  private func aesDecrypt(data: Data, key: Data, iv: Data) throws -> Data {
    let cryptLength = size_t(data.count + kCCBlockSizeAES128)
    var cryptData = Data(count: cryptLength)
    
    let keyLength = size_t(kCCKeySizeAES256)
    let operation: CCOperation = UInt32(kCCDecrypt)
    let algorithm: CCAlgorithm = UInt32(kCCAlgorithmAES128)
    let options: CCOptions = UInt32(kCCOptionPKCS7Padding)
    
    var numBytesDecrypted: size_t = 0
    
    let cryptStatus = cryptData.withUnsafeMutableBytes { cryptBytes in
      data.withUnsafeBytes { dataBytes in
        iv.withUnsafeBytes { ivBytes in
          key.withUnsafeBytes { keyBytes in
            CCCrypt(operation,
                   algorithm,
                   options,
                   keyBytes.baseAddress, keyLength,
                   ivBytes.baseAddress,
                   dataBytes.baseAddress, data.count,
                   cryptBytes.baseAddress, cryptLength,
                   &numBytesDecrypted)
          }
        }
      }
    }
    
    if UInt32(cryptStatus) == UInt32(kCCSuccess) {
      cryptData.removeSubrange(numBytesDecrypted..<cryptData.count)
      return cryptData
    } else {
      throw NSError(domain: "DecryptionError", code: 4, 
                   userInfo: [NSLocalizedDescriptionKey: "Decryption failed with status: \(cryptStatus)"])
    }
  }
}

extension Data {
  init?(hexString: String) {
    let len = hexString.count / 2
    var data = Data(capacity: len)
    for i in 0..<len {
      let j = hexString.index(hexString.startIndex, offsetBy: i*2)
      let k = hexString.index(j, offsetBy: 2)
      let bytes = hexString[j..<k]
      if var num = UInt8(bytes, radix: 16) {
        data.append(&num, count: 1)
      } else {
        return nil
      }
    }
    self = data
  }
  
  var hexString: String {
    return map { String(format: "%02x", $0) }.joined()
  }
}
