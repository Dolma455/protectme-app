import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_helpcenter_model.dart';

abstract class AdminHelpCenterDataSource {
  Future<List<HelpCenterModel>> getHelpCenters();
  Future<void> addHelpCenter(HelpCenterModel helpCenter);
  Future<void> updateHelpCenter(int helpCenterId, HelpCenterModel helpCenter);
  Future<void> deleteHelpCenter(int helpCenterId);
}

class AdminHelpCenterDataSourceImpl implements AdminHelpCenterDataSource {
  final ApiClient apiClient;

  AdminHelpCenterDataSourceImpl({required this.apiClient});

  @override
  Future<List<HelpCenterModel>> getHelpCenters() async {
    final result = await apiClient.request(
      path: '/helpcenters',
      method: 'GET',
    );
    if (result is List) {
      return result.map((e) => HelpCenterModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<void> addHelpCenter(HelpCenterModel helpCenter) async {
    await apiClient.request(
      path: '/registerhelpcenter',
      method: 'POST',
      data: helpCenter.toJson(),
    );
  }

  @override
  Future<void> updateHelpCenter(int helpCenterId, HelpCenterModel helpCenter) async {
    await apiClient.request(
      path: '/helpcenter/$helpCenterId',
      method: 'PUT',
      data: helpCenter.toJson(),
    );
  }

  @override
  Future<void> deleteHelpCenter(int helpCenterId) async {
    await apiClient.request(
      path: '/helpcenter/$helpCenterId',
      method: 'DELETE',
    );
  }
}

final adminHelpCenterDataSourceProvider = Provider<AdminHelpCenterDataSource>((ref) {
  return AdminHelpCenterDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});