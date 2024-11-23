import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/user/data/data_source/get_reports_data_source.dart';
import '../models/get_reports_model.dart';

class ReportRepository {
  final ReportDataSource dataSource;

  ReportRepository({required this.dataSource});

  Future<List<ReportModel>> getReports(int userId) async {
    return await dataSource.getReports(userId);
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(dataSource: ref.watch(reportDataSourceProvider));
});