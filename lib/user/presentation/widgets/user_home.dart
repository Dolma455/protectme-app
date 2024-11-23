import 'package:flutter/material.dart';
import 'package:protectmee/user/presentation/widgets/report_form_screen.dart';
import '../../../utils/app_styles.dart';


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
              color: darkBlueColor.withOpacity(0.6),
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
                 Text('Safety Tips', style: titleTextStyle),
            const SizedBox(height: 8),
            Text(
              '1. Always be aware of your surroundings.\n'
              '2. Report any suspicious activity immediately.\n'
              '3. Keep your valuables secure and out of sight.',
              style: bodyTextStyle,
            ),
            spacing1,
                Text(
                  'Terms and Conditions',
                  style: titleTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  '1. You are responsible for maintaining the confidentiality of your account information.\n'
                  '2. You agree not to use the service for any unlawful or prohibited activities.\n'
                  '3. The service is provided "as is" without any warranties or guarantees.\n'
                  '4. We reserve the right to terminate your access to the service at any time without notice.\n'
                  '5. By using this service, you agree to comply with all applicable laws and regulations.\n'
                  '6. We are not responsible for any content posted by users on the platform.\n'
                  '7. You agree to indemnify and hold us harmless from any claims arising from your use of the service.\n'
                  '8. We may update these terms and conditions from time to time without notice.\n'
                  '9. Your continued use of the service constitutes your acceptance of the updated terms and conditions.',
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
