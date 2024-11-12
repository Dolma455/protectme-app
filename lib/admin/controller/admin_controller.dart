import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/admin_repository.dart';

class AdminController extends StateNotifier<AsyncValue<Map<String, int>>> {
  final AdminRepository repository;

  AdminController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getTotalCounts() async {
    try {
      final totalUsers = await repository.getTotalUsers();
      final totalReports = await repository.getTotalReports();
      state = AsyncValue.data({
        'totalUsers': totalUsers,
        'totalReports': totalReports,
      });
    } catch (e) {
    //  state = AsyncValue.error(e);
    }
  }
}

final adminControllerProvider = StateNotifierProvider<AdminController, AsyncValue<Map<String, int>>>((ref) {
  return AdminController(repository: ref.watch(adminRepositoryProvider));
});