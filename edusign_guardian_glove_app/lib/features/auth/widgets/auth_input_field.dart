import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';

class AuthInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextInputType keyboardType;

  const AuthInputField({
    super.key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.obscureText = false,
    this.onTap,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // This widget utilizes the InputDecorationTheme set up in app_themes.dart.
    // This ensures: rounded corners, white fill, subtle grey borders, and Teal accent on focus.

    return TextField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      // Ensure text color is lightText for visibility inside the white canvas (AppColors.cardCanvas)
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.lightText,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        // Note: Suffix icon logic for visibility toggle is handled manually
        // within the LoginPage/SignUpPage since it requires dynamic state.
      ),
    );
  }
}
