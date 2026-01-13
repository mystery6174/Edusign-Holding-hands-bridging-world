// FILE 16: Reusable ListTile widget for the Settings Hub and sub-pages.
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? leadingColor;
  final Widget? trailingWidget;

  const SettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.onTap,
    this.leadingColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    // This column ensures the tile and the divider are grouped together.
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          tileColor: AppColors.cardCanvas,

          // --- Leading Icon (Teal Accent) ---
          leading: Icon(
            icon,
            color: leadingColor ?? AppColors.primaryTeal,
            size: 28,
          ),

          // --- Title and Subtitle ---
          title: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.lightText,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.subtleText,
            ),
          )
              : null,

          // --- Trailing Icon/Widget ---
          trailing: trailingWidget ??
              const Icon(Icons.chevron_right, color: AppColors.subtleText),

          onTap: onTap,
        ),

        // --- Divider (Thin Separation) ---
        const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.inputBorderLight),
      ],
    );
  }
}
