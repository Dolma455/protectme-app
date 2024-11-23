import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  final ApiClient apiClient;

  LoginController({required this.apiClient}) : super(const AsyncValue.data(null));

  Future<String> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final response = await apiClient.request(
        path: '/login',
        method: 'POST',
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Login response: $response'); // Log the response

      if (response is Map<String, dynamic> && response.containsKey('message')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email); // Store the email in SharedPreferences
        print('Stored email: $email'); // Log the stored email
        state = const AsyncValue.data(null);
        
        return response['message']; // Return the message containing the user role
      } else {
        state = AsyncValue.error('Unexpected response format', StackTrace.current);
        return 'Unexpected response format';
      }
    } catch (e) {
      print('Login error: $e'); // Log the error
      state = AsyncValue.error(e, StackTrace.current);
      return 'Error: $e';
    }
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
  return LoginController(apiClient: ref.watch(apiClientProvider));
});
