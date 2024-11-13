import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/core/api_client.dart';
import '../models/admin_helpcenter_model.dart';


abstract class HelpCenterDataSource {
  Future<List<HelpCenterModel>> getHelpCenters();
  Future<String> addHelpCenter(HelpCenterModel helpCenter);
  Future<String> updateHelpCenter(String id, HelpCenterModel helpCenter);
  Future<String> deleteHelpCenter(String id);
}

class HelpCenterDataSourceImpl implements HelpCenterDataSource {
  final ApiClient apiClient;

  HelpCenterDataSourceImpl({required this.apiClient});

  @override
  Future<List<HelpCenterModel>> getHelpCenters() async {
    final result = await apiClient.request(
      path: 'https://cee7-43-245-93-169.ngrok-free.app/helpcenters',
    );
    if (result is List) {
      return result.map((e) => HelpCenterModel.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Unexpected API response format');
    }
  }

  @override
  Future<String> addHelpCenter(HelpCenterModel helpCenter) async {
    final result = await apiClient.request(
      path: '/registerhelpcenter',
      method: 'POST',
      data: helpCenter.toJson(),
    );
    return result['message'];
  }

  @override
  Future<String> updateHelpCenter(String id, HelpCenterModel helpCenter) async {
    final result = await apiClient.request(
      path: '/helpcenter/$id',
      method: 'PUT',
      data: helpCenter.toJson(),
    );
    return result['message'];
  }

  @override
  Future<String> deleteHelpCenter(String id) async {
    final result = await apiClient.request(
      path: '/helpcenter/$id',
      method: 'DELETE',
    );
    return result['message'];
  }
}

final helpCenterDataSourceProvider = Provider<HelpCenterDataSource>((ref) {
  return HelpCenterDataSourceImpl(
    apiClient: ref.watch(apiClientProvider),
  );
});