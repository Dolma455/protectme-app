import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/admin_helpcenters_data_source.dart';
import '../models/admin_helpcenter_model.dart';

abstract class AdminHelpCenterRepository {
  Future<List<HelpCenterModel>> getHelpCenters();
  Future<void> addHelpCenter(HelpCenterModel helpCenter);
  Future<void> updateHelpCenter(int helpCenterId, HelpCenterModel helpCenter);
  Future<void> deleteHelpCenter(int helpCenterId);
}

class AdminHelpCenterRepositoryImpl implements AdminHelpCenterRepository {
  final AdminHelpCenterDataSource dataSource;

  AdminHelpCenterRepositoryImpl({required this.dataSource});

  @override
  Future<List<HelpCenterModel>> getHelpCenters() async {
    return await dataSource.getHelpCenters();
  }

  @override
  Future<void> addHelpCenter(HelpCenterModel helpCenter) async {
    await dataSource.addHelpCenter(helpCenter);
  }

  @override
  Future<void> updateHelpCenter(int helpCenterId, HelpCenterModel helpCenter) async {
    await dataSource.updateHelpCenter(helpCenterId, helpCenter);
  }

  @override
  Future<void> deleteHelpCenter(int helpCenterId) async {
    await dataSource.deleteHelpCenter(helpCenterId);
  }
}

final adminHelpCenterRepositoryProvider = Provider<AdminHelpCenterRepository>((ref) {
  return AdminHelpCenterRepositoryImpl(
    dataSource: ref.watch(adminHelpCenterDataSourceProvider),
  );
});