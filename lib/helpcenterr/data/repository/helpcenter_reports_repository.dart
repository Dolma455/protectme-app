import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import 'package:protectmee/user/data/models/get_reports_model.dart';


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
    } else if (response['statusCode'] == 404) {
      return [];
    } else {
      throw Exception('Unexpected response format');
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(apiClient: ref.watch(apiClientProvider));
});