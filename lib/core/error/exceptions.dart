class ServerException implements Exception {
  final String? message;
  ServerException([this.message]);
}

class NetworkException implements Exception {}

class CacheException implements Exception {}

class UnauthorizedException implements Exception {}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}