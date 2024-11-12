import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/admin_userlist_model.dart';
import '../data/repository/admin_userlist_repository.dart';

class UserController extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepository repository;

  UserController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getUsers() async {
    try {
      final users = await repository.getUsers();
      print('Fetched Users: $users'); // Add logging to check the fetched users
      state = AsyncValue.data(users);
    } catch (e) {
      print('Error fetching users: $e'); // Add logging to check the error
      //state = AsyncValue.error(e);
    }
  }

  Future<String> addUser(UserModel user) async {
    try {
      final message = await repository.addUser(user);
      await getUsers(); // Refresh the user list
      return message;
    } catch (e) {
      print('Error adding user: $e'); // Add logging to check the error
      throw e;
    }
  }

  Future<String> updateUser(String id, UserModel user) async {
    try {
      final message = await repository.updateUser(id, user);
      await getUsers(); // Refresh the user list
      return message;
    } catch (e) {
      print('Error updating user: $e'); // Add logging to check the error
      throw e;
    }
  }

  Future<String> deleteUser(String id) async {
    try {
      final message = await repository.deleteUser(id);
      await getUsers(); // Refresh the user list
      return message;
    } catch (e) {
      print('Error deleting user: $e'); // Add logging to check the error
      throw e;
    }
  }
}

final userControllerProvider = StateNotifierProvider<UserController, AsyncValue<List<UserModel>>>((ref) {
  return UserController(repository: ref.watch(userRepositoryProvider));
});