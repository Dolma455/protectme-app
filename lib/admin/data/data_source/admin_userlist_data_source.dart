import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/models/admin_userlist_model.dart';
import 'package:protectmee/core/api_client.dart';


abstract class UserDataSource {
  Future<List<UserModel>> getUsers();
  Future<String> addUser(UserModel user);
  Future<String> updateUser(String id, UserModel user);
  Future<String> deleteUser(String id);
}

class UserDataSourceImpl implements UserDataSource {
  final ApiClient apiClient;

  UserDataSourceImpl({required this.apiClient});

  @override
  Future<List<UserModel>> getUsers() async {
    final result = await apiClient.request(
      path: 'https://20c6-43-245-93-73.ngrok-free.app/users',
    );
    print('API Response: $result'); // Add logging to check the API response
    if (result is List) {
      return result.map((e) => UserModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<String> addUser(UserModel user) async {
    final result = await apiClient.request(
      path: 'https://20c6-43-245-93-73.ngrok-free.app/registeruser',
      method: 'POST',
      data: user.toJson(),
    );
    return result['message'];
  }

  @override
  Future<String> updateUser(String id, UserModel user) async {
    final result = await apiClient.request(
      path: 'https://20c6-43-245-93-73.ngrok-free.app/user/$id',
      method: 'PUT',
      data: user.toJson(),
    );
    return result['message'];
  }

  @override
  Future<String> deleteUser(String id) async {
    final result = await apiClient.request(
      path: 'https://20c6-43-245-93-73.ngrok-free.app/user/$id',
      method: 'DELETE',
    );
    return result['message'];
  }
}

final userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});