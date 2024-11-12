import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_get_reports_model.dart';

abstract class AdminReportDataSource {
  Future<List<AdminGetReportModel>> getReports();
}

class AdminReportDataSourceImpl implements AdminReportDataSource {
  final ApiClient apiClient;

  AdminReportDataSourceImpl({required this.apiClient});

  @override
  Future<List<AdminGetReportModel>> getReports() async {
    try {
      final result = await apiClient.request(
        path: 'https://20c6-43-245-93-73.ngrok-free.app/getreports',
      );
       log('API Response: $result'); 

      if (result is List) {
        return result.map((e) => AdminGetReportModel.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Unexpected API response format');
      }
    } catch (e) {
      print('Error in getReports: $e');
      rethrow;
    }
  }
}

final adminReportDataSourceProvider = Provider<AdminReportDataSource>((ref) {
  return AdminReportDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});