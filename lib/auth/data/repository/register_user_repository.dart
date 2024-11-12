

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/data/data_source/register_user_data_source.dart';
import 'package:protectmee/auth/data/models/user_model.dart';

import '../../../core/app_error.dart';
import '../../../core/exception_handle.dart';

abstract class RegisterUserRepository {
 

  Future<Either<AppError, RegisterUserResponseModel>> registerUserRepo(
      RegisterUserModel registerUserModel);
  
}

class RegisterUserRepositoryImpl implements RegisterUserRepository {
  final RegisterUserDataSource registerUserDataSource;
  RegisterUserRepositoryImpl({
    required this.registerUserDataSource,
  });

  @override
  Future<Either<AppError, RegisterUserResponseModel>> registerUserRepo(
      RegisterUserModel registerUserModel) async {
    try {
      final data =
          await registerUserDataSource.registerUser(registerUserModel);
      return Right(data);
    } on DioExceptionHandle catch (e) {
      return Left(
        AppError(message: e.message),
      );
    }
  }

}

final registerUserRepositoryProvider = Provider<RegisterUserRepository>((ref) {
  return RegisterUserRepositoryImpl(
    registerUserDataSource: ref.watch(registerUserDatasourceProvider),
  );
});
