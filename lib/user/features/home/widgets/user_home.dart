import 'package:flutter/material.dart';
import '../../../../utils/app_styles.dart';
import '../../reportform_modal.dart';

class UserHome extends StatelessWidget {
  const UserHome({super.key});

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
              'Reach any police station across Nepal for minor crimes, such as bike, car theft, or brutality across the states.',
              style: headingStyle,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 50),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 50), 
            decoration: BoxDecoration(
              color: darkBlueColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Have you witnessed or been a victim of a crime? Please report it!',
                  style: bodyTextStyle.copyWith(fontSize: screenWidth * 0.04), 
                ),
                const SizedBox(height: 43),
                ElevatedButton.icon(
                  onPressed: () =>_openReportFormModal(context),
                  icon: Icon(
                    Icons.report_problem_outlined,
                    color: whiteColor,
                  ),
                  label: Text(
                    'Report a Crime',
                    style: bodyTextStyle.copyWith(fontSize: screenWidth * 0.045), 
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 9), 
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest News',
                  style: titleTextStyle.copyWith(fontSize: screenWidth * 0.045), 
                ),
                const SizedBox(height: 8), 
                Text(
                  'Government launches new national hate crime awareness campaign.',
                  style: bodyTextStyle.copyWith(fontSize: screenWidth * 0.04), 
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
