import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';

// Data Model for a single logged emergency event
class EmergencyEvent {
  final DateTime timestamp;
  final String location;
  final String status; // e.g., 'Sent to Contacts', 'Test Mode'

  EmergencyEvent(this.timestamp, this.location, this.status);
}

class EmergencyLogPage extends StatelessWidget {
  final UserProfile user;
  EmergencyLogPage({super.key, required this.user});

  // --- DEMO DATA ---
  final List<String> _reservedSigns = [
    '1. High-Frequency Shake (Call 911/100)',
    '2. Double Fist-Clench (Silent Alert)',
  ];

  final List<EmergencyEvent> _logHistory = [
    EmergencyEvent(DateTime.now().subtract(const Duration(hours: 2)), 'Kalyan, Maharashtra', 'Sent to Contacts'),
    EmergencyEvent(DateTime.now().subtract(const Duration(days: 3)), 'VPM’s Polytechnic, Thane', 'Test Mode Activated'),
    EmergencyEvent(DateTime.now().subtract(const Duration(days: 15)), 'Mumbai Airport Terminal 2', 'Sent to Contacts'),
  ];

  // --- UI Builder Widgets ---

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

  Widget _buildReservedSignsList(BuildContext context) {
    return Container(
      color: AppColors.cardCanvas,
      child: Column(
        children: [
          ..._reservedSigns.map((sign) {
            return ListTile(
              leading: const Icon(Icons.warning_amber_outlined, color: Colors.red),
              title: Text(
                sign,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Reserved for emergency. Cannot be personalized.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subtleText),
              ),
            );
          }).toList(),
          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.inputBorderLight),
        ],
      ),
    );
  }

  Widget _buildEmergencyLog(BuildContext context) {
    return Container(
      color: AppColors.cardCanvas,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _logHistory.length,
        itemBuilder: (context, index) {
          final event = _logHistory[index];
          final eventDate = '${event.timestamp.day}/${event.timestamp.month}/${event.timestamp.year}';
          final eventTime = '${event.timestamp.hour}:${event.timestamp.minute.toString().padLeft(2, '0')}';

          return ListTile(
            leading: Icon(
              Icons.location_on_outlined,
              color: event.status == 'Sent to Contacts' ? AppColors.primaryTeal : AppColors.subtleText,
            ),
            title: Text(
              event.location,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              '$eventDate at $eventTime',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subtleText),
            ),
            trailing: Chip(
              label: Text(event.status),
              backgroundColor: event.status == 'Sent to Contacts'
                  ? AppColors.primaryTeal.withOpacity(0.1)
                  : AppColors.secondaryGold.withOpacity(0.1),
              labelStyle: TextStyle(
                color: event.status == 'Sent to Contacts' ? AppColors.primaryTeal : AppColors.secondaryGold,
                fontSize: 11,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Haptic & Emergency Log'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. DEFAULT RESERVED SIGNS ---
            _buildSectionHeader(context, 'Reserved Emergency Signs'),
            _buildReservedSignsList(context),

            const SizedBox(height: 10),

            // --- 2. EMERGENCY TRIGGER HISTORY ---
            _buildSectionHeader(context, 'Trigger History (Date/Location)'),
            _buildEmergencyLog(context),

            const SizedBox(height: 20),

            // --- Haptic Settings CTA (Placeholder) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  print('Navigate to Haptic Settings sub-page.');
                },
                icon: const Icon(Icons.vibration_outlined),
                label: const Text('Manage Haptic Intensity'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGold, // Correct
                  foregroundColor: AppColors.lightText,      // Correct
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
