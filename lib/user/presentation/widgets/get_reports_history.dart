import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/helpcenterr/data/model/report_model.dart';
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
              return ListTile(
                title: Text(report.incidentType),
                subtitle: Text(report.dateTime.toString()),
                onTap: () {
                  _showReportDetails(context, report);
                },
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
                Text('Date: ${report.dateTime}'),
                const SizedBox(height: 8),
                Text('Description: ${report.description}'),
                const SizedBox(height: 8),
                Text('Details: ${report.description}'),
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