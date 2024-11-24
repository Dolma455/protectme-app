import 'package:flutter/material.dart';

import '../../../../utils/app_styles.dart';


class AdminUsers extends StatelessWidget {
  const AdminUsers({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), 
            child: Text(
              'Users List',
              style: headingStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          
        ],
      ),
    );
  }
}
