import 'package:flutter/material.dart';

import '../../../../utils/app_styles.dart';


class AdminHome extends StatelessWidget {
  const AdminHome({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), 
            child: Text(
              'This is admin home screen',
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
