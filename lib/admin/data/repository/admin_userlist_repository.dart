import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/admin_userlist_data_source.dart';
import '../models/admin_userlist_model.dart';

abstract class AdminUserRepository {
  Future<List<UserModel>> getUsers();
  Future<void> addUser(UserModel user);
  Future<void> updateUser(int userId, UserModel user);
  Future<void> deleteUser(int userId);
}

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserDataSource dataSource;

  AdminUserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserModel>> getUsers() async {
    return await dataSource.getUsers();
  }

  @override
  Future<void> addUser(UserModel user) async {
    await dataSource.addUser(user);
  }

  @override
  Future<void> updateUser(int userId, UserModel user) async {
    await dataSource.updateUser(userId, user);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await dataSource.deleteUser(userId);
  }
}

final adminUserRepositoryProvider = Provider<AdminUserRepository>((ref) {
  return AdminUserRepositoryImpl(
    dataSource: ref.watch(adminUserDataSourceProvider),
  );
});