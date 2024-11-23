import '../model/user.dart';
import '../repository/user_repository.dart';

class AuthController {
  final UserRepository userRepository;

  AuthController(this.userRepository);

  Future<Map<String, dynamic>> registerUser(User user) {
    return userRepository.registerUser(user);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) {
    return userRepository.loginUser(email, password);
  }
}
