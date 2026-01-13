import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:video_player/video_player.dart';
import 'dart:math';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// --- DATA MODEL ---
class LearningModule {
  final String signName;
  final String videoUrl;
  final int targetAccuracy;

  const LearningModule({
    required this.signName,
    required this.videoUrl,
    required this.targetAccuracy,
  });
}

// --- MAIN PAGE ---
class LearningModePage extends StatefulWidget {
  const LearningModePage({super.key});

  @override
  State<LearningModePage> createState() => _LearningModePageState();
}

class _LearningModePageState extends State<LearningModePage> {
  final TextEditingController _searchController = TextEditingController();

  LearningModule? _currentModule;
  double _currentAccuracy = 0.0;
  String _feedbackMessage = 'Search for a sign to start learning!';
  bool _isLoading = false;
  bool _isPracticing = false;

  @override
  void initState() {
    super.initState();
    _searchSign('Hello');
  }

  Future<void> _searchSign(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _isLoading = true;
      _feedbackMessage = 'Searching library...';
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('learning_library')
          .where('signName', isEqualTo: query.trim())
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _currentModule = LearningModule(
            signName: data['signName'] ?? 'Unknown',
            videoUrl: data['videoUrl'] ?? '',
            targetAccuracy: (data['targetAccuracy'] ?? 90).toInt(),
          );
          _feedbackMessage = 'Watch the video and try the sign!';
          _currentAccuracy = 0.0;
        });
      } else {
        setState(() {
          _currentModule = null;
          _feedbackMessage = 'Sorry, "$query" is not in our library yet.';
        });
      }
    } catch (e) {
      setState(() => _feedbackMessage = 'Database Error. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _simulatePracticeAttempt() async {
    if (_currentModule == null) return;
    setState(() {
      _isPracticing = true;
      _feedbackMessage = 'Listening to glove...';
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    final target = _currentModule!.targetAccuracy / 100;
    final random = Random();
    double simulatedScore = min(1.0, target * (0.8 + random.nextDouble() * 0.4));

    setState(() {
      _currentAccuracy = simulatedScore;
      _isPracticing = false;
      _feedbackMessage = simulatedScore >= target ? 'Excellent work!' : 'Keep trying!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(title: const Text('Learn & Practice'), backgroundColor: AppColors.cardCanvas, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 30),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_currentModule != null)
              _buildLearningModuleCard(context, _currentModule!)
            else
              Padding(padding: const EdgeInsets.only(top: 50), child: Text(_feedbackMessage)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onSubmitted: _searchSign,
      decoration: InputDecoration(
        hintText: 'Search: Hello, Help...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: AppColors.cardCanvas,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildLearningModuleCard(BuildContext context, LearningModule module) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.cardCanvas, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text(module.signName, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryTeal)),
          const SizedBox(height: 20),

          // VIDEO BLOCK
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 220, width: double.infinity, color: Colors.black,
              child: SignVideoPlayer(key: ValueKey(module.videoUrl), url: module.videoUrl),
            ),
          ),

          const SizedBox(height: 30),
          _buildAccuracyMeter(context),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isPracticing ? null : _simulatePracticeAttempt,
              icon: _isPracticing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.front_hand_outlined),
              label: Text(_isPracticing ? 'Processing...' : 'Try Sign Now'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTeal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyMeter(BuildContext context) {
    final target = _currentModule!.targetAccuracy / 100;
    final indicatorColor = _currentAccuracy >= target
        ? AppColors.primaryTeal
        : AppColors.secondaryGold;

    return Column(
      children: [
        SizedBox(
          height: 180, // Slightly taller container
          width: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Gray Background Track
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: 1.0,
                  strokeWidth: 14,
                  color: Colors.grey.withValues(alpha: 0.1),
                ),
              ),
              // 2. The Actual Progress Bar
              SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator(
                  value: _currentAccuracy,
                  strokeWidth: 14,
                  strokeCap: StrokeCap.round, // Clean, rounded edges
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
                ),
              ),
              // 3. The Text Labels (Now perfectly centered)
              Column(
                mainAxisSize: MainAxisSize.min, // Takes up only needed space
                children: [
                  Text(
                    '${(_currentAccuracy * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 32, // Controlled size to prevent overlapping
                      fontWeight: FontWeight.bold,
                      color: indicatorColor,
                    ),
                  ),
                  Text(
                    'ACCURACY',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1.2,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- HELPER VIDEO WIDGET (Defined OUTSIDE the other classes) ---
class SignVideoPlayer extends StatefulWidget {
  final String url;
  const SignVideoPlayer({super.key, required this.url});

  @override
  State<SignVideoPlayer> createState() => _SignVideoPlayerState();
}

class _SignVideoPlayerState extends State<SignVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize inside the correct state room
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _isInitialized = true);
          _controller.setLooping(true);
          _controller.play();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) return const Center(child: CircularProgressIndicator());
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}