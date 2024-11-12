import 'package:dio/dio.dart';

class DioExceptionHandle {
  final String message;

  DioExceptionHandle(this.message);

  static DioExceptionHandle fromDioError(DioException dioError) {
    String errorMessage;
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorMessage = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout with API server";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Connection error: ${dioError.message}";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        errorMessage = "Received invalid status code: ${dioError.response?.statusCode}";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout in connection with API server";
        break;
      default:
        errorMessage = "Something went wrong: ${dioError.message}";
        break;
    }
    return DioExceptionHandle(errorMessage);
  }
}