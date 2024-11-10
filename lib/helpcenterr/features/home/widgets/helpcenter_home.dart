import 'package:flutter/material.dart';
import '../../../../user/features/reportform_modal.dart';
import '../../../../utils/app_styles.dart';


class HelpCenterHome extends StatelessWidget {
  const HelpCenterHome({super.key});

   void _openReportFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return  SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: ReportFormModal(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), 
            child: Text(
              'This is home screen of Help Center',
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
