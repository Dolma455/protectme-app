import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/report_form_model.dart';

abstract class ReportDataSource {
  Future<String> postReport(ReportFormModel report);
}

class ReportDataSourceImpl implements ReportDataSource {
  final ApiClient apiClient;

  ReportDataSourceImpl({required this.apiClient});

  @override
  Future<String> postReport(ReportFormModel report) async {
    final result = await apiClient.request(
      path: '/createreport',
      method: 'POST',
      data: report.toJson(),
    );
    if (result is Map<String, dynamic> && result['message'] != null) {
      return result['message'];
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