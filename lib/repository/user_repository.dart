import '../model/user.dart';
import '../services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<Map<String, dynamic>> registerUser(User user) {
    return apiService.registerUser(user);
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) {
    return apiService.loginUser(email, password);
  }
}
