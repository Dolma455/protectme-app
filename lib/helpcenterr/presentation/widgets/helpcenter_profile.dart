import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protectmee/auth/presentation/screens/auth_screen.dart';
import 'package:protectmee/utils/app_styles.dart';

class HelpCenterProfile extends ConsumerStatefulWidget {
  const HelpCenterProfile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<HelpCenterProfile> {
  bool _isViewDetailsExpanded = false;
  bool _isManageContactsExpanded = false;
  final TextEditingController numberController = TextEditingController();
  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullName = prefs.getString('fullName') ?? '';
      email = prefs.getString('email') ?? '';
      phoneNumber = prefs.getString('phoneNumber') ?? '';
      address = prefs.getString('address') ?? '';
      role = prefs.getString('role') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildExpandableCard(
            title: 'View Details',
            description: 'See your profile information',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $fullName'),
                Text('Email: $email'),
                Text('Phone Number: $phoneNumber'),
                Text('Address: $address'),
                Text('Role: $role'),
              ],
            ),
            onTap: () {
              setState(() {
                _isViewDetailsExpanded = !_isViewDetailsExpanded;
              });
            },
            isExpanded: _isViewDetailsExpanded,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          _buildCard(
            title: 'Logout',
            description: 'Log out of your account',
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
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
              Navigator.of(context).pop(); // Close the dialog
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false,
              );
            },
            child: Text('Yes', style: TextStyle(color: blueColor)),
          ),
        ],
      ),
    );
  }
}