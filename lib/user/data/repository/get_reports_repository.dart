import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_source/get_reports_data_source.dart';
import '../models/get_reports_model.dart';

abstract class UserReportsRepository {
  Future<List<ReportModel>> getUserReports(int userId);
}

class UserReportsRepositoryImpl implements UserReportsRepository {
  final UserReportsDataSource dataSource;

  UserReportsRepositoryImpl({required this.dataSource});

  @override
  Future<List<ReportModel>> getUserReports(int userId) async {
    return await dataSource.getUserReports(userId);
  }
}

final userReportsRepositoryProvider = Provider<UserReportsRepository>((ref) {
  return UserReportsRepositoryImpl(dataSource: ref.watch(userReportsDataSourceProvider));
});