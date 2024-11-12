// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// import 'api_const.dart';
// import 'exception_handle.dart';

// final apiClientProvider = Provider<ApiClient>((ref) {
//   return ApiClient();
// });

// class ApiClient {
//   final Dio _dio;

//   ApiClient()
//       : _dio = Dio(
//           BaseOptions(
//             baseUrl: ApiConst.baseUrl,
           
//             headers: {
//               "Content-Type": "application/json",
//             },
//           ),
//         ) {
//     _dio.interceptors.add(PrettyDioLogger(
//       requestHeader: true,
//       requestBody: true,
//       responseBody: true,
//       responseHeader: true,
//       error: true,
//       compact: true,
//       maxWidth: 90,
//     ));
//   }

//   Future<Map<String, dynamic>> request({
//     required String path,
//     String method = "GET",
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       final response = await _dio.request(
//         path,
//         data: data,
//         options: Options(method: method),
//       );
//       return response.data;
//     } on DioException catch (e) {
//       print('DioError: ${e.type} - ${e.message}');
//       throw DioExceptionHandle.fromDioError(e);
//     }
//   }
// }


import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:protectmee/core/api_const.dart';
import 'package:protectmee/core/exception_handle.dart';

final apiClientProvider = StateProvider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  Future request({
    required String path,
    String type = "get",
    bool isFormdata = false,
    Map<String, dynamic> data = const {},
String method ="",
  }) async {
    final dio = Dio(
      BaseOptions(
        headers:{
          "ngrok-skip-browser-warning": "69420",
        }
        // {"Authorization": "key=${Appconst.meroschoolServerKey}"},
      ),
    );
// customization
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));
    try {
      final result = type == "get"
          ? await dio.get(path)
          : await dio.post(path,
              data: isFormdata ? FormData.fromMap(data) : data);
      return result.data;
    } on DioException catch (e) {
      throw DioExceptionHandle.fromDioError(e);
    }
  }

  apiRequest({
    required String path,
    String type = "get",
    bool hasBaseUrl = true,
    Map<String, dynamic> data = const {},
  }) async {
    final dio = Dio(
      hasBaseUrl
          ? BaseOptions(
              baseUrl: ApiConst.baseUrl,
            )
          : BaseOptions(),
    );
    dio.interceptors.add(PrettyDioLogger());
// customization
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90));

    try {
      final result = type == "get"
          ? await dio.get(path)
          : await dio.post(path, data: data);
      return result.data;
    } on DioException catch (e) {
      // log("Res Err is ${e.message}");
      throw DioExceptionHandle.fromDioError(e);
    }
  }
}
