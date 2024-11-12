import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/models/user_model.dart';
import '../data/repository/register_user_repository.dart';


class RegisterUserNotifier extends StateNotifier<AsyncValue<RegisterUserResponseModel?>> {
  final RegisterUserRepository registerUserRepository;

  RegisterUserNotifier({required this.registerUserRepository}) : super(const AsyncValue.data(null));

  Future<void> registerUser(RegisterUserModel registerUserModel) async {
    state = const AsyncValue.loading();
    try {
      final result = await registerUserRepository.registerUserRepo(registerUserModel);
      state = result.fold(
        (error) => AsyncValue.error(error.message, StackTrace.current),
        (response) => AsyncValue.data(response),
      );
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final registerUserNotifierProvider = StateNotifierProvider<RegisterUserNotifier, AsyncValue<RegisterUserResponseModel?>>((ref) {
  return RegisterUserNotifier(
    registerUserRepository: ref.watch(registerUserRepositoryProvider),
  );
});