import 'package:flutter/material.dart';
import 'package:protectmee/helpcenterr/features/home/widgets/helpcenter_home.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_styles.dart';
import '../features/profile/widgets/helpcenter_profile.dart';
import '../features/reports/helpcenter_reports.dart';
import '../features/users/helpcenter_users.dart';

class HelpCenterHomeScreen extends StatefulWidget {
  const HelpCenterHomeScreen({super.key});

  @override
  State<HelpCenterHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HelpCenterHomeScreen> {
  int _selectedIndex = 0;
 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        throw 'Could not launch dialer';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text('ProtectMe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notification icon press
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                constraints: const BoxConstraints(maxWidth: 480),
                child: _buildContent(),
              ),
            ),
           
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: purpleColor,
        unselectedItemColor: whiteColor,
        backgroundColor: darkBlueColor,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const HelpCenterHome();
      case 1:
        return  HelpCenterReports();
      case 2:
        return HelpCenterUsers();
      case 3:
        return const HelpCenterProfile();
      default:
        return const Center(child: Text('Unknown Index'));
    }
  }
}