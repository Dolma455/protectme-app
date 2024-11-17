import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_userlist_model.dart';

abstract class AdminUserDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> addUser(UserModel user);
  Future<void> updateUser(int userId, UserModel user);
  Future<void> deleteUser(int userId);
}

class AdminUserDataSourceImpl implements AdminUserDataSource {
  final ApiClient apiClient;

  AdminUserDataSourceImpl({required this.apiClient});

  @override
  Future<List<UserModel>> getUsers() async {
    final result = await apiClient.request(
      path: '/users',
      method: 'GET',
    );
    if (result is List) {
      return result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<void> addUser(UserModel user) async {
    await apiClient.request(
      path: '/registeruser',
      method: 'POST',
      data: user.toJson(),
    );
  }

  @override
  Future<void> updateUser(int userId, UserModel user) async {
    await apiClient.request(
      path: '/user/$userId',
      method: 'PUT',
      data: user.toJson(),
    );
  }

  @override
  Future<void> deleteUser(int userId) async {
    await apiClient.request(
      path: '/user/$userId',
      method: 'DELETE',
    );
  }
}

final adminUserDataSourceProvider = Provider<AdminUserDataSource>((ref) {
  return AdminUserDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});