import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class LearningDataPage extends StatelessWidget {
  const LearningDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Get the current logged-in user's ID to find their specific folder
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('My Learning Data'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      // 2. Use StreamBuilder to listen to your new sub-collection
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('learning_sessions')
            .orderBy('timestamp', descending: false) // Chart needs oldest to newest
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
          }

          // 3. If the folder is empty (no sessions yet)
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState(context);
          }

          final docs = snapshot.data!.docs;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, 'Progress Chart Over Time'),
                _buildAccuracyChart(context, docs),
                const SizedBox(height: 10),
                _buildSectionHeader(context, 'Detailed Session History'),
                _buildDetailedProgressList(context, docs.reversed.toList()), // List needs newest first
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- CHART: Now pulls height from Firestore 'accuracy' field ---
  Widget _buildAccuracyChart(BuildContext context, List<QueryDocumentSnapshot> docs) {
    // Take only the last 7 sessions to keep the chart clean
    final recentDocs = docs.length > 7 ? docs.sublist(docs.length - 7) : docs;

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
          const Text('Gesture Accuracy Rate', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: recentDocs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                // --- SAFETY CHECK ---
                double rawAccuracy = (data['accuracy'] ?? 0.0).toDouble();
                // If data is stored as 85 or 100, convert it to 0.85 or 1.0
                double accuracy = rawAccuracy > 1.0 ? rawAccuracy / 100 : rawAccuracy;

                final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
                final String dateLabel = DateFormat('MMM d').format(timestamp.toDate());

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${(accuracy * 100).toInt()}%',
                        style: const TextStyle(color: AppColors.primaryTeal, fontSize: 10)),
                    const SizedBox(height: 5),
                    Container(
                      width: 25,
                      // CLAMP prevents overflow: min height 5, max height 150
                      height: (accuracy * 150).clamp(5, 150).toDouble(),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(dateLabel, style: const TextStyle(fontSize: 10, color: AppColors.subtleText)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // --- LIST: Now pulls data from Firestore documents ---
  Widget _buildDetailedProgressList(BuildContext context, List<QueryDocumentSnapshot> docs) {
    return Container(
      color: AppColors.cardCanvas,
      child: Column(
        children: docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final double accuracy = (data['accuracy'] ?? 0.0).toDouble();
          final Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
          final String dateLabel = DateFormat('MMM d').format(timestamp.toDate());

          return ListTile(
            leading: const Icon(Icons.check_circle_outline, color: AppColors.primaryTeal),
            title: Text('Session on $dateLabel'),
            subtitle: Text('${data['signsPracticed'] ?? 0} unique signs practiced.'),
            trailing: Chip(
              label: Text('${(accuracy * 100).toInt()}% Accuracy'),
              backgroundColor: AppColors.secondaryGold.withOpacity(0.1),
              labelStyle: const TextStyle(color: AppColors.secondaryGold, fontSize: 11),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      color: AppColors.lightBackground,
      padding: const EdgeInsets.only(top: 20, bottom: 8, left: 20),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.subtleText)),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bar_chart, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("No practice sessions yet!", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/learning'),
            child: const Text("Go Practice"),
          )
        ],
      ),
    );
  }
}