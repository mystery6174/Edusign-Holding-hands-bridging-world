import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
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

  // --- BULK UPLOAD FUNCTION (Inside State Class) ---
 /* Future<void> bulkUploadSigns() async {
    setState(() => _isLoading = true);
    final List<Map<String, dynamic>> signs = [
      {
        "signName": "hello_i",
        "videoUrl": "https://youtu.be/uKKvNqA9N20?si=uJrxP5uSZ_N9egi9",
        "targetAccuracy": 70
      },
      {
        "signName": "thank_you_i",
        "videoUrl": "https://youtu.be/EPlhDhll9mw?si=PXF6OYtVxYl4441d",
        "targetAccuracy": 70
      },
      {
        "signName": "sorry_i",
        "videoUrl": "https://youtube.com/shorts/vxcJmJmTb9I?si=EjlNAVuQPeZ2-RKo",
        "targetAccuracy": 70
      },
      {
        "signName": "yes_i",
        "videoUrl": "https://youtube.com/shorts/8aqMnR3QXYU?si=p4Nw6ZCjpqV_Sma8",
        "targetAccuracy": 70
      },
      {
        "signName": "no_i",
        "videoUrl": "https://youtube.com/shorts/8aqMnR3QXYU?si=p4Nw6ZCjpqV_Sma8",
        "targetAccuracy": 70
      },
      {
        "signName": "help_i",
        "videoUrl": "https://youtube.com/shorts/HjzwQw8i2Vg?si=4xDWKXi98FJKjyXu",
        "targetAccuracy": 70
      },
      {
        "signName": "stop_i",
        "videoUrl": "https://youtube.com/shorts/d2B7OzcSTQ4?si=QGwXJv8SbhnjdU1g",
        "targetAccuracy": 70
      },
      {
        "signName": "wait_i",
        "videoUrl": "https://youtu.be/1SCyeB8o_wk?si=48w1iS8NRYAAytAL",
        "targetAccuracy": 70
      },
      {
        "signName": "work_i",
        "videoUrl": "https://youtube.com/shorts/n5UtzRv5WE8?si=DyIXJlkBnhSKxbqu",
        "targetAccuracy": 70
      },
      {
        "signName": "finish_i",
        "videoUrl": "https://youtube.com/shorts/tJ_suMaPCYA?si=ilPAM56MPDzUDJpR",
        "targetAccuracy": 70
      },
      {
        "signName": "understand_i",
        "videoUrl": "https://youtube.com/shorts/RrAsItuHElQ?si=CJc4GdUZXKYqx3ON",
        "targetAccuracy": 70
      },
      {
        "signName": "home_i",
        "videoUrl": "https://youtu.be/jcmkB3kkjL4?si=cLXpJNFbDAx-Q1NV",
        "targetAccuracy": 70
      },
      {
        "signName": "look_i",
        "videoUrl": "https://youtu.be/aDgSTuibKtk?si=NVJbPeUM2wbMKRrP",
        "targetAccuracy": 70
      },
      {
        "signName": "listen_i",
        "videoUrl": "https://youtube.com/shorts/WwZf2J0pZHA?si=AcvHCkSCYqBj_JFr",
        "targetAccuracy": 70
      },
      {
        "signName": "hello_a",
        "videoUrl": "https://youtu.be/uKKvNqA9N20?si=wbh9YTbIeYCrk07P",
        "targetAccuracy": 70
      },
      {
        "signName": "thank_you_a",
        "videoUrl": "https://youtube.com/shorts/Quvnp_ht00Y?si=ww6yOzzi2I7PgWvn",
        "targetAccuracy": 70
      },
      {
        "signName": "sorry_a",
        "videoUrl": "https://youtube.com/shorts/icXgDdXbI6A?si=PexehFrNOnwfhLU7",
        "targetAccuracy": 70
      },
      {
        "signName": "please_a",
        "videoUrl": "https://youtube.com/shorts/cet_luzygj0?si=iNSS098nMyOX4G_h",
        "targetAccuracy": 70
      },
      {
        "signName": "yes_a",
        "videoUrl": "https://youtube.com/shorts/gNe-y4rifHM?si=5a5ra9Gmg5hBfbO-",
        "targetAccuracy": 70
      },
      {
        "signName": "no_a",
        "videoUrl": "https://youtube.com/shorts/Kykb1u0En_Y?si=3r7C-FujFNtc8O6H",
        "targetAccuracy": 70
      },
      {
        "signName": "help_a",
        "videoUrl": "https://youtube.com/shorts/2fF4FVH-2s8?si=h2_KSNYgbG3L4wQR",
        "targetAccuracy": 70
      },
      {
        "signName": "want_a",
        "videoUrl": "https://youtube.com/shorts/Eh0-Whhb_Sc?si=T3PqUIBp95bjsfu0",
        "targetAccuracy": 70
      },
      {
        "signName": "need_a",
        "videoUrl": "https://youtube.com/shorts/66X4jAqjBgQ?si=Fsbq27HzvMwxFkDZ",
        "targetAccuracy": 70
      },
      {
        "signName": "like_a",
        "videoUrl": "https://youtube.com/shorts/8I7Oe2TJRIM?si=qrB6QyPTgdFot6wB",
        "targetAccuracy": 70
      },
      {
        "signName": "love_a",
        "videoUrl": "https://youtube.com/shorts/VYsAmnsfDLI?si=-t2cVVynn7MdMjl9",
        "targetAccuracy": 70
      },
      {
        "signName": "dont_know_a",
        "videoUrl": "https://youtube.com/shorts/3HTEtCVSPao?si=vP_i3MdNxP0SipUM",
        "targetAccuracy": 70
      },
      {
        "signName": "think_a",
        "videoUrl": "https://youtube.com/shorts/m2orGL2VRGk?si=85llKmvQQRoKvYrW",
        "targetAccuracy": 70
      },
      {
        "signName": "see_a",
        "videoUrl": "https://youtube.com/shorts/OyruhCX-iG0?si=lFmPHBHUat5eTZmv",
        "targetAccuracy": 70
      },
      {
        "signName": "ask_a",
        "videoUrl": "https://youtube.com/shorts/uKghrgZ8EUI?si=7CWLbsNsT1H9l1dZ",
        "targetAccuracy": 70
      },
      {
        "signName": "finish_a",
        "videoUrl": "https://youtube.com/shorts/e6yTO3lF_Uo?si=5KAmJEq8CRkRfG2i",
        "targetAccuracy": 70
      }
    ];

    try {
      for (var sign in signs) {
        await FirebaseFirestore.instance.collection('learning_library').add(sign);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Database Initialized!"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      debugPrint("Upload Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }
*/

  // 1. Paste this function to handle the button click and logic
  Future<void> _simulatePracticeAttempt() async {
    if (_currentModule == null) return;

    setState(() {
      _isPracticing = true;
      _feedbackMessage = 'Listening to glove...';
    });

    // Simulate waiting for glove data
    await Future.delayed(const Duration(milliseconds: 1500));

    // Logic to generate a score
    final target = _currentModule!.targetAccuracy / 100;
    final random = Random();
    double simulatedScore = min(1.0, target * (0.8 + random.nextDouble() * 0.4));

    // Update the UI with the score
    setState(() {
      _currentAccuracy = simulatedScore;
      _isPracticing = false;
      _feedbackMessage = simulatedScore >= target ? 'Excellent work!' : 'Keep trying!';
    });

    // 2. TRIGGER SAVE: This sends the data to your 'learning_sessions' collection
    await _recordRealPracticeSession(simulatedScore);
  }

  // 3. Make sure this matches your Firestore path from the screenshots
  Future<void> _recordRealPracticeSession(double score) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('learning_sessions')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'accuracy': score, // 0.0 to 1.0
        'signsPracticed': 1,
      });
      debugPrint("✅ Session saved successfully!");
    } catch (e) {
      debugPrint("❌ Error saving session: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
          title: const Text('Learn & Practice'),
          backgroundColor: AppColors.cardCanvas,
          elevation: 0
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSearchBar(),

            /* --- TEMPORARY UPLOAD BUTTON ---
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : bulkUploadSigns,
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: const Text("INITIALIZE DB", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            */

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
    final indicatorColor = _currentAccuracy >= target ? AppColors.primaryTeal : AppColors.secondaryGold;

    return Column(
      children: [
        SizedBox(
          height: 180, width: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(height: 150, width: 150, child: CircularProgressIndicator(value: 1.0, strokeWidth: 14, color: Colors.grey.withOpacity(0.1))),
              SizedBox(height: 150, width: 150, child: CircularProgressIndicator(value: _currentAccuracy, strokeWidth: 14, strokeCap: StrokeCap.round, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation<Color>(indicatorColor))),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${(_currentAccuracy * 100).toInt()}%', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: indicatorColor)),
                  const Text('ACCURACY', style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: AppColors.subtleText, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SignVideoPlayer extends StatefulWidget {
  final String url;
  const SignVideoPlayer({super.key, required this.url});

  @override
  State<SignVideoPlayer> createState() => _SignVideoPlayerState();
}

class _SignVideoPlayerState extends State<SignVideoPlayer> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: true, mute: false, loop: true),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal));
    }
    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: AppColors.primaryTeal,
    );
  }
}