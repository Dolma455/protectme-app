import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/admin_get_reports_data_source.dart';
import '../models/admin_get_reports_model.dart';

abstract class AdminReportRepository {
  Future<List<AdminGetReportModel>> getReports();
}

class AdminReportRepositoryImpl implements AdminReportRepository {
  final AdminReportDataSource dataSource;

  AdminReportRepositoryImpl({required this.dataSource});

  @override
  Future<List<AdminGetReportModel>> getReports() async {
    return await dataSource.getReports();
  }
}

final adminReportRepositoryProvider = Provider<AdminReportRepository>((ref) {
  return AdminReportRepositoryImpl(dataSource: ref.watch(adminReportDataSourceProvider));
});