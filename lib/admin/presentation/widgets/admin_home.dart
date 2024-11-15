import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/utils/app_styles.dart';
import '../../controller/admin_get_reports_controller.dart';
import '../../controller/admin_controller.dart';
import '../../data/models/admin_get_reports_model.dart';

class AdminHome extends ConsumerWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportState = ref.watch(adminReportControllerProvider);
    final totalCountsState = ref.watch(adminControllerProvider);

    // Fetch reports and total counts when the widget is first built
    ref.read(adminReportControllerProvider.notifier).getReports();
    ref.read(adminControllerProvider.notifier).getTotalCounts();

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Row for Total Users and Total Reports Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: totalCountsState.when(
                data: (totalCounts) {
                  final totalUsers = totalCounts['totalUsers'] ?? 0;
                  final totalReports = totalCounts['totalReports'] ?? 0;

                  return Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text("Total Users", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("$totalUsers", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16), // Space between cards
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                const Text("Total Reports", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text("$totalReports", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) {
                  print('Error fetching total counts: $error'); // Add logging to check the error
                  return Center(child: Text('Error: $error'));
                },
              ),
            ),
            const SizedBox(height: 30),

            // List of Reports
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reports',
                    style: headingStyle,
                  ),
                  const SizedBox(height: 10),
                  reportState.when(
                    data: (reports) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final AdminGetReportModel report = reports[index];
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDetails(BuildContext context, AdminGetReportModel report) {
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