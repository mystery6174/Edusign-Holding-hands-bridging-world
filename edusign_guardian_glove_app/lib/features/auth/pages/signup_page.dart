import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/features/auth/widgets/auth_input_field.dart';
import 'package:edusign_guardian_glove_app/features/auth/pages/login_page.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _fullNameController =
  TextEditingController(text: 'Rishika Lawankar');
  final TextEditingController _emailController =
  TextEditingController(text: 'rishika@edusign.com');
  final TextEditingController _passwordController =
  TextEditingController(text: 'securepass');
  final TextEditingController _confirmPasswordController =
  TextEditingController(text: 'securepass');
  final TextEditingController _dobController =
  TextEditingController(text: '01 / 01 / 2000');
  final TextEditingController _phoneController =
  TextEditingController(text: '9876543210');

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
        '${picked.day.toString().padLeft(2, '0')} / '
            '${picked.month.toString().padLeft(2, '0')} / '
            '${picked.year}';
      });
    }
  }

  void _signUp() {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final newProfile = UserProfile.fromSignUp(
      'user_${DateTime.now().millisecondsSinceEpoch}',
      _fullNameController.text,
      _emailController.text,
      _phoneController.text,
      _dobController.text,
    );

    debugPrint('Signed up: ${newProfile.fullName}');
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.cardCanvas,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('EduSign',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: AppColors.primaryTeal)),
                const SizedBox(height: 24),

                AuthInputField(
                  controller: _fullNameController,
                  labelText: 'Full Name',
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                AuthInputField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                // ✅ FIXED PASSWORD FIELD
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                AuthInputField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                AuthInputField(
                  controller: _dobController,
                  labelText: 'Date of Birth',
                  prefixIcon: Icons.calendar_today,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),

                AuthInputField(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  prefixIcon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
                ),
                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  child: const Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
