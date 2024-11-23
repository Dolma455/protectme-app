class HelpCenterModel {
  final int id;
  final String fullName;
  final String address;
  final String email;
  final String phoneNumber;
  final String? password;
  final double latitude;
  final double longitude;

  HelpCenterModel({
    required this.id,
    required this.fullName,
    required this.address,
    required this.email,
    required this.phoneNumber,
    this.password,
    required this.latitude,
    required this.longitude,
  });

  factory HelpCenterModel.fromJson(Map<String, dynamic> json) {
    return HelpCenterModel(
      id: json['id'],
      fullName: json['fullName'],
      address: json['address'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'address': address,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}