import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/utils/app_styles.dart';
import '../../controller/admin_get_reports_controller.dart';
import '../../controller/admin_controller.dart';
import '../../data/models/admin_get_reports_model.dart';

class AdminsHome extends ConsumerStatefulWidget {
  const AdminsHome({super.key});

  @override
  ConsumerState<AdminsHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends ConsumerState<AdminsHome> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController incidentTypeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController policeStationController = TextEditingController();
  final TextEditingController evidenceFilePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final reportState = ref.watch(adminReportControllerProvider);
    final totalCountsState = ref.watch(adminControllerProvider);

    // Fetch reports and total counts when the widget is first built
    ref.read(adminReportControllerProvider.notifier).getAllReports();
    ref.read(adminControllerProvider.notifier).getTotalCounts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;

          return SingleChildScrollView(
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
                                    ],
                                  ),
                                  subtitle: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                    //  Text('Date: ${report.dateTime.toLocal()}'),
                                      Text(' ${report.status}'),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.check, color: Colors.green),
                                        onPressed: () async {
                                          await ref.read(adminReportControllerProvider.notifier).markAsSolved(report.id);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () {
                                          _showUpdateReportDialog(context, report);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () async {
                                          await ref.read(adminReportControllerProvider.notifier).deleteReport(report.id);
                                        },
                                      ),
                                    ],
                                  ),
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
          );
        },
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
             Image.asset('assets/e.jpg', width: 80, height: 80, fit: BoxFit.cover),
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

  void _showUpdateReportDialog(BuildContext context, AdminGetReportModel report) {
    final fullNameController = TextEditingController(text: report.fullName);
    final mobileNumberController = TextEditingController(text: report.mobileNumber);
    final incidentTypeController = TextEditingController(text: report.incidentType);
    final descriptionController = TextEditingController(text: report.description);
    final addressController = TextEditingController(text: report.address);
    final policeStationController = TextEditingController(text: report.policeStation);
    final evidenceFilePathController = TextEditingController(text: report.evidenceFilePath.join(', '));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Report'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: mobileNumberController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
              ),
              TextField(
                controller: incidentTypeController,
                decoration: const InputDecoration(labelText: 'Incident Type'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: policeStationController,
                decoration: const InputDecoration(labelText: 'Police Station'),
              ),
              TextField(
                controller: evidenceFilePathController,
                decoration: const InputDecoration(labelText: 'Evidence File Path'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final data = {
                'fullName': fullNameController.text,
                'mobileNumber': mobileNumberController.text,
                'incidentType': incidentTypeController.text,
                'description': descriptionController.text,
                'address': addressController.text,
                'policeStation': policeStationController.text,
                'evidenceFilePath': evidenceFilePathController.text.split(', '),
                'status': report.status,
              };
              await ref.read(adminReportControllerProvider.notifier).updateReport(report.id, data);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}