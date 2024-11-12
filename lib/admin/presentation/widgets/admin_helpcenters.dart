import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/admin/data/models/admin_helpcenter_model.dart';
import 'package:protectmee/utils/app_styles.dart';
import '../../controller/admin_helpcenter_controller.dart';

class AdminHelpCenters extends ConsumerWidget {
  const AdminHelpCenters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final helpCenterState = ref.watch(helpCenterControllerProvider);

    // Fetch help centers when the widget is first built
    ref.read(helpCenterControllerProvider.notifier).getHelpCenters();

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Help Centers')),
      body: helpCenterState.when(
        data: (helpCenters) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Help Centers', style: titleTextStyle),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: helpCenters.length,
                        itemBuilder: (context, index) {
                          final helpCenter = helpCenters[index];
                          return Card(
                            color: darkBlueColor.withOpacity(0.6),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(helpCenter.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(helpCenter.address),
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
                                      _deleteHelpCenter(context, helpCenter.id!, ref);
                                    },
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showHelpCenterDetails(context, helpCenter);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        title: Text(helpCenter.name),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Address: ${helpCenter.address}'),
            Text('Email: ${helpCenter.email}'),
            Text('Phone Number: ${helpCenter.phoneNumber}'),
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
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
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
                        name: nameController.text,
                        address: addressController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        password: passwordController.text,
                      );
                      try {
                        final message = await ref.read(helpCenterControllerProvider.notifier).addHelpCenter(newHelpCenter);
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
    final nameController = TextEditingController(text: helpCenter.name);
    final addressController = TextEditingController(text: helpCenter.address);
    final emailController = TextEditingController(text: helpCenter.email);
    final phoneController = TextEditingController(text: helpCenter.phoneNumber);
    final passwordController = TextEditingController(text: helpCenter.password);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
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
                        name: nameController.text,
                        address: addressController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                        password: passwordController.text,
                      );
                      try {
                        final message = await ref.read(helpCenterControllerProvider.notifier).updateHelpCenter(helpCenter.id!, updatedHelpCenter);
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
  void _deleteHelpCenter(BuildContext context, String id, WidgetRef ref) async {
    try {
      final message = await ref.read(helpCenterControllerProvider.notifier).deleteHelpCenter(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting help center: $e')));
    }
  }
}