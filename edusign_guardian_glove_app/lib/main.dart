import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edusign_guardian_glove_app/theme/app_themes.dart';
import 'package:edusign_guardian_glove_app/core/providers/theme_provider.dart';
import 'package:edusign_guardian_glove_app/core/providers/user_provider.dart';

// Auth Pages
import 'package:edusign_guardian_glove_app/features/auth/pages/login_page.dart';
import 'package:edusign_guardian_glove_app/features/auth/pages/signup_page.dart';

// Feature Pages
import 'package:edusign_guardian_glove_app/features/dashboard/pages/dashboard_page.dart';
import 'package:edusign_guardian_glove_app/features/translation/pages/live_translator_page.dart';
import 'package:edusign_guardian_glove_app/features/learning/pages/learning_mode_page.dart';
import 'package:edusign_guardian_glove_app/features/settings/pages/settings_hub_page.dart';

import 'package:firebase_core/firebase_core.dart';

import 'features/settings/pages/emergency_log_page.dart';
import 'features/settings/pages/language_settings_page.dart';
import 'features/settings/pages/personal_data_page.dart'; // Keep this



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EduSignApp());
}

class EduSignApp extends StatelessWidget {
  const EduSignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>( // Added Consumer to make theme live
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'EduSign Guardian',
            debugShowCheckedModeBanner: false, // Removes the DEBUG strip
            theme: AppThemes.lightTheme, // Use your custom themes
            darkTheme: AppThemes.darkTheme,
            themeMode: themeProvider.themeMode,

            // --- 1. THE GATEKEEPER ---
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasData) {
                  // Important: Only fetch if data isn't already there to avoid loops
                  final up = Provider.of<UserProvider>(context, listen: false);
                  if (up.user.userId.isEmpty) {
                    up.fetchUserData();
                  }
                  return const DashboardPage();
                }
                return const LoginPage();
              },
            ),

            // --- 2. THE ROUTE MAP (Add this!) ---
            // --- 2. THE ROUTE MAP (Updated) ---
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/dashboard': (context) => const DashboardPage(),
              '/translator': (context) => const LiveTranslatorPage(),
              '/learning': (context) => const LearningModePage(),
              '/settings': (context) => const SettingsHubPage(),

              // ADD THESE MISSING ROUTES:
              '/personal_data': (context) => PersonalDataPage(
                  user: Provider.of<UserProvider>(context, listen: false).user
              ),
              '/language': (context) => LanguageSettingsPage(
                  user: Provider.of<UserProvider>(context, listen: false).user
              ),
              '/emergency_log': (context) => EmergencyLogPage(
                  user: Provider.of<UserProvider>(context, listen: false).user
              ),
            },
          );
        },
      ),
    );
  }
}