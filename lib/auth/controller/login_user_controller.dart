import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/login_user_model.dart';
import '../data/repository/login_user_repository.dart';

class LoginUserController extends StateNotifier<AsyncValue<String>> {
  final LoginUserRepository loginUserRepository;

  LoginUserController({required this.loginUserRepository}) : super(const AsyncValue.data(''));

  Future<String> loginUser(LoginUserModel loginModel) async {
    state = const AsyncValue.loading();
    try {
      final message = await loginUserRepository.loginUser(loginModel);
      state = AsyncValue.data(message);
      return message;
    } catch (e) {
      //state = AsyncValue.error(e);
      return e.toString();
    }
  }
}

final loginUserNotifierProvider = StateNotifierProvider<LoginUserController, AsyncValue<String>>((ref) {
  return LoginUserController(loginUserRepository: ref.watch(loginUserRepositoryProvider));
});