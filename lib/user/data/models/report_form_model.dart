import 'dart:io';

class ReportFormModel {
  final int id;
  final int userId;
  final String fullName;
  final String mobileNumber;
  final String incidentType;
  final DateTime dateTime;
  final String description;
  final String address;
  final String policeStation;
  final List<File> evidenceFilePath;
  final String status;

  ReportFormModel({
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
    required this.status,
  });

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
      'evidenceFilePath': evidenceFilePath.map((file) => file.path).toList(),
      'status': status,
    };
  }
}