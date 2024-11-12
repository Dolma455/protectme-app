class HelpCenterModel {
  final String? id;
  final String name;
  final String address;
  final String email;
  final String phoneNumber;
  final String? password;

  HelpCenterModel({
    this.id,
    required this.name,
    required this.address,
    required this.email,
    required this.phoneNumber,
    this.password,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }
}