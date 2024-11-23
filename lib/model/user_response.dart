class UserResponse {
  final String message;
  final String role; // Add a role field to represent the user’s role.

  UserResponse({required this.message, required this.role});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'],
      role: json['role'],
    );
  }
}
