import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/get_reports_model.dart';
import '../data/repository/get_reports_repository.dart';

class ReportNotifier extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final UserReportsRepository repository;

  ReportNotifier({required this.repository}) : super(const AsyncValue.loading());

  Future<void> getReports(int userId) async {
    try {
      final reports = await repository.getUserReports(userId);
      state = AsyncValue.data(reports);
    } catch (e) {
     // state = AsyncValue.error(e);
    }
  }
}

final reportNotifierProvider = StateNotifierProvider<ReportNotifier, AsyncValue<List<ReportModel>>>((ref) {
  return ReportNotifier(repository: ref.watch(userReportsRepositoryProvider));
});