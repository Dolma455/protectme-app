import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/login_user_model.dart';

abstract class LoginUserDataSource {
  Future<String> loginUser(LoginUserModel loginModel);
}

class LoginUserDataSourceImpl implements LoginUserDataSource {
  final ApiClient apiClient;

  LoginUserDataSourceImpl({required this.apiClient});

  @override
  Future<String> loginUser(LoginUserModel loginModel) async {
    final result = await apiClient.request(
      path: '/login',
      method: 'POST',
      data: loginModel.toJson(),
    );
    if (result is Map<String, dynamic> && result.containsKey('message')) {
      return result['message'];
    } else {
      throw Exception('Unexpected API response format');
    }
  }
}

final loginUserDataSourceProvider = Provider<LoginUserDataSource>((ref) {
  return LoginUserDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});