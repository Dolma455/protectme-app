import 'package:flutter/material.dart';
import 'package:protectmee/utils/app_styles.dart';

class HelpCenter {
  String name;
  String address;
  String phoneNumber;

  HelpCenter({
    required this.name,
    required this.address,
    required this.phoneNumber,
  });
}

class AdminHelpCenters extends StatefulWidget {
  const AdminHelpCenters({super.key});

  @override
  _AdminHelpCentersState createState() => _AdminHelpCentersState();
}

class _AdminHelpCentersState extends State<AdminHelpCenters> {
  List<HelpCenter> helpCenters = [
    HelpCenter(name: 'Help Center 1', address: '123 Main St, Kathmandu', phoneNumber: '9800000001'),
    HelpCenter(name: 'Help Center 2', address: '456 Another St, Kathmandu', phoneNumber: '9800000002'),
    // Add more help centers here
  ];

  // Controllers for the TextFields in the dialog
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // List of Help Centers
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Help Centers',
                        style: titleTextStyle,
                      ),
                    
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    helpCenter.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon:  Icon(Icons.edit, color: blueColor),
                                        onPressed: () {
                                          _showEditHelpCenterDialog(context, helpCenter);
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          _deleteHelpCenter(index);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(helpCenter.address),
                                  Text(helpCenter.phoneNumber),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddHelpCenterDialog(context);
        },
        backgroundColor: purpleColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show dialog to add Help Center
  void _showAddHelpCenterDialog(BuildContext context) {
    // Reset text controllers for new help center
    nameController.clear();
    addressController.clear();
    phoneController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Help Center'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                helpCenters.add(HelpCenter(
                  name: nameController.text,
                  address: addressController.text,
                  phoneNumber: phoneController.text,
                ));
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Show dialog to edit Help Center details
  void _showEditHelpCenterDialog(BuildContext context, HelpCenter helpCenter) {
    nameController.text = helpCenter.name;
    addressController.text = helpCenter.address;
    phoneController.text = helpCenter.phoneNumber;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Help Center'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                helpCenter.name = nameController.text;
                helpCenter.address = addressController.text;
                helpCenter.phoneNumber = phoneController.text;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // Delete Help Center
  void _deleteHelpCenter(int index) {
    setState(() {
      helpCenters.removeAt(index);
    });
  }
}