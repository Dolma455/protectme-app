import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/models/admin_userlist_model.dart';
import '../data/repository/admin_profile_repository.dart';


class AdminProfileController extends StateNotifier<AsyncValue<UserModel>> {
  final AdminRepository repository;

  AdminProfileController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> fetchAdminDetails(String adminId) async {
    state = const AsyncValue.loading();
    try {
      final admin = await repository.fetchAdminDetails(adminId);
      state = AsyncValue.data(admin);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateAdminDetails(UserModel admin) async {
    try {
      await repository.updateAdminDetails(admin);
      state = AsyncValue.data(admin);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final adminProfileControllerProvider = StateNotifierProvider.family<AdminProfileController, AsyncValue<UserModel>, String>((ref, adminId) {
  return AdminProfileController(repository: ref.watch(adminRepositoryProvider))..fetchAdminDetails(adminId);
});