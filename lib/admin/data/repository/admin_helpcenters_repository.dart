import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/admin_helpcenters_data_source.dart';

import '../models/admin_helpcenter_model.dart';


abstract class HelpCenterRepository {
  Future<List<HelpCenterModel>> getHelpCenters();
  Future<String> addHelpCenter(HelpCenterModel helpCenter);
  Future<String> updateHelpCenter(String id, HelpCenterModel helpCenter);
  Future<String> deleteHelpCenter(String id);
}

class HelpCenterRepositoryImpl implements HelpCenterRepository {
  final HelpCenterDataSource dataSource;

  HelpCenterRepositoryImpl({required this.dataSource});

  @override
  Future<List<HelpCenterModel>> getHelpCenters() async {
    return await dataSource.getHelpCenters();
  }

  @override
  Future<String> addHelpCenter(HelpCenterModel helpCenter) async {
    return await dataSource.addHelpCenter(helpCenter);
  }

  @override
  Future<String> updateHelpCenter(String id, HelpCenterModel helpCenter) async {
    return await dataSource.updateHelpCenter(id, helpCenter);
  }

  @override
  Future<String> deleteHelpCenter(String id) async {
    return await dataSource.deleteHelpCenter(id);
  }
}

final helpCenterRepositoryProvider = Provider<HelpCenterRepository>((ref) {
  return HelpCenterRepositoryImpl(dataSource: ref.watch(helpCenterDataSourceProvider));
});