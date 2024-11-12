import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/utils/app_styles.dart';
import '../../controller/get_reports_controller.dart';
import '../../data/models/get_reports_model.dart';


class UserReports extends ConsumerWidget {
  const UserReports({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const userId = 0; // Replace with actual user ID
    final reportState = ref.watch(reportNotifierProvider);

    // Fetch reports when the widget is first built
    ref.read(reportNotifierProvider.notifier).getReports(userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reports'),
      ),
      body: reportState.when(
        data: (reports) {
          print('Displaying Reports: $reports'); // Add logging to check the displayed reports
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
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error Displaying Reports: $error'); // Add logging to check the error
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }

  void _showReportDetails(BuildContext context, ReportModel report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.incidentType),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Full Name: ${report.fullName}'),
              Text('Mobile Number: ${report.mobileNumber}'),
              Text('Description: ${report.description}'),
              Text('Date: ${report.dateTime.toLocal()}'),
              Text('Address: ${report.address}'),
              Text('Police Station: ${report.policeStation}'),
              Text('Evidence: ${report.evidenceFilePath.join(', ')}'),
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