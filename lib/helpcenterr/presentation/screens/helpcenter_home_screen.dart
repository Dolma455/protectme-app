import 'package:flutter/material.dart';
import 'package:protectmee/auth/presentation/screens/profile.dart';
import 'package:protectmee/helpcenterr/presentation/widgets/helpcenter_home.dart';
import '../../../utils/app_styles.dart';
import '../widgets/helpcenter_profile.dart';
import '../widgets/helpcenter_reports.dart';
import '../widgets/helpcenter_map.dart';

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
        //return const HelpCenterHome();
      case 1:
        return  const HelpCenterreports();
      case 2:
        return  HelpCenterMap(onLocationSelected: (String value) {  },);
      case 3:
        return const ProfileWidget();
      default:
        return const Center(child: Text('Unknown Index'));
    }
  }
}