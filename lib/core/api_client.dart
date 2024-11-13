import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:protectmee/core/api_const.dart';
import 'package:protectmee/core/exception_handle.dart';

final apiClientProvider = StateProvider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  final String baseUrl = 'https://cee7-43-245-93-169.ngrok-free.app';

  Future request({
    required String path,
    String method = 'GET',
    bool isFormdata = false,
    Map<String, dynamic> data = const {},
  }) async {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "ngrok-skip-browser-warning": "69420",
        },
      ),
    );

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    try {
      final result = method.toUpperCase() == 'GET'
          ? await dio.get(path)
          : await dio.post(path, data: isFormdata ? FormData.fromMap(data) : data);
      return result.data;
    } on DioException catch (e) {
      throw DioExceptionHandle.fromDioError(e);
    }
  }

  Future apiRequest({
    required String path,
    String type = 'GET',
    bool hasBaseUrl = true,
    Map<String, dynamic> data = const {},
  }) async {
    final dio = Dio(
      hasBaseUrl
          ? BaseOptions(
              baseUrl: ApiConst.baseUrl,
              headers: {
                "ngrok-skip-browser-warning": "69420",
              },
            )
          : BaseOptions(
              headers: {
                "ngrok-skip-browser-warning": "69420",
              },
            ),
    );

    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: true,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

    try {
      final result = type.toUpperCase() == 'GET'
          ? await dio.get(path)
          : await dio.post(path, data: data);
      return result.data;
    } on DioException catch (e) {
      throw DioExceptionHandle.fromDioError(e);
    }
  }
}