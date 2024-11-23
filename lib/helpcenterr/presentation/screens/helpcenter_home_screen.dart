import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protectmee/auth/presentation/screens/profile.dart';
import 'package:protectmee/helpcenterr/presentation/widgets/helpcenter_home.dart';
import 'package:protectmee/user/presentation/widgets/helpcenter_map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:protectmee/utils/app_styles.dart';
import 'package:protectmee/helpcenterr/presentation/widgets/helpcenter_reports.dart';


class HelpCenterHomeScreen extends ConsumerStatefulWidget {
  const HelpCenterHomeScreen({super.key});

  @override
  _HelpCenterHomeScreenState createState() => _HelpCenterHomeScreenState();
}

class _HelpCenterHomeScreenState extends ConsumerState<HelpCenterHomeScreen> {
  int _selectedIndex = 0;
  String helpCenterName = '';

  @override
  void initState() {
    super.initState();
    _loadHelpCenterName();
  }

  Future<void> _loadHelpCenterName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      helpCenterName = prefs.getString('helpCenterName') ?? 'LMN HelpCenter';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center Home'),
      ),
      body: _buildContent(),
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
            icon: Icon(Icons.local_police_outlined),
            label: 'HelpCenters',
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
        return HelpCenterReports(helpCenterName: helpCenterName);
      case 2:
        return  HelpCenterWidget(onLocationSelected: (value) {});
      case 3:
        return const Profile();
      default:
        return const Center(child: Text('Unknown Index'));
    }
  }
}