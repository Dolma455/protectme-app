class RegisterUserModel {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String password;

  RegisterUserModel({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.password,
  });

 
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


class RegisterUserResponseModel {
  final String? message;
  final RegisterUserModel? user;

  RegisterUserResponseModel({ 
    this.message,
    this.user,
  });

  factory RegisterUserResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterUserResponseModel(
      message: json['message'] ??"",
     
    );
  }
}