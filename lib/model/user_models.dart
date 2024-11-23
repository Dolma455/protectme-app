class UserModel {
  final String fullName;
  final String email;
  final String role;

  UserModel({required this.fullName, required this.email, required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
    );
  }
}
