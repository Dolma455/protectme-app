import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/get_reports_model.dart';


abstract class UserReportsDataSource {
  Future<List<ReportModel>> getUserReports(int userId);
}

class UserReportsDataSourceImpl implements UserReportsDataSource {
  final ApiClient apiClient;

  UserReportsDataSourceImpl({required this.apiClient});

  @override
  Future<List<ReportModel>> getUserReports(int userId) async {
    final result = await apiClient.request(
      path: 'https://20c6-43-245-93-73.ngrok-free.app/getreports/$userId',
    );
    if (result is List) {
      return result.map((e) => ReportModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }
}

final userReportsDataSourceProvider = Provider<UserReportsDataSource>((ref) {
  return UserReportsDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});