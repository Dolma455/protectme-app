import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_userlist_model.dart';

abstract class AdminUserDataSource {
  Future<UserModel> getAdmin(String adminId);
  Future<void> updateAdmin(UserModel admin);
}

class AdminUserDataSourceImpl implements AdminUserDataSource {
  final ApiClient apiClient;

  AdminUserDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> getAdmin(String adminId) async {
    final result = await apiClient.request(
      path: '/admin/$adminId',
      method: 'GET',
    );
    if (result is Map<String, dynamic>) {
      return UserModel.fromJson(result);
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<void> updateAdmin(UserModel admin) async {
    await apiClient.request(
      path: '/admin/${admin.id}',
      method: 'PUT',
      data: admin.toJson(),
    );
  }
}

final adminUserDataSourceProvider = Provider<AdminUserDataSource>((ref) {
  return AdminUserDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});