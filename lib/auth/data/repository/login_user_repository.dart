import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data_source/login_user_data_source.dart';
import '../models/login_user_model.dart';

abstract class LoginUserRepository {
  Future<String> loginUser(LoginUserModel loginModel);
}

class LoginUserRepositoryImpl implements LoginUserRepository {
  final LoginUserDataSource loginUserDataSource;

  LoginUserRepositoryImpl({required this.loginUserDataSource});

  @override
  Future<String> loginUser(LoginUserModel loginModel) async {
    return await loginUserDataSource.loginUser(loginModel);
  }
}

final loginUserRepositoryProvider = Provider<LoginUserRepository>((ref) {
  return LoginUserRepositoryImpl(
    loginUserDataSource: ref.watch(loginUserDataSourceProvider),
  );
});