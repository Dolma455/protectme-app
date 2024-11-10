import 'package:flutter/material.dart';
import 'package:protectmee/utils/app_styles.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<UserProfile> {
  bool _isViewDetailsExpanded = false;
  bool _isManageContactsExpanded = false;
  final TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildExpandableCard(
          title: 'View Details',
          description: 'See your profile information',
          child: const Column(
            children: [
              Text('Name: John Doe'),
              Text('Email: john.doe@example.com'),
              // Add more details as needed
            ],
          ),
          onTap: () {
            setState(() {
              _isViewDetailsExpanded = !_isViewDetailsExpanded;
            });
          },
          isExpanded: _isViewDetailsExpanded,
        ),
        spacing1,
        _buildExpandableCard(
          title: 'Manage Emergency Contacts',
          description: 'Set your emergency contact numbers',
          child: Column(
            children: [
              const Text('Set your emergency contact number:'),
              const SizedBox(height: 10),
              TextField(
                controller: numberController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Number',
                  border: OutlineInputBorder(),
                  prefixText: '+977 ', // Change this to your country code
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save the number
                  String emergencyNumber = numberController.text;
                  print('Emergency Number Set: $emergencyNumber');
                  // Optionally clear the text field after saving
                  numberController.clear();
                },
                child: const Text('Save'),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _isManageContactsExpanded = !_isManageContactsExpanded;
            });
          },
          isExpanded: _isManageContactsExpanded,
        ),
        spacing1,
        _buildCard(
          title: 'Logout',
          description: 'Log out of your account',
          onTap: () {
            _logout(context);
          },
        ),
      ],
    );
  }

  Widget _buildExpandableCard({
    required String title,
    required String description,
    required Widget child,
    required VoidCallback onTap,
    required bool isExpanded,
  }) {
    return Card(
      color: darkBlueColor.withOpacity(0.6),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.arrow_drop_down), // Arrow icon for expansion
        onExpansionChanged: (bool expanding) => onTap(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      color: darkBlueColor.withOpacity(0.6),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: TextStyle(color: Colors.grey[600])),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Right arrow icon
        onTap: onTap,
      ),
    );
  }
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout Confirmation'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Add your logout logic here
              Navigator.of(context).pop(); 
            },
            child: Text('Yes', style: TextStyle(color: blueColor)),
          ),
        ],
      ),
    );
  }
}
