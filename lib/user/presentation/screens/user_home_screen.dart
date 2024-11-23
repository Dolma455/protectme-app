import 'package:flutter/material.dart';
import 'package:protectmee/auth/presentation/screens/profile.dart';
import 'package:protectmee/user/presentation/widgets/get_reports_history.dart';
import 'package:protectmee/user/presentation/widgets/helpcenter_map.dart';
import 'package:protectmee/user/presentation/widgets/user_home.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int _selectedIndex = 0;
  String emergencyContactNumber = '100'; // Default contact

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
  }

  // Load the emergency contact from SharedPreferences
  Future<void> _loadEmergencyContact() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyContactNumber = prefs.getString('selectedContact') ?? '100'; // Fallback to 100 if no contact is set
    });
  }

  // Function to make phone call
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
            // SOS Button just above the bottom navigation bar
            Padding(
              padding: const EdgeInsets.only(top: 10), // Add some padding
              child: SizedBox(
                width: 70,
                height: 70,
                child: FloatingActionButton(
                  onPressed: () {
                    _makePhoneCall(emergencyContactNumber); // Call the emergency contact
                  },
                  backgroundColor: const Color(0xFF9E1A1A),
                  shape: const CircleBorder(),
                  child: const Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
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
            icon: Icon(Icons.local_police_outlined),
            label: 'Help Centers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report_outlined),
            label: 'Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const UserHome();
      case 1:
        return  HelpCenterWidget(onLocationSelected: (value) {});
      case 2:
        return const UserReportHistoryWidget();
      case 3:
        return const Profile();
      default:
        return const Center(child: Text('Unknown Index'));
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:protectmee/auth/presentation/screens/profile.dart';
// import 'package:protectmee/user/presentation/widgets/helpcenters.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../utils/app_styles.dart';
// import '../widgets/get_reports_history.dart';
// import '../widgets/user_home.dart';


// class UserHomeScreen extends StatefulWidget {
//   const UserHomeScreen({super.key});

//   @override
//   State<UserHomeScreen> createState() => _UserHomeScreenState();
// }

// class _UserHomeScreenState extends State<UserHomeScreen> {
//   int _selectedIndex = 0;
//   final String emergencyContactNumber = '100'; 
  

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<void> _makePhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     try {
//       if (await canLaunch(launchUri.toString())) {
//         await launch(launchUri.toString());
//       } else {
//         throw 'Could not launch dialer';
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0E0E0E),
//       appBar: AppBar(
//         title: const Text('ProtectMe'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Handle notification icon press
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 constraints: const BoxConstraints(maxWidth: 480),
//                 child: _buildContent(),
//               ),
//             ),
//             // SOS Button just above the bottom navigation bar
//             Padding(
//               padding: const EdgeInsets.only(top: 10), // Add some padding
//               child: SizedBox(
//                 width: 70,
//                 height: 70,
//                 child: FloatingActionButton(
//                   onPressed: () {
//                     _makePhoneCall(emergencyContactNumber);
//                   },
//                   backgroundColor: const Color(0xFF9E1A1A),
//                   shape: const CircleBorder(),
//                   child: const Text(
//                     'SOS',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_police_outlined),
//             label: 'Help Centers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.report_outlined),
//             label: 'Reports',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outlined),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: purpleColor,
//         unselectedItemColor: whiteColor,
//         backgroundColor: darkBlueColor,
//         onTap: _onItemTapped,
//       ),
//     );
//   }

//   Widget _buildContent() {
//     switch (_selectedIndex) {
//       case 0:
//         return const UserHome();
//       case 1:
//         return HelpCentersMap(onLocationSelected: (value) {
          
//         });
//       case 2:
//         return const UserReportHistoryWidget();
//       case 3:
//         return const Profile();
//       default:
//         return const Center(child: Text('Unknown Index'));
//     }
//   }
// }

