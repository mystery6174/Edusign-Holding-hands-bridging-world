
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:edusign_guardian_glove_app/core/providers/user_provider.dart';

class PersonalDataPage extends StatefulWidget {
  final UserProfile user;
  const PersonalDataPage({super.key, required this.user});

  @override
  State<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends State<PersonalDataPage> {
  // Controllers initialized with current user data
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  // Local map to manage personalized signs before saving
  late Map<int, String> _customSigns;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _fullNameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _dobController = TextEditingController(text: user.dateOfBirth);
    _customSigns = Map.from(user.personalizedSigns); // Deep copy for local edits
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // --- LOGIC FUNCTIONS ---

  // 1. Add 'async' to the function
  void _saveProfileChanges() async { // Add async here
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // This must match the name in Step 1 exactly
    await userProvider.updateFullProfile(
      name: _fullNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      dob: _dobController.text,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _addEditCustomSign({int? gestureId, String? currentPhrase}) {
    final TextEditingController phraseController = TextEditingController(text: currentPhrase);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(gestureId == null ? 'Add New Custom Sign' : 'Edit Sign: Gesture $gestureId'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                gestureId == null
                    ? 'Select/Perform a reserved gesture now to map it.'
                    : 'Mapping Gesture $gestureId to:',
                style: const TextStyle(fontSize: 14, color: AppColors.subtleText),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phraseController,
                decoration: const InputDecoration(
                  labelText: "Phrase/Name to Speak",
                  hintText: "e.g., 'Mom is calling' or 'Wait'",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryGold)),
            ),
            ElevatedButton(
              onPressed: () {
                if (phraseController.text.isNotEmpty) {
                  setState(() {
                    // Simulating mapping to a fixed ID 5 for simplicity.
                    // In real app, ID would come from the glove upon gesture detection.
                    final finalId = gestureId ?? 5;
                    _customSigns[finalId] = phraseController.text;
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Personal Data'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 1. USER PROFILE SECTION (Editable) ---
            _buildSectionHeader(context, 'User Profile Details'),
            _buildProfileEditFields(context),

            const SizedBox(height: 10),

            // --- 2. PERSONALIZED SIGNS SECTION (Custom Data) ---
            _buildSectionHeader(context, 'Personalized Signs'),
            _buildCustomSignsList(context),

            // --- SAVE BUTTON ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfileChanges,
                  child: const Text('Save Changes'),
                ),
              ),
            ),
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

  Widget _buildProfileEditFields(BuildContext context) {
    return Container(
      color: AppColors.cardCanvas,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Full Name
          TextField(
            controller: _fullNameController,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
          ),
          const SizedBox(height: 16),
          // Email (Read Only - Email update needs complex re-auth)
          TextField(
            controller: _emailController,
            readOnly: false,
            decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
          ),
          const SizedBox(height: 16),
          // Phone Number
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
          ),
          const SizedBox(height: 16),
          // Date of Birth
          TextField(
            controller: _dobController,
            readOnly: false,
            decoration: const InputDecoration(
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today_outlined)
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  // Format: YYYY-MM-DD
                  _dobController.text = pickedDate.toString().split(' ')[0];
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSignsList(BuildContext context) {
    // Sort keys (gesture IDs) for consistent display
    final sortedKeys = _customSigns.keys.toList()..sort();

    return Container(
      color: AppColors.cardCanvas,
      child: Column(
        children: [
          ...sortedKeys.map((id) {
            final phrase = _customSigns[id]!;
            return ListTile(
              leading: const Icon(Icons.front_hand_outlined, color: AppColors.primaryTeal),
              title: Text('Gesture ID $id'),
              subtitle: Text(phrase, style: const TextStyle(color: AppColors.lightText)),
              trailing: const Icon(Icons.edit, color: AppColors.subtleText),
              onTap: () => _addEditCustomSign(gestureId: id, currentPhrase: phrase),
            );
          }).toList(),

          // Add New Custom Sign Button
          ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            leading: const Icon(Icons.add_circle_outline, color: AppColors.secondaryGold),
            title: Text(
              'Map New Custom Sign',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.secondaryGold,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () => _addEditCustomSign(), // Call without ID to create new
          ),
          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.inputBorderLight),
        ],
      ),
    );
  }
}
