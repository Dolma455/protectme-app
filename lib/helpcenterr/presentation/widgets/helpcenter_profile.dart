import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/controller/admin_helpcenter_controller.dart';
import 'package:protectmee/admin/data/models/admin_helpcenter_model.dart';
import 'package:protectmee/utils/app_styles.dart';


class AdminHelpCenters extends ConsumerWidget {
  const AdminHelpCenters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpCenterState = ref.watch(adminHelpCenterControllerProvider);

    // Fetch help centers when the widget is first built
    ref.read(adminHelpCenterControllerProvider.notifier).getHelpCenters();

    return Scaffold(
      appBar: AppBar(title: const Text('Help Centers')),
      body: helpCenterState.when(
        data: (helpCenters) {
          return ListView.builder(
            itemCount: helpCenters.length,
            itemBuilder: (context, index) {
              final HelpCenterModel helpCenter = helpCenters[index];
              return Card(
                color: darkBlueColor.withOpacity(0.6), // Adjust the background color here
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(' ${helpCenter.fullName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(helpCenter.email),
                        Text(helpCenter.phoneNumber),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: blueColor),
                          onPressed: () {
                            _showEditHelpCenterDialog(context, helpCenter, ref);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteHelpCenter(context, helpCenter, ref);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      _showHelpCenterDetails(context, helpCenter);
                    },
                  ),
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHelpCenterDialog(context, ref);
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show Help Center Details Dialog
  void _showHelpCenterDetails(BuildContext context, HelpCenterModel helpCenter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${helpCenter.id}: ${helpCenter.fullName}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Full Name: ${helpCenter.fullName}'),
            Text('Address: ${helpCenter.address}'),
            Text('Email: ${helpCenter.email}'),
            Text('Phone Number: ${helpCenter.phoneNumber}'),
            Text('Latitude: ${helpCenter.latitude}'),
            Text('Longitude: ${helpCenter.longitude}'),
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

  // Show dialog to add Help Center
  void _showAddHelpCenterDialog(BuildContext context, WidgetRef ref) {
    final fullNameController = TextEditingController();
    final addressController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              TextField(controller: latitudeController, decoration: const InputDecoration(labelText: 'Latitude')),
              TextField(controller: longitudeController, decoration: const InputDecoration(labelText: 'Longitude')),
              
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final newHelpCenter = HelpCenterModel(
                        id: 0, // id will be auto-generated by the backend
                        fullName: fullNameController.text,
                        address: addressController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        password: passwordController.text,
                        latitude: double.tryParse(latitudeController.text) ?? 0.0,
                        longitude: double.tryParse(longitudeController.text) ?? 0.0,
                      );
                      try {
                        final message = await ref.read(adminHelpCenterControllerProvider.notifier).addHelpCenter(newHelpCenter);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding help center: $e')));
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show dialog to edit Help Center details
  void _showEditHelpCenterDialog(BuildContext context, HelpCenterModel helpCenter, WidgetRef ref) {
    final fullNameController = TextEditingController(text: helpCenter.fullName);
    final addressController = TextEditingController(text: helpCenter.address);
    final emailController = TextEditingController(text: helpCenter.email);
    final phoneController = TextEditingController(text: helpCenter.phoneNumber);
    final passwordController = TextEditingController(text: helpCenter.password);
    final latitudeController = TextEditingController(text: helpCenter.latitude.toString());
    final longitudeController = TextEditingController(text: helpCenter.longitude.toString());

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: fullNameController, decoration: const InputDecoration(labelText: 'Full Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              TextField(controller: latitudeController, decoration: const InputDecoration(labelText: 'Latitude')),
              TextField(controller: longitudeController, decoration: const InputDecoration(labelText: 'Longitude')),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final updatedHelpCenter = HelpCenterModel(
                        id: helpCenter.id,
                        fullName: fullNameController.text,
                        address: addressController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        password: passwordController.text,
                        latitude: double.tryParse(latitudeController.text) ?? helpCenter.latitude,
                        longitude: double.tryParse(longitudeController.text) ?? helpCenter.longitude,
                      );
                      try {
                        final message = await ref.read(adminHelpCenterControllerProvider.notifier).updateHelpCenter(helpCenter.id, updatedHelpCenter);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating help center: $e')));
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Delete Help Center
  void _deleteHelpCenter(BuildContext context, HelpCenterModel helpCenter, WidgetRef ref) async {
    try {
      final message = await ref.read(adminHelpCenterControllerProvider.notifier).deleteHelpCenter(helpCenter.id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting help center: $e')));
    }
  }
}