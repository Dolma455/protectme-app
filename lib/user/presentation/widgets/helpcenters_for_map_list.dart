import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:protectmee/admin/controller/admin_helpcenter_controller.dart';

class HelpCenter {
  final String name;
  final LatLng location;

  HelpCenter({required this.name, required this.location});
}

class HelpCenterList extends ConsumerWidget {
  const HelpCenterList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpCenterState = ref.watch(adminHelpCenterControllerProvider);

    // Fetch help centers when the widget is first built
    ref.read(adminHelpCenterControllerProvider.notifier).getHelpCenters();

    return Scaffold(
      appBar: AppBar(title: const Text('Help Centers')),
      body: helpCenterState.when(
        data: (helpCenters) {
          // Convert HelpCenterModel to HelpCenter with name and LatLng only
          final helpCenterList = helpCenters.map((helpCenter) {
            return HelpCenter(
              name: helpCenter.fullName,
              location: LatLng(helpCenter.latitude, helpCenter.longitude),
            );
          }).toList();

          // Display the formatted list
          return ListView.builder(
            itemCount: helpCenterList.length,
            itemBuilder: (context, index) {
              final helpCenter = helpCenterList[index];
              return ListTile(
                title: Text(helpCenter.name),
                subtitle: Text('Location: ${helpCenter.location.latitude}, ${helpCenter.location.longitude}'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          print('Error Displaying Help Centers: $error'); // Add logging to check the error
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}