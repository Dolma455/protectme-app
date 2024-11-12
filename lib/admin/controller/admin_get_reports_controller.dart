import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/admin_get_reports_model.dart';
import '../data/repository/admin_get_reports_repository.dart';

class AdminReportController extends StateNotifier<AsyncValue<List<AdminGetReportModel>>> {
  final AdminReportRepository repository;

  AdminReportController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getReports() async {
    try {
      final reports = await repository.getReports();
      print('Fetched Reports: $reports'); // Add logging to check the fetched reports
      state = AsyncValue.data(reports);
    } catch (e) {
      print('Error fetching reports: $e'); // Add logging to check the error
    //  state = AsyncValue.error(e);
    }
  }
}

final adminReportControllerProvider = StateNotifierProvider<AdminReportController, AsyncValue<List<AdminGetReportModel>>>((ref) {
  return AdminReportController(repository: ref.watch(adminReportRepositoryProvider));
});