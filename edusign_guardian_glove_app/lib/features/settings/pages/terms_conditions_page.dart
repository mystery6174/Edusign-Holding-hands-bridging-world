import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  final String _termsContent = """
    ## 1. Acceptance of Terms
    By accessing and using the EduSign Guardian Glove application ("App"), you agree to be bound by these Terms and Conditions ("Terms"). If you disagree with any part of the terms, you may not access the service.

    ## 2. Service Scope and Limitations
    The App provides real-time gesture-to-speech translation using wearable sensor technology. 
    A. Accuracy Disclaimer: The App relies on Machine Learning (ML) and sensor data. Accuracy is highly dependent on user calibration, gesture clarity, and environmental factors. The App is **not guaranteed** to achieve 100% accuracy and should not be used for critical, high-stakes communication without verbal confirmation.
    B. Safety Feature: The Haptic Safety Feature is intended as an alert mechanism only. It is **not a certified emergency service** and should not replace calling official emergency services (e.g., 911, 100) directly. We are not responsible for delays or failures in alerts.

    ## 3. User Data and Privacy
    We collect and store personalized data including name, email, customized sign mappings, and location data (for emergency logs). This data is used solely to improve gesture accuracy, personalization, and service delivery. Location data is only recorded upon explicit use of the Emergency Trigger feature.

    ## 4. Intellectual Property (IP)
    The glove's firmware, the mobile application code, and the underlying ML model architecture are the intellectual property of the BedRest Bandits team. Unauthorized copying, reverse engineering, or reproduction is strictly prohibited.

    ## 5. Termination
    We may terminate or suspend your access immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.
    """;

  Widget _buildSection(BuildContext context, String content) {
    // Splits the content by the Markdown header (##) for structured display
    final parts = content.split('##');

    return Container(
      color: AppColors.cardCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: parts.map((part) {
          if (part.trim().isEmpty) return const SizedBox.shrink();

          final lines = part.trim().split('\n');
          if (lines.isEmpty) return const SizedBox.shrink();

          // Title (The first line)
          final title = lines.first.trim();
          final contentBody = lines.skip(1).join('\n').trim();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Title (Bold, slightly larger)
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                // Body Content
                Text(
                  contentBody,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.lightText,
                    height: 1.5, // Better readability
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Legal & Usage Policy'),
            _buildSection(context, _termsContent),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Last Updated: November 2025',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subtleText),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      color: AppColors.lightBackground,
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.subtleText),
      ),
    );
  }
}
