import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/admin_helpcenter_model.dart';
import '../data/repository/admin_helpcenters_repository.dart';

class HelpCenterController extends StateNotifier<AsyncValue<List<HelpCenterModel>>> {
  final HelpCenterRepository repository;

  HelpCenterController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getHelpCenters() async {
    try {
      final helpCenters = await repository.getHelpCenters();
      state = AsyncValue.data(helpCenters);
    } catch (e) {
     // state = AsyncValue.error(e);
    }
  }

  Future<String> addHelpCenter(HelpCenterModel helpCenter) async {
    try {
      final message = await repository.addHelpCenter(helpCenter);
      await getHelpCenters(); // Refresh the help center list
      return message;
    } catch (e) {
      throw e;
    }
  }

  Future<String> updateHelpCenter(String id, HelpCenterModel helpCenter) async {
    try {
      final message = await repository.updateHelpCenter(id, helpCenter);
      await getHelpCenters(); // Refresh the help center list
      return message;
    } catch (e) {
      throw e;
    }
  }

  Future<String> deleteHelpCenter(String id) async {
    try {
      final message = await repository.deleteHelpCenter(id);
      await getHelpCenters(); // Refresh the help center list
      return message;
    } catch (e) {
      throw e;
    }
  }
}

final helpCenterControllerProvider = StateNotifierProvider<HelpCenterController, AsyncValue<List<HelpCenterModel>>>((ref) {
  return HelpCenterController(repository: ref.watch(helpCenterRepositoryProvider));
});