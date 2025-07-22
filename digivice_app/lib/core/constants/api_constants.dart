class ApiConstants {
  // Default values - can be overridden by Firebase Remote Config
  static const String defaultBaseUrl = 'https://34.160.137.130/v1/';
  static const String defaultUserName = '';
  static const String defaultPassword = '';
  static const String defaultKeyRequest = '';
  static const String defaultKeyResponse = '';
  
  // Endpoints
  static const String digimonEndpoint = 'digimon';
  static const String softtokenEndpoint = 'softtoken';
  
  // Headers
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String authorization = 'Authorization';
  
  // Timeouts
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
  
  // Remote Config Keys
  static const String baseUrlKey = 'base_url';
  static const String userNameKey = 'user_name';
  static const String passwordKey = 'password';
  static const String keyRequestKey = 'key_request';
  static const String keyResponseKey = 'key_response';
}
