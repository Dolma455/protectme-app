import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/user_model.dart';

abstract class RegisterUserDataSource {
  Future<RegisterUserResponseModel> registerUser(RegisterUserModel registerUserModel);
}

class RegisterUserDataSourceImpl implements RegisterUserDataSource {
  final ApiClient apiClient;

  RegisterUserDataSourceImpl({required this.apiClient});

  @override
  Future<RegisterUserResponseModel> registerUser(RegisterUserModel registerUserModel) async {
    try {
      final result = await apiClient.request(
        path: '/registeruser',
        data: registerUserModel.toJson(),
      );
      return RegisterUserResponseModel.fromJson(result);
    } catch (e) {
      print('Error in registerUser: $e');
      rethrow;
    }
  }
}

final registerUserDatasourceProvider = Provider<RegisterUserDataSource>((ref) {
  return RegisterUserDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});