import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/translation_model.dart';
import 'package:edusign_guardian_glove_app/core/providers/user_provider.dart';
import 'package:edusign_guardian_glove_app/core/providers/theme_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // --- HARDWARE STATUS (Simulated for Demo) ---
  final bool isGloveConnected = true;
  final int batteryLevel = 85;
  final String signalStrength = "Strong";

  // ✅ LOCAL demo translations
  final List<TranslationModel> recentTranslations = [
    TranslationModel(
      translatedText: 'Hello',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      signLanguage: 'ASL',
      targetLanguage: 'English',
      confidenceScore: 0.96,
    ),
    TranslationModel(
      translatedText: 'Thank you',
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
      signLanguage: 'ISL',
      targetLanguage: 'English',
      confidenceScore: 0.92,
    ),
    TranslationModel(
      translatedText: 'I need help',
      timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      signLanguage: 'ASL',
      targetLanguage: 'English',
      confidenceScore: 0.89,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the Providers (The "Secret Sauce" for dynamic UI)
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        actions: [
          // 2. WORKING Theme Toggle Button
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined),
            onPressed: () {
              themeProvider.toggleTheme(themeProvider.themeMode == ThemeMode.light);
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back', style: Theme.of(context).textTheme.titleMedium),
            Text(
              // 3. GET Name from Provider (No longer hardcoded!)
              userProvider.user!.fullName.split(' ').first,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildGloveStatusCard(context),
            const SizedBox(height: 40),
            _buildNavigationGrid(context),
            const SizedBox(height: 40),
            Text('Recent Translations',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildRecentActivityList(context),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildGloveStatusCard(BuildContext context) {
    IconData batteryIcon;
    Color batteryColor;

    if (batteryLevel > 70) {
      batteryIcon = Icons.battery_full;
      batteryColor = AppColors.primaryTeal;
    } else if (batteryLevel > 30) {
      batteryIcon = Icons.battery_4_bar;
      batteryColor = AppColors.secondaryGold;
    } else {
      batteryIcon = Icons.battery_alert;
      batteryColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatusItem(Icons.circle,
              isGloveConnected ? 'Online' : 'Offline', AppColors.primaryTeal),
          _buildStatusItem(batteryIcon, '$batteryLevel%', batteryColor),
          _buildStatusItem(Icons.wifi, signalStrength, AppColors.primaryTeal),
        ],
      ),
    );
  }

  Widget _buildStatusItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return Row(
      children: [
        _buildNavButton(
          context,
          'Live Translate',
          Icons.translate_rounded,
          '/translator',
          AppColors.primaryTeal,
        ),
        const SizedBox(width: 20),
        _buildNavButton(
          context,
          'Learn & Practice',
          Icons.menu_book_rounded,
          '/learning',
          AppColors.secondaryGold,
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, String title, IconData icon, String route, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 38, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivityList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recentTranslations.length,
        itemBuilder: (_, index) {
          final t = recentTranslations[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryTeal,
              child: Icon(Icons.history, color: Colors.white, size: 20),
            ),
            title: Text(t.translatedText, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text('${t.targetLanguage} • ${t.timestamp.hour}:${t.timestamp.minute.toString().padLeft(2, '0')}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${(t.confidenceScore * 100).toInt()}%',
                style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}