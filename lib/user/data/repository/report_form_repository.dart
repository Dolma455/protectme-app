import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/report_form_data_source.dart';
import '../models/report_form_model.dart';


abstract class ReportRepository {
  Future<ReportFormResponseModel> postReport(ReportFormModel reportModel);
}

class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource reportDataSource;

  ReportRepositoryImpl({required this.reportDataSource});

  @override
  Future<ReportFormResponseModel> postReport(ReportFormModel reportModel) async {
    return await reportDataSource.postReport(reportModel);
  }
}

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  return ReportRepositoryImpl(
    reportDataSource: ref.watch(reportDataSourceProvider),
  );
});