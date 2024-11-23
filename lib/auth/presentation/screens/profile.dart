import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protectmee/utils/app_styles.dart';
import 'auth_screen.dart';
import '../../controller/profile_controller.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  bool _isViewDetailsExpanded = false;
  bool _isManageContactsExpanded = false;
  final TextEditingController numberController = TextEditingController();
  String fullName = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String role = '';
  List<String> emergencyContacts = [];
  String? selectedContact;
  String emergencyContactMessage = '';

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadEmergencyContacts();
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

    // Fetch user details by email
    if (email.isNotEmpty) {
      await ref.read(profileControllerProvider.notifier).getUserByEmail(email);
    }
  }

  // Load emergency contacts from shared preferences
  Future<void> _loadEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyContacts = prefs.getStringList('emergencyContacts') ?? [];
      selectedContact = prefs.getString('selectedContact');
      emergencyContactMessage = prefs.getString('emergencyContactMessage') ?? '';
    });
  }

  // Save emergency contacts to shared preferences
  Future<void> _saveEmergencyContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('emergencyContacts', emergencyContacts);
  }

  // Save selected emergency contact
  Future<void> _saveSelectedContact(String contact) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedContact', contact);
    setState(() {
      selectedContact = contact;
      emergencyContactMessage = 'Emergency Contact is: $contact';
      prefs.setString('emergencyContactMessage', emergencyContactMessage);
    });
  }

  void _addEmergencyContact() {
    String emergencyNumber = numberController.text;
    if (emergencyNumber.isNotEmpty && !emergencyContacts.contains(emergencyNumber)) {
      setState(() {
        emergencyContacts.add(emergencyNumber);
        _saveEmergencyContacts();
        numberController.clear();
      });
    }
  }

  void _deleteEmergencyContact(String contact) {
    setState(() {
      emergencyContacts.remove(contact);
      _saveEmergencyContacts();
    });
  }

  void _logout(BuildContext context) async {
    bool confirmLogout = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dialog is dismissed.

    if (confirmLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  AuthScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return  profileState.when(
        data: (user) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildExpandableCard(
                title: 'View Details',
                description: 'See your profile information',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${user.fullName}'),
                    Text('Email: ${user.email}'),
                    Text('Phone Number: ${user.phoneNumber}'),
                    Text('Address: ${user.address}'),
                    if (user.role != null) Text('Role: ${user.role}'),
                    if (user.latitude != null && user.longitude != null)
                      Text('Location: ${user.latitude}, ${user.longitude}'),
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
              if (user.role == 'Normal User')
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
                        onPressed: _addEmergencyContact,
                        child: const Text('Save'),
                      ),
                      const SizedBox(height: 16),
                      const Text('Your Emergency Contacts:'),
                      ListView.builder(
                        shrinkWrap: true,
                       // physics: NeverScrollableScrollPhysics(),
                        itemCount: emergencyContacts.length,
                        itemBuilder: (context, index) {
                          String contact = emergencyContacts[index];
                          return ListTile(
                            title: Text(contact),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteEmergencyContact(contact),
                            ),
                            leading: Radio<String>(
                              value: contact,
                              groupValue: selectedContact,
                              onChanged: (value) {
                                if (value != null) {
                                  _saveSelectedContact(value);
                                }
                              },
                            ),
                          );
                        },
                      ),
                      if (emergencyContactMessage.isNotEmpty)
                        Text(
                          emergencyContactMessage,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
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
}
