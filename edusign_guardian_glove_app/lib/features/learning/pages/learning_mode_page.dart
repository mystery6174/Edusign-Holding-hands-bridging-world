import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'dart:math';

class LearningModule {
  final String signName;
  final String targetSign;
  final int targetAccuracy;

  const LearningModule(this.signName, this.targetSign, this.targetAccuracy);
}

class LearningModePage extends StatefulWidget {
  const LearningModePage({super.key});

  @override
  State<LearningModePage> createState() => _LearningModePageState();
}

class _LearningModePageState extends State<LearningModePage> {
  final TextEditingController _searchController = TextEditingController();

  final List<LearningModule> _learningModules = const [
    LearningModule('Hello', 'ASL_HELLO_ANIM', 95),
    LearningModule('Thank You', 'ISL_THANKS_ANIM', 90),
    LearningModule('Help', 'BISL_HELP_ANIM', 85),
    LearningModule('My Name', 'ASL_NAME_SEQ', 92),
  ];

  LearningModule? _currentModule;
  double _currentAccuracy = 0.0;
  String _feedbackMessage = 'Select a sign to begin.';
  bool _isPracticing = false;

  @override
  void initState() {
    super.initState();
    _currentModule = _learningModules.first;
  }

  void _searchSign(String query) {
    if (query.isEmpty) return;

    final match = _learningModules.firstWhere(
          (m) => m.signName.toLowerCase().contains(query.toLowerCase()),
      orElse: () => _learningModules.first,
    );

    setState(() {
      _currentModule = match;
      _feedbackMessage = 'Practice "${match.signName}" now!';
      _currentAccuracy = 0.0;
      _isPracticing = false;
    });
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
    double simulatedScore =
    min(1.0, target * (0.8 + random.nextDouble() * 0.4));

    final bool isCorrect = simulatedScore >= target;

    setState(() {
      _currentAccuracy = simulatedScore;
      _isPracticing = false;

      if (isCorrect) {
        _feedbackMessage =
        'Perfect! Confidence: ${(simulatedScore * 100).toInt()}%';
        debugPrint('HAPTIC: SUCCESS');
      } else {
        _feedbackMessage = 'Try Again! Adjust hand position.';
        debugPrint('HAPTIC: GUIDE');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Learn & Practice'),
        backgroundColor: AppColors.cardCanvas,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 30),
            _currentModule != null
                ? _buildLearningModuleCard(context, _currentModule!)
                : Center(
              child: Text(
                _feedbackMessage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
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
        hintText: 'Type a word or sentence to learn...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send_outlined,
              color: AppColors.primaryTeal),
          onPressed: () => _searchSign(_searchController.text),
        ),
        filled: true,
        fillColor: AppColors.cardCanvas,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildLearningModuleCard(
      BuildContext context, LearningModule module) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardCanvas,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            module.signName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(
              color: AppColors.primaryTeal,
              fontSize: 32,
            ),
          ),
          Text('Target Accuracy: ${module.targetAccuracy}%'),
          const SizedBox(height: 30),

          Container(
            height: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(module.targetSign),
          ),

          const SizedBox(height: 30),
          _buildAccuracyMeter(context),
          const SizedBox(height: 16),

          Text(
            _feedbackMessage,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: _currentAccuracy >= (module.targetAccuracy / 100)
                  ? AppColors.primaryTeal
                  : AppColors.secondaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed:
              _isPracticing ? null : _simulatePracticeAttempt,
              icon: _isPracticing
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Icon(Icons.front_hand_outlined),
              label:
              Text(_isPracticing ? 'Translating...' : 'Try Sign Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
              ),
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

    return Column( // Changed to Column to separate the meter and the label
      children: [
        SizedBox(
          height: 160, // Increased size slightly to prevent cramming
          width: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle (Full track)
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 12,
                color: AppColors.lightBackground,
              ),
              // The Actual Progress
              CircularProgressIndicator(
                value: _currentAccuracy,
                strokeWidth: 12,
                strokeCap: StrokeCap.round, // Makes the ends of the bar round and "Chic"
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              ),
              // The Percentage Text inside the circle
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(_currentAccuracy * 100).toInt()}%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 36, // Slightly smaller to prevent edge overlapping
                      fontWeight: FontWeight.bold,
                      color: indicatorColor,
                    ),
                  ),
                  Text(
                    'Score',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }}

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