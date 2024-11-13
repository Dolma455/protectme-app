import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';

abstract class AdminDataSource {
  Future<int> getTotalUsers();
  Future<int> getTotalReports();
}

class AdminDataSourceImpl implements AdminDataSource {
  final ApiClient apiClient;

  AdminDataSourceImpl({required this.apiClient});

  @override
  Future<int> getTotalUsers() async {
    final result = await apiClient.request(
      path: '/users',
    );
    if (result is List) {
      return result.length;
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<int> getTotalReports() async {
    final result = await apiClient.request(
      path: '/getreports',
    );
    if (result is List) {
      return result.length;
    } else {
      throw Exception('Unexpected API response format');
    }
  }
}

final adminDataSourceProvider = Provider<AdminDataSource>((ref) {
  return AdminDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});