import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/repository/admin_userlist_repository.dart';
import '../data/models/admin_userlist_model.dart';


class AdminUserListController extends StateNotifier<AsyncValue<List<UserModel>>> {
  final AdminUserRepository repository;

  AdminUserListController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await repository.getUsers();
      state = AsyncValue.data(users);
    } catch (e) {
      //state = AsyncValue.error(e);
    }
  }

  Future<String> addUser(UserModel user) async {
    try {
      await repository.addUser(user);
      await getUsers(); // Refresh the user list
      return 'User added successfully';
    } catch (e) {
      return 'Error adding user: $e';
    }
  }

  Future<String> updateUser(int userId, UserModel user) async {
    try {
      await repository.updateUser(userId, user);
      await getUsers(); // Refresh the user list
      return 'User updated successfully';
    } catch (e) {
      return 'Error updating user: $e';
    }
  }

  Future<String> deleteUser(int userId) async {
    try {
      await repository.deleteUser(userId);
      await getUsers(); // Refresh the user list
      return 'User deleted successfully';
    } catch (e) {
      return 'Error deleting user: $e';
    }
  }
}

final adminUserListControllerProvider = StateNotifierProvider<AdminUserListController, AsyncValue<List<UserModel>>>((ref) {
  return AdminUserListController(repository: ref.watch(adminUserRepositoryProvider));
});