import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/models/login_user_model.dart';
import '../data_source/profile_data_source.dart';


class ProfileRepository {
  final ProfileDataSource dataSource;

  ProfileRepository({required this.dataSource});

  Future<UserModel> getUserByEmail(String email) async {
    return await dataSource.getUserByEmail(email);
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(dataSource: ref.watch(profileDataSourceProvider));
});