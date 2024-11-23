import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_const.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  final String baseUrl = ApiConst.baseUrl;

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

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve the token from SharedPreferences

    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token'; // Include the token in the headers
    }

    Response response;

    try {
      if (method == 'GET') {
        response = await dio.get(path);
      } else if (method == 'POST') {
        if (isFormdata) {
          response = await dio.post(path, data: FormData.fromMap(data));
        } else {
          response = await dio.post(path, data: data);
        }
      } else if (method == 'PUT') {
        response = await dio.put(path, data: data);
      } else if (method == 'DELETE') {
        response = await dio.delete(path, data: data);
      } else {
        throw Exception('Unsupported HTTP method');
      }

      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception('DioError: ${e.response?.statusCode} ${e.response?.data}');
      } else {
        throw Exception('DioError: ${e.message}');
      }
    }
  }
}

// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'api_const.dart';

// final apiClientProvider = Provider<ApiClient>((ref) {
//   return ApiClient();
// });

// class ApiClient {
//   final String baseUrl = ApiConst.baseUrl;
//   final Dio dio;

//   ApiClient() : dio = Dio(BaseOptions(baseUrl: ApiConst.baseUrl));

//   Future request({
//     required String path,
//     String method = 'GET',
//     bool isFormdata = false,
//     Map<String, dynamic> data = const {},
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final cookies = prefs.getString('cookies'); // Retrieve the cookies from SharedPreferences

//     if (cookies != null) {
//       dio.options.headers['Cookie'] = cookies; // Include the cookies in the headers
//     }

//     Response response;

//     try {
//       if (method == 'GET') {
//         response = await dio.get(path);
//       } else if (method == 'POST') {
//         if (isFormdata) {
//           response = await dio.post(path, data: FormData.fromMap(data));
//         } else {
//           response = await dio.post(path, data: data);
//         }
//       } else if (method == 'PUT') {
//         response = await dio.put(path, data: data);
//       } else if (method == 'DELETE') {
//         response = await dio.delete(path, data: data);
//       } else {
//         throw Exception('Unsupported HTTP method');
//       }

//       print('API response: ${response.data}'); // Log the API response to the console

//       // Save cookies from response headers
//       if (response.headers['set-cookie'] != null) {
//         final cookies = response.headers['set-cookie']!.join('; ');
//         await prefs.setString('cookies', cookies);
//       }

//       return response.data;
//     } on DioError catch (e) {
//       if (e.response != null) {
//         print('DioError: ${e.response?.statusCode} ${e.response?.data}'); // Log the DioError to the console
//         throw Exception('DioError: ${e.response?.statusCode} ${e.response?.data}');
//       } else {
//         print('DioError: ${e.message}'); // Log the DioError to the console
//         throw Exception('DioError: ${e.message}');
//       }
//     }
//   }
// }