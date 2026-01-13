import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';

// Mock data structure to simulate learning sessions over several days
class LearningSession {
  final String date;
  final double accuracy; // Percentage 0.0 to 1.0
  final int signsPracticed;

  const LearningSession(this.date, this.accuracy, this.signsPracticed);
}

class LearningDataPage extends StatelessWidget {
  const LearningDataPage({super.key});

  // --- DEMO DATA: Simulating accuracy improvement over 5 sessions ---
  final List<LearningSession> _learningHistory = const [
    LearningSession('Nov 1', 0.65, 15), // Started low
    LearningSession('Nov 3', 0.72, 20),
    LearningSession('Nov 5', 0.81, 25),
    LearningSession('Nov 7', 0.88, 30),
    LearningSession('Nov 9', 0.94, 35), // Improved accuracy
  ];

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

  // --- CHART VISUALIZATION (Simulated using Container/Padding) ---
  Widget _buildAccuracyChart(BuildContext context) {
    // Finds the highest accuracy achieved for scaling the chart
    final double maxAccuracy = _learningHistory
        .map((session) => session.accuracy)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardCanvas,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gesture Accuracy Rate',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Chart Drawing Area
          Container(
            height: 200,
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.inputBorderLight)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _learningHistory.map((session) {
                // Bar height is proportional to max accuracy (max height is 180)
                final double barHeight = (session.accuracy / maxAccuracy) * 180;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Accuracy Label
                    Text('${(session.accuracy * 100).toInt()}%', style: TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 12
                    )),
                    const SizedBox(height: 5),
                    // Vertical Bar (The visual data point)
                    Container(
                      width: 25,
                      height: barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(session.accuracy),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Date Label
                    Text(session.date, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subtleText)),
                  ],
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
          Text('Note: Data shows continuous improvement since starting.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.subtleText)),
        ],
      ),
    );
  }

  // --- DETAILED PROGRESS LIST ---
  Widget _buildDetailedProgressList(BuildContext context) {
    return Container(
      color: AppColors.cardCanvas,
      child: Column(
        children: [
          ..._learningHistory.reversed.map((session) {
            return ListTile(
              leading: Icon(Icons.check_circle_outline, color: AppColors.primaryTeal),
              title: Text('Session on ${session.date}'),
              subtitle: Text('${session.signsPracticed} unique signs practiced.'),
              trailing: Chip(
                label: Text('${(session.accuracy * 100).toInt()}% Accuracy'),
                backgroundColor: AppColors.secondaryGold.withOpacity(0.1),
                labelStyle: TextStyle(color: AppColors.secondaryGold, fontSize: 11),
              ),
            );
          }).toList(),
          const Divider(height: 1, indent: 20, endIndent: 20, color: AppColors.inputBorderLight),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Learning Data'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. ACCURACY CHART ---
            _buildSectionHeader(context, 'Progress Chart Over Time'),
            _buildAccuracyChart(context),

            const SizedBox(height: 10),

            // --- 2. DETAILED SESSION LOG ---
            _buildSectionHeader(context, 'Detailed Session History'),
            _buildDetailedProgressList(context),

            const SizedBox(height: 20),

            // --- Call to Action ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/learning');
                },
                icon: const Icon(Icons.school_outlined),
                label: const Text('Return to Practice'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
