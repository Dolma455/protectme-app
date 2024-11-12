import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/admin_userlist_data_source.dart';
import '../models/admin_userlist_model.dart';

abstract class UserRepository {
  Future<List<UserModel>> getUsers();
  Future<String> addUser(UserModel user);
  Future<String> updateUser(String id, UserModel user);
  Future<String> deleteUser(String id);
}

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl({required this.dataSource});

  @override
  Future<List<UserModel>> getUsers() async {
    return await dataSource.getUsers();
  }

  @override
  Future<String> addUser(UserModel user) async {
    return await dataSource.addUser(user);
  }

  @override
  Future<String> updateUser(String id, UserModel user) async {
    return await dataSource.updateUser(id, user);
  }

  @override
  Future<String> deleteUser(String id) async {
    return await dataSource.deleteUser(id);
  }
}

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(dataSource: ref.watch(userDataSourceProvider));
});