import 'package:flutter/material.dart';
import '../../../../utils/app_styles.dart';


class HelpCenterUsers extends StatelessWidget {
  const HelpCenterUsers({super.key});


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), 
            child: Text(
              'List of Users',
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
