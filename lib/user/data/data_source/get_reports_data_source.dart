import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/get_reports_model.dart';

abstract class ReportDataSource {
  Future<List<ReportModel>> getReports(int userId);
}

class ReportDataSourceImpl implements ReportDataSource {
  final ApiClient apiClient;

  ReportDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReportModel>> getReports(int userId) async {
    final result = await apiClient.request(
      path: '/getreports/user/$userId',
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