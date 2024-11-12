import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/login_user_model.dart';
import '../data/repository/login_user_repository.dart';

class LoginUserController extends StateNotifier<AsyncValue<String>> {
  final AuthRepository authRepository;

  LoginUserController({required this.authRepository}) : super(const AsyncValue.loading());

  Future<String> loginUser(LoginUserModel loginModel) async {
    state = const AsyncValue.loading();
    try {
      final message = await authRepository.loginUser(loginModel);
      state = AsyncValue.data(message);
      return message;
    } catch (e) {
      //state = AsyncValue.error(e);
      return e.toString();
    }
  }
}

final loginUserNotifierProvider = StateNotifierProvider<LoginUserController, AsyncValue<String>>((ref) {
  return LoginUserController(authRepository: ref.watch(authRepositoryProvider));
});