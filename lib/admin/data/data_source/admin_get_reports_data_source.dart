import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_get_reports_model.dart';

abstract class AdminReportDataSource {
  Future<List<AdminGetReportModel>> getAllReports();
  Future<void> createReport(Map<String, dynamic> data);
  Future<void> updateReport(int id, Map<String, dynamic> data);
  Future<void> deleteReport(int id);
  Future<void> markAsSolved(int id);
}

class AdminReportDataSourceImpl implements AdminReportDataSource {
  final ApiClient apiClient;

  AdminReportDataSourceImpl({required this.apiClient});

  @override
  Future<List<AdminGetReportModel>> getAllReports() async {
    final result = await apiClient.request(
      path: '/getreports', // Ensure this endpoint is correct
      method: 'GET',
    );
    if (result is List) {
      return result.map((json) => AdminGetReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<void> createReport(Map<String, dynamic> data) async {
    await apiClient.request(
      path: '/createreport',
      method: 'POST',
      data: data,
    );
  }

  @override
  Future<void> updateReport(int id, Map<String, dynamic> data) async {
    await apiClient.request(
      path: '/updatereport/$id',
      method: 'PUT',
      data: data,
    );
  }

  @override
  Future<void> deleteReport(int id) async {
    await apiClient.request(
      path: '/deletereport/$id',
      method: 'DELETE',
    );
  }

  @override
  Future<void> markAsSolved(int id) async {
    await apiClient.request(
      path: '/markassolved/$id',
      method: 'PUT', // Ensure this method is correct
    );
  }
}

final adminReportDataSourceProvider = Provider<AdminReportDataSource>((ref) {
  return AdminReportDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});