class AdminGetReportModel {
  final int id;
  final int userId;
  final String fullName;
  final String mobileNumber;
  final String incidentType;
  final DateTime dateTime;
  final String description;
  final String address;
  final String policeStation;
  final List<String> evidenceFilePath;
  final String status; // Add the status field

  AdminGetReportModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.mobileNumber,
    required this.incidentType,
    required this.dateTime,
    required this.description,
    required this.address,
    required this.policeStation,
    required this.evidenceFilePath,
    required this.status, // Add the status field
  });

  factory AdminGetReportModel.fromJson(Map<String, dynamic> json) {
    return AdminGetReportModel(
      id: json['id'],
      userId: json['userId'],
      fullName: json['fullName'],
      mobileNumber: json['mobileNumber'],
      incidentType: json['incidentType'],
      dateTime: DateTime.parse(json['dateTime']),
      description: json['description'],
      address: json['address'],
      policeStation: json['policeStation'],
      evidenceFilePath: List<String>.from(json['evidenceFilePath']),
      status: json['status'], // Add the status field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'mobileNumber': mobileNumber,
      'incidentType': incidentType,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'address': address,
      'policeStation': policeStation,
      'evidenceFilePath': evidenceFilePath,
      'status': status, // Add the status field
    };
  }
}