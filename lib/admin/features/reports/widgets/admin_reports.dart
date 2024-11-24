import 'package:flutter/material.dart';
import 'package:protectmee/utils/app_styles.dart';

class Report {
  final String incidentType;
  final String description;
  final DateTime dateTime;
  final String policeStation;

  Report({
    required this.incidentType,
    required this.description,
    required this.dateTime,
    required this.policeStation,
  });
}

class AdminReports extends StatelessWidget {
  final List<Report> reports = [
    Report(
      incidentType: 'Theft',
      description: 'Stolen bicycle from the park.',
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      policeStation: 'Station A',
    ),
    Report(
      incidentType: 'Assault',
      description: 'Physical assault reported near the mall.',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      policeStation: 'Station B',
    ),
    // Add more reports here
  ];

  AdminReports({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          color: darkBlueColor.withOpacity(0.6),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.incidentType, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(report.description, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${report.dateTime.toLocal()}'.split(' ')[0]), // Display date
                Text(report.policeStation),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Right arrow icon
            onTap: () {
              _showReportDetails(context, report);
            },
          ),
        );
      },
    );
  }

  void _showReportDetails(BuildContext context, Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.incidentType),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Description: ${report.description}'),
              Text('Date: ${report.dateTime.toLocal()}'),
              Text('Police Station: ${report.policeStation}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
