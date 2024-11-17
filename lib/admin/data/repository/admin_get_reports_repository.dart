import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/data_source/admin_get_reports_data_source.dart';
import '../models/admin_get_reports_model.dart';

class AdminReportRepository {
  final AdminReportDataSource dataSource;

  AdminReportRepository({required this.dataSource});

  Future<List<AdminGetReportModel>> getAllReports() async {
    return await dataSource.getAllReports();
  }

  Future<void> createReport(Map<String, dynamic> data) async {
    await dataSource.createReport(data);
  }

  Future<void> updateReport(int id, Map<String, dynamic> data) async {
    await dataSource.updateReport(id, data);
  }

  Future<void> deleteReport(int id) async {
    await dataSource.deleteReport(id);
  }

  Future<void> markAsSolved(int id) async {
    await dataSource.markAsSolved(id);
  }
}

final adminReportRepositoryProvider = Provider<AdminReportRepository>((ref) {
  return AdminReportRepository(dataSource: ref.watch(adminReportDataSourceProvider));
});