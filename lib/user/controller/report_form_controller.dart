import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/report_form_model.dart';
import '../data/repository/report_form_repository.dart';

class ReportFormController extends StateNotifier<AsyncValue<String>> {
  final ReportRepository reportRepository;

  ReportFormController({required this.reportRepository}) : super(const AsyncValue.data(''));

  Future<String> postReport(ReportFormModel reportModel) async {
    state = const AsyncValue.loading();
    try {
      final message = await reportRepository.postReport(reportModel);
      state = AsyncValue.data(message);
      return message;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return e.toString();
    }
  }
}

final reportFormControllerProvider = StateNotifierProvider<ReportFormController, AsyncValue<String>>((ref) {
  return ReportFormController(reportRepository: ref.watch(reportRepositoryProvider));
});