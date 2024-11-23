import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/helpcenterr/data/model/report_model.dart';
import 'package:protectmee/core/api_client.dart';
import 'package:protectmee/utils/app_styles.dart';

class HelpCenterReports extends ConsumerStatefulWidget {
  final String helpCenterName;

  const HelpCenterReports({super.key, required this.helpCenterName});

  @override
  _HelpCenterReportsState createState() => _HelpCenterReportsState();
}

class _HelpCenterReportsState extends ConsumerState<HelpCenterReports> {
  @override
  void initState() {
    super.initState();
    _loadHelpCenterName();
  }

  Future<void> _loadHelpCenterName() async {
    print('Fetching reports for help center: ${widget.helpCenterName}');
    ref.read(reportsControllerProvider(widget.helpCenterName).notifier).getReports();
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsControllerProvider(widget.helpCenterName));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Report History'),
      ),
      body: reportsState.when(
        data: (reports) {
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                color: darkBlueColor,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(report.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(report.incidentType, style: TextStyle(color: Colors.grey[600])),
                      Text(report.policeStation, style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${report.dateTime.toLocal()}'.split(' ')[0]), // Display date
                      Text(report.policeStation),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () async {
                          await ref.read(reportsControllerProvider(widget.helpCenterName).notifier).markAsResolved(report.id);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Status updated successfully')));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await ref.read(reportsControllerProvider(widget.helpCenterName).notifier).deleteReport(report.id);
                        },
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16), // Right arrow icon
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
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showReportDetails(BuildContext context, ReportModel report) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(report.incidentType),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Full Name: ${report.fullName}'),
                Text('Email: ${report.fullName}'),
                Text('Phone Number: ${report.mobileNumber}'),
                Text('Date: ${report.dateTime}'),
                const SizedBox(height: 8),
                Text('Description: ${report.description}'),
                const SizedBox(height: 8),
                Text('Address: ${report.address}'),
                const SizedBox(height: 8),
                Text('Police Station: ${report.policeStation}'),
                const SizedBox(height: 8),
                const Text('Evidence:'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: report.evidenceFilePath.isNotEmpty
                      ? report.evidenceFilePath.map((filePath) {
                          return Image.asset(
                            'assets/eee.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        }).toList()
                      : [
                          Image.asset(
                            'assets/eee.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ],
                ),
                const SizedBox(height: 8),
                Text('Status: ${report.status}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

final reportsControllerProvider = StateNotifierProvider.family<ReportsController, AsyncValue<List<ReportModel>>, String>((ref, helpCenterName) {
  return ReportsController(reportsRepository: ref.watch(reportsRepositoryProvider), helpCenterName: helpCenterName);
});

class ReportsController extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final ReportsRepository reportsRepository;
  final String helpCenterName;

  ReportsController({required this.reportsRepository, required this.helpCenterName}) : super(const AsyncValue.loading()) {
    getReports();
  }

  Future<void> getReports() async {
    try {
      final reports = await reportsRepository.getReportsByHelpCenterName(helpCenterName);
      state = AsyncValue.data(reports);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> markAsResolved(int reportId) async {
    try {
      await reportsRepository.markAsResolved(reportId);
      await getReports(); // Refresh the reports list
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteReport(int reportId) async {
    try {
      await reportsRepository.deleteReport(reportId);
      await getReports(); // Refresh the reports list
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(apiClient: ref.watch(apiClientProvider));
});

class ReportsRepository {
  final ApiClient apiClient;

  ReportsRepository({required this.apiClient});

  Future<List<ReportModel>> getReportsByHelpCenterName(String helpCenterName) async {
    final response = await apiClient.request(
      path: '/getreports/helpcenter/$helpCenterName',
      method: 'GET',
    );

    if (response is List) {
      return response.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }

  Future<void> markAsResolved(int reportId) async {
    await apiClient.request(
      path: '/markassolved/$reportId',
      method: 'POST',
    );
  }

  Future<void> deleteReport(int reportId) async {
    await apiClient.request(
      path: '/reports/$reportId',
      method: 'DELETE',
    );
  }
}