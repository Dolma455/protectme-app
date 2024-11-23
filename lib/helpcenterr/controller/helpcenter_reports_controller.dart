import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/helpcenterr/data/model/report_model.dart';
import 'package:protectmee/core/api_client.dart';

class ReportsController extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final ReportsRepository reportsRepository;
  final String helpCenterName;

  ReportsController({required this.reportsRepository, required this.helpCenterName}) : super(const AsyncValue.loading()) {
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final reports = await reportsRepository.getReportsByHelpCenterName(helpCenterName);
      state = AsyncValue.data(reports);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final reportsControllerProvider = StateNotifierProvider.family<ReportsController, AsyncValue<List<ReportModel>>, String>((ref, helpCenterName) {
  return ReportsController(reportsRepository: ref.watch(reportsRepositoryProvider), helpCenterName: helpCenterName);
});

class ReportsRepository {
  final ApiClient apiClient;

  ReportsRepository({required this.apiClient});

  Future<List<ReportModel>> getReportsByHelpCenterName(String helpCenterName) async {
    final response = await apiClient.request(
      path: '/getreports/helpcenter/$helpCenterName',
      method: 'GET',
    );

    if (response is List) {
      return response.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(apiClient: ref.watch(apiClientProvider));
});