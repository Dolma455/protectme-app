import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/models/login_user_model.dart';
import 'package:protectmee/core/api_client.dart';


abstract class ProfileDataSource {
  Future<UserModel> getUserByEmail(String email);
}

class ProfileDataSourceImpl implements ProfileDataSource {
  final ApiClient apiClient;

  ProfileDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getUserByEmail(String email) async {
    final result = await apiClient.request(
      path: '/user/email/$email',
      method: 'GET',
    );
    if (result is Map<String, dynamic>) {
      return UserModel.fromJson(result);
    } else {
      throw Exception('Unexpected API response format');
    }
  }
}

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return ProfileDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});