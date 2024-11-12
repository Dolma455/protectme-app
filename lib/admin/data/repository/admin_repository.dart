import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/admin_data_source.dart';

abstract class AdminRepository {
  Future<int> getTotalUsers();
  Future<int> getTotalReports();
}

class AdminRepositoryImpl implements AdminRepository {
  final AdminDataSource dataSource;

  AdminRepositoryImpl({required this.dataSource});

  @override
  Future<int> getTotalUsers() async {
    return await dataSource.getTotalUsers();
  }

  @override
  Future<int> getTotalReports() async {
    return await dataSource.getTotalReports();
  }
}

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(dataSource: ref.watch(adminDataSourceProvider));
});