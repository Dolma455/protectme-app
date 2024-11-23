import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/user/data/data_source/report_form_data_source.dart';
import '../models/report_form_model.dart';

class ReportRepository {
  final ReportDataSource dataSource;
  ReportRepository({required this.dataSource});

  Future<String> postReport(ReportFormModel report) async {
    return await dataSource.postReport(report);
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepository(dataSource: ref.watch(reportDataSourceProvider));
});