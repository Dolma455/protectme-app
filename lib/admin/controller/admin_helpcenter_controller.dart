import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/admin_helpcenter_model.dart';
import '../data/repository/admin_helpcenters_repository.dart';


class AdminHelpCenterController extends StateNotifier<AsyncValue<List<HelpCenterModel>>> {
  final AdminHelpCenterRepository repository;

  AdminHelpCenterController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getHelpCenters() async {
    state = const AsyncValue.loading();
    try {
      final helpCenters = await repository.getHelpCenters();
      state = AsyncValue.data(helpCenters);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<String> addHelpCenter(HelpCenterModel helpCenter) async {
    try {
      await repository.addHelpCenter(helpCenter);
      await getHelpCenters(); // Refresh the help center list
      return 'Help Center added successfully';
    } catch (e) {
      return 'Error adding help center: $e';
    }
  }

  Future<String> updateHelpCenter(int helpCenterId, HelpCenterModel helpCenter) async {
    try {
      await repository.updateHelpCenter(helpCenterId, helpCenter);
      await getHelpCenters(); // Refresh the help center list
      return 'Help Center updated successfully';
    } catch (e) {
      return 'Error updating help center: $e';
    }
  }

  Future<String> deleteHelpCenter(int helpCenterId) async {
    try {
      await repository.deleteHelpCenter(helpCenterId);
      await getHelpCenters(); // Refresh the help center list
      return 'Help Center deleted successfully';
    } catch (e) {
      return 'Error deleting help center: $e';
    }
  }
}

final adminHelpCenterControllerProvider = StateNotifierProvider<AdminHelpCenterController, AsyncValue<List<HelpCenterModel>>>((ref) {
  return AdminHelpCenterController(repository: ref.watch(adminHelpCenterRepositoryProvider));
});