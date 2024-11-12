import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';

import '../models/report_form_model.dart';


abstract class ReportDataSource {
  Future<ReportFormResponseModel> postReport(ReportFormModel reportModel);
}

class ReportDataSourceImpl implements ReportDataSource {
  final ApiClient apiClient;

  ReportDataSourceImpl({required this.apiClient});

  @override
  Future<ReportFormResponseModel> postReport(ReportFormModel reportModel) async {
    try {
      final result = await apiClient.request(
        path: '/postreport',
        method: 'POST',
        data: reportModel.toJson(),
      );
      return ReportFormResponseModel.fromJson(result);
    } catch (e) {
      print('Error in postReport: $e');
      rethrow;
    }
  }
}

final reportDataSourceProvider = Provider<ReportDataSource>((ref) {
  return ReportDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});