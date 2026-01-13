import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';

class LanguageSettingsPage extends StatefulWidget {
  final UserProfile user;
  const LanguageSettingsPage({super.key, required this.user});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  // --- DEMO DATA ---
  final List<String> _signLanguageOptions = ['ASL (American)', 'ISL (Indian)', 'BISL (British)', 'LSF (French)'];
  final List<String> _speechLanguageOptions = ['English (US)', 'English (UK)', 'Hindi (India)', 'Marathi (India)', 'Spanish (Global)'];

  late String _currentSignLanguage;
  late String _currentSpeechLanguage;

  @override
  void initState() {
    super.initState();

    // --- FIX STARTS HERE ---

    // 1. Check if the user's sign language exists in our list.
    // If it's just "ISL", we map it to "ISL (Indian)" to prevent the crash.
    String userSignLang = widget.user.signLanguage;
    if (!_signLanguageOptions.contains(userSignLang)) {
      // Logic: If user has "ISL", match it to "ISL (Indian)"
      if (userSignLang == "ISL") {
        _currentSignLanguage = 'ISL (Indian)';
      } else {
        _currentSignLanguage = _signLanguageOptions[0]; // Default to ASL if no match
      }
    } else {
      _currentSignLanguage = userSignLang;
    }

    // 2. Do the same for Speech Language
    String userSpeechLang = widget.user.speechLanguage;
    if (!_speechLanguageOptions.contains(userSpeechLang)) {
      _currentSpeechLanguage = _speechLanguageOptions[0]; // Default to English (US)
    } else {
      _currentSpeechLanguage = userSpeechLang;
    }
  }

  // ... rest of your code ...
  void _saveLanguageChanges() {
    // In a real app, this would update the user profile in the database
    // and potentially trigger a command to the ESP32 to load a new ML model
    // configuration if the sign language changed.
    print("Language settings saved:");
    print("Sign Language: $_currentSignLanguage");
    print("Speech Language: $_currentSpeechLanguage");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language settings updated successfully!')),
    );
  }

  // Reusable widget for a settings option tile (Dropdown style)
  Widget _buildLanguageDropdown({
    required String title,
    required String subtitle,
    required List<String> options,
    required String currentValue,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.cardCanvas,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorderLight),
        ),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: title,
            labelStyle: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.bold),
            prefixIcon: Icon(icon, color: AppColors.subtleText),
            // Hide default border as we styled the parent container
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          value: currentValue,
          hint: Text(subtitle),
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyMedium,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Language Settings'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. SIGN LANGUAGE INPUT SETTING ---
            Text(
              'Glove Input Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.subtleText),
            ),
            const SizedBox(height: 10),

            _buildLanguageDropdown(
              title: 'Sign Language Input',
              subtitle: 'The sign language your glove is trained for',
              options: _signLanguageOptions,
              currentValue: _currentSignLanguage,
              icon: Icons.front_hand_outlined,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentSignLanguage = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            // --- 2. SPEECH LANGUAGE OUTPUT SETTING ---
            Text(
              'Speech Output Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.subtleText),
            ),
            const SizedBox(height: 10),

            _buildLanguageDropdown(
              title: 'Speech Output Language',
              subtitle: 'The language the app will speak',
              options: _speechLanguageOptions,
              currentValue: _currentSpeechLanguage,
              icon: Icons.volume_up_outlined,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _currentSpeechLanguage = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 40),

            // --- SAVE BUTTON ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveLanguageChanges,
                child: const Text('Save Language Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
