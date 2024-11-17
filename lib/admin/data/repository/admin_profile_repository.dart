import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/models/admin_userlist_model.dart';

import '../data_source/admin_profile_data_source.dart';

class AdminRepository {
  final AdminUserDataSource dataSource;

  AdminRepository({required this.dataSource});

  Future<UserModel> fetchAdminDetails(String adminId) async {
    return await dataSource.getAdmin(adminId);
  }

  Future<void> updateAdminDetails(UserModel admin) async {
    await dataSource.updateAdmin(admin);
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(
    dataSource: ref.watch(adminUserDataSourceProvider),
  );
});
