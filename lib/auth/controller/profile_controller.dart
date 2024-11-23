
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/models/login_user_model.dart';

import '../data/repository/profile_repository.dart';

class ProfileController extends StateNotifier<AsyncValue<UserModel>> {
  final ProfileRepository profileRepository;

  ProfileController({required this.profileRepository}) : super(const AsyncValue.loading());

  Future<void> getUserByEmail(String email) async {
    try {
      final user = await profileRepository.getUserByEmail(email);
      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final profileControllerProvider = StateNotifierProvider<ProfileController, AsyncValue<UserModel>>((ref) {
  return ProfileController(profileRepository: ref.watch(profileRepositoryProvider));
});