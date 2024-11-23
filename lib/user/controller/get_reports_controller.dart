import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/user/data/repository/get_reports_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/get_reports_model.dart';

class ReportController extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final ReportRepository reportRepository;

  ReportController({required this.reportRepository}) : super(const AsyncValue.loading());

  Future<void> getReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId') ?? 0; // Default to 0 if not found
      final reports = await reportRepository.getReports(userId);
      state = AsyncValue.data(reports);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final reportControllerProvider = StateNotifierProvider<ReportController, AsyncValue<List<ReportModel>>>((ref) {
  return ReportController(reportRepository: ref.watch(reportRepositoryProvider));
});