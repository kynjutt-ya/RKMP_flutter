/// Базовый класс для сетевых исключений
class NetworkException implements Exception {
  final String message;
  final dynamic data;

  NetworkException(this.message, [this.data]);

  @override
  String toString() => message;
}

/// Исключение при таймауте
class TimeoutException extends NetworkException {
  TimeoutException(super.message, [super.data]);
}

/// Исключение при ошибке 400
class BadRequestException extends NetworkException {
  BadRequestException(super.message, [super.data]);
}

/// Исключение при ошибке 401
class UnauthorizedException extends NetworkException {
  UnauthorizedException(super.message, [super.data]);
}

/// Исключение при ошибке 404
class NotFoundException extends NetworkException {
  NotFoundException(super.message, [super.data]);
}

/// Исключение при ошибке сервера (5xx)
class ServerException extends NetworkException {
  ServerException(super.message, [super.data]);
}

