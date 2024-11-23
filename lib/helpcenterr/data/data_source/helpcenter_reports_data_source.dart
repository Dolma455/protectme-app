
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import 'package:protectmee/user/data/models/get_reports_model.dart';


abstract class ReportDataSource {
  Future<List<ReportModel>> getReports(String helpCenterName);
}

class ReportDataSourceImpl implements ReportDataSource {
  final ApiClient apiClient;

  ReportDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReportModel>> getReports(String helpCenterName) async {
    final result = await apiClient.request(
      path: '/getreports/helpcenter/$helpCenterName',
      method: 'GET',
    );
    if (result is List) {
      return result.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }
}

final reportDataSourceProvider = Provider<ReportDataSource>((ref) {
  return ReportDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});