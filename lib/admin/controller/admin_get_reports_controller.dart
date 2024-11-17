import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/repository/admin_get_reports_repository.dart';
import '../data/models/admin_get_reports_model.dart';

class AdminReportController extends StateNotifier<AsyncValue<List<AdminGetReportModel>>> {
  final AdminReportRepository repository;

  AdminReportController({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getAllReports() async {
    try {
      final reports = await repository.getAllReports();
      state = AsyncValue.data(reports);
    } catch (e) {
      print('Error fetching reports: $e'); // Add logging to check the error
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> createReport(Map<String, dynamic> data) async {
    try {
      await repository.createReport(data);
      await getAllReports(); // Refresh reports after creation
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateReport(int id, Map<String, dynamic> data) async {
    try {
      await repository.updateReport(id, data);
      await getAllReports(); // Refresh reports after update
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteReport(int id) async {
    try {
      await repository.deleteReport(id);
      await getAllReports(); // Refresh reports after deletion
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> markAsSolved(int id) async {
    try {
      await repository.markAsSolved(id);
      await getAllReports(); // Refresh reports after marking as solved
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final adminReportControllerProvider = StateNotifierProvider<AdminReportController, AsyncValue<List<AdminGetReportModel>>>((ref) {
  return AdminReportController(repository: ref.watch(adminReportRepositoryProvider));
});