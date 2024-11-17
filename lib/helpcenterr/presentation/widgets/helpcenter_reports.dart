import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/helpcenterr/controller/helpcenter_reports_controller.dart';
import 'package:protectmee/helpcenterr/data/model/report_model.dart';
import 'package:protectmee/utils/app_styles.dart';


class HelpCenterreports extends ConsumerStatefulWidget {
  const HelpCenterreports({super.key});

  @override
  ConsumerState<HelpCenterreports> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends ConsumerState<HelpCenterreports> {
  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    await ref.read(reportControllerProvider.notifier).getReportsByHelpCenter('Kathmandu');
  }

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(reportControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: reportState.when(
        data: (reports) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                color: darkBlueColor.withOpacity(0.6),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Text(report.incidentType, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.description, style: TextStyle(color: Colors.grey[600])),
                      Text('Status: ${report.status}', style: TextStyle(color: Colors.grey[600])),
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Full Name: ${report.fullName}'),
            Text('Mobile Number: ${report.mobileNumber}'),
            Text('Description: ${report.description}'),
            Text('Date: ${report.dateTime.toLocal()}'),
            Text('Address: ${report.address}'),
            Text('Police Station: ${report.policeStation}'),
            Text('Evidence: ${report.evidenceFilePath.join(', ')}'),
            Text('Status: ${report.status}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}