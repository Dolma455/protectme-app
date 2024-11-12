import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/report_form_model.dart';
import '../data/repository/report_form_repository.dart';

class ReportNotifier extends StateNotifier<AsyncValue<ReportFormResponseModel?>> {
  final ReportRepository reportRepository;

  ReportNotifier({required this.reportRepository}) : super(const AsyncValue.data(null));

  Future<void> postReport(ReportFormModel reportModel) async {
    state = const AsyncValue.loading();
    try {
      final result = await reportRepository.postReport(reportModel);
      state = AsyncValue.data(result);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final reportNotifierProvider = StateNotifierProvider<ReportNotifier, AsyncValue<ReportFormResponseModel?>>((ref) {
  return ReportNotifier(
    reportRepository: ref.watch(reportRepositoryProvider),
  );
});