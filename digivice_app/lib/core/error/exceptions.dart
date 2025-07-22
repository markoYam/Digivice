class ServerException implements Exception {}

class CacheException implements Exception {}

class NetworkException implements Exception {}

class ValidationException implements Exception {
  const ValidationException(this.message);
  
  final String message;
}
