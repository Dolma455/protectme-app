import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/helpcenterr/data/model/report_model.dart';
import 'package:protectmee/utils/app_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protectmee/core/api_client.dart';

class UserReportHistoryWidget extends ConsumerStatefulWidget {
  const UserReportHistoryWidget({super.key});

  @override
  _UserReportHistoryWidgetState createState() => _UserReportHistoryWidgetState();
}

class _UserReportHistoryWidgetState extends ConsumerState<UserReportHistoryWidget> {
  int userId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportsState = ref.watch(reportsControllerProvider(userId));

    return reportsState.when(
      data: (reports) {
        // Apply Quick Sort to reports
        quickSort(reports, 0, reports.length - 1);

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
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
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
                Text('Email: ${report.incidentType}'),
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
                Image.asset('assets/e.jpg', width: 80, height: 80, fit: BoxFit.cover),
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

  // Quick Sort algorithm to sort the reports based on dateTime
  void quickSort(List<ReportModel> reports, int low, int high) {
    if (low < high) {
      int pi = _partition(reports, low, high);
      quickSort(reports, low, pi - 1);  // Before pi
      quickSort(reports, pi + 1, high); // After pi
    }
  }

  int _partition(List<ReportModel> reports, int low, int high) {
    DateTime pivot = reports[high].dateTime; // Using dateTime as pivot
    int i = (low - 1);

    for (int j = low; j < high; j++) {
      // If current report's dateTime is smaller than the pivot
      if (reports[j].dateTime.isBefore(pivot)) {
        i++;
        _swap(reports, i, j);
      }
    }
    _swap(reports, i + 1, high);
    return i + 1;
  }

  void _swap(List<ReportModel> reports, int i, int j) {
    final temp = reports[i];
    reports[i] = reports[j];
    reports[j] = temp;
  }
}

final reportsControllerProvider = StateNotifierProvider.family<ReportsController, AsyncValue<List<ReportModel>>, int>((ref, userId) {
  return ReportsController(reportsRepository: ref.watch(reportsRepositoryProvider), userId: userId);
});

class ReportsController extends StateNotifier<AsyncValue<List<ReportModel>>> {
  final ReportsRepository reportsRepository;
  final int userId;

  ReportsController({required this.reportsRepository, required this.userId}) : super(const AsyncValue.loading()) {
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final reports = await reportsRepository.getReportsByUserId(userId);
      state = AsyncValue.data(reports);
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

  Future<List<ReportModel>> getReportsByUserId(int userId) async {
    final response = await apiClient.request(
      path: '/getreports/user/$userId',
      method: 'GET',
    );

    if (response is List) {
      return response.map((json) => ReportModel.fromJson(json)).toList();
    } else {
      throw Exception('Unexpected response format');
    }
  }
}