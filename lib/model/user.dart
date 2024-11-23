class User {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'password': password,
    };
  }
}
