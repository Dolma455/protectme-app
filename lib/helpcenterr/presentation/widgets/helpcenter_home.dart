import 'package:flutter/material.dart';
import 'package:protectmee/utils/app_styles.dart';

class HelpCenterHome extends StatelessWidget {
  const HelpCenterHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to ProtectMe App', style: headingStyle),
            const SizedBox(height: 16),
            _buildSectionTitle('Our Mission'),
            const SizedBox(height: 8),
            _buildSectionContent(
              'To serve and protect the community with integrity, professionalism, and respect.',
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Recent Reports'),
            const SizedBox(height: 8),
            _buildRecentReports(),
            const SizedBox(height: 16),
            _buildSectionTitle('Statistics'),
            const SizedBox(height: 8),
            _buildStatistics(),
            const SizedBox(height: 16),
            _buildSectionTitle('Announcements'),
            const SizedBox(height: 8),
            _buildSectionContent(
              '1. Community meeting on safety awareness on 2024-12-01.\n'
              '2. New traffic regulations effective from 2024-12-15.',
            ),
           
          ],
        ),
      );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: titleTextStyle);
  }

  Widget _buildSectionContent(String content) {
    return Text(content, style: bodyTextStyle);
  }

  Widget _buildRecentReports() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3, // Example count
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('Incident Type: Theft', style: bodyTextStyle),
            subtitle: Text('Date: 2024-11-20', style: bodyTextStyle),
          ),
        );
      },
    );
  }

  Widget _buildStatistics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reports Received: 120', style: bodyTextStyle),
        Text('Resolved Cases: 100', style: bodyTextStyle),
        Text('Incident Types: Theft, Assault, Accident', style: bodyTextStyle),
      ],
    );
  }
}