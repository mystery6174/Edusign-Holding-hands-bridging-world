import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';
import 'package:edusign_guardian_glove_app/core/providers/theme_provider.dart'; // Add this import

import 'package:edusign_guardian_glove_app/features/settings/pages/personal_data_page.dart';
import 'package:edusign_guardian_glove_app/features/settings/pages/language_settings_page.dart';
import 'package:edusign_guardian_glove_app/features/settings/pages/emergency_log_page.dart';
import 'package:edusign_guardian_glove_app/features/settings/pages/learning_data_page.dart';
import 'package:edusign_guardian_glove_app/features/settings/pages/terms_conditions_page.dart';
import 'package:edusign_guardian_glove_app/features/auth/pages/login_page.dart';

import '../../../core/providers/user_provider.dart';

class SettingsHubPage extends StatelessWidget {
  // We removed onThemeToggle and currentThemeMode because Provider handles them now
  const SettingsHubPage({super.key});

  Widget _buildSettingTile(
      BuildContext context,
      String title,
      IconData icon,
      String routeName, // Change this from Widget to String
      ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primaryTeal),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Use the Route Name we defined in main.dart
            Navigator.pushNamed(context, routeName);
          },
        ),
        const Divider(),
      ],
    );
  }

  void _logout(BuildContext context) async {
    // 1. Show a quick confirmation dialog
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;

    // 2. If confirmed, tell Firebase to sign out
    if (confirm) {
      try {
        await FirebaseAuth.instance.signOut();
        // Notice: We don't need Navigator.push here!
        // The StreamBuilder in main.dart will handle the redirection.
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // 1. Get the Provider
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    // 2. CRITICAL SAFETY CHECK:
    // If the userId is empty, it means fetchUserData hasn't finished.
    if (user.userId.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
      );
    }

    // 3. Only if user is NOT null/empty, show the actual UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // USER INFO SECTION - Now fully dynamic
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName, // Displays updated name
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email, // Displays updated email
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // THEME TOGGLE (Now fully functional!)
            SwitchListTile(
              secondary: Icon(
                themeProvider.themeMode == ThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.light_mode,
                color: AppColors.primaryTeal,
              ),
              title: const Text('Dark Mode'),
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (bool value) {
                // 3. Call the toggle function in your Provider
                themeProvider.toggleTheme(value);
              },
            ),
            const Divider(),

            _buildSettingTile(
              context,
              'Personal Data',
              Icons.person_outline,
              '/personal_data', // Use the String name, not PersonalDataPage()
            ),
            _buildSettingTile(
              context,
              'Language Settings',
              Icons.language_outlined,
              '/language', // String name
            ),
            _buildSettingTile(
              context,
              'Emergency Log',
              Icons.security_outlined,
              '/emergency_log', // String name
            ),
            _buildSettingTile(
              context,
              'Learning Data',
              Icons.trending_up_outlined,
              '/LearningDataPage',
            ),
            _buildSettingTile(
              context,
              'Terms & Conditions',
              Icons.description_outlined,
              '/TermsAndConditionsPage',
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}