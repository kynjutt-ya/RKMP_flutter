import 'package:dio/dio.dart';
import 'network_exceptions.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/error_interceptor.dart';

/// Базовый клиент для сетевых запросов
class DioClient {
  late final Dio _dio;

  DioClient({
    required String baseUrl,
    int connectTimeout = 30000,
    int receiveTimeout = 30000,
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Добавляем интерсепторы
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  /// Конструктор для создания клиента из уже настроенного Dio экземпляра
  DioClient.fromDio(Dio dio) : _dio = dio;

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Превышено время ожидания ответа');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 400) {
          return BadRequestException('Некорректный запрос');
        } else if (statusCode == 401) {
          return UnauthorizedException('Требуется авторизация');
        } else if (statusCode == 404) {
          return NotFoundException('Ресурс не найден');
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException('Ошибка сервера');
        }
        return NetworkException('Ошибка сети: ${error.message}');
      case DioExceptionType.cancel:
        return NetworkException('Запрос отменен');
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return NetworkException('Нет подключения к интернету');
        }
        return NetworkException('Неизвестная ошибка: ${error.message}');
      default:
        return NetworkException('Ошибка сети: ${error.message}');
    }
  }
}

