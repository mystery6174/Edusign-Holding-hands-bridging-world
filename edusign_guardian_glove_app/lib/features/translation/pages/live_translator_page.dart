import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/constants/app_colors.dart';
import 'package:edusign_guardian_glove_app/core/models/translation_model.dart';

class LiveTranslatorPage extends StatefulWidget {
  const LiveTranslatorPage({super.key});

  @override
  State<LiveTranslatorPage> createState() => _LiveTranslatorPageState();
}

class _LiveTranslatorPageState extends State<LiveTranslatorPage> {
  // --- DEMO HISTORY ---
  final List<TranslationModel> _fullHistory = _getDemoHistory();

  static List<TranslationModel> _getDemoHistory() {
    return [
      TranslationModel(
        translatedText: 'Hello',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        signLanguage: 'ASL',
        targetLanguage: 'English',
        confidenceScore: 0.96,
      ),
      TranslationModel(
        translatedText: 'Thank you',
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        signLanguage: 'ISL',
        targetLanguage: 'English',
        confidenceScore: 0.92,
      ),
    ];
  }

  final DateTime _selectedDate = DateTime.now();
  final ValueNotifier<String> _currentPhrase = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _simulateRealTimeStream();
  }

  Future<void> _simulateRealTimeStream() async {
    const phrases = [
      "I need help!",
      "My name is Rishika.",
      "Thank you.",
      "Where is the nearest exit?",
      "I am happy to be here.",
    ];

    for (int i = 0; i < phrases.length; i++) {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) return;

      final phrase = phrases[i];
      _currentPhrase.value = phrase;

      final translation = TranslationModel(
        translatedText: phrase,
        timestamp: DateTime.now(),
        signLanguage: 'ASL',
        targetLanguage: 'English',
        confidenceScore: 0.95,
      );

      setState(() => _fullHistory.insert(0, translation));
      debugPrint('TTS Speaking: $phrase');
    }
  }

  @override
  void dispose() {
    _currentPhrase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isViewingToday =
        _selectedDate.day == DateTime.now().day &&
            _selectedDate.month == DateTime.now().month &&
            _selectedDate.year == DateTime.now().year;

    final filteredHistory = _fullHistory.where((t) {
      return t.timestamp.day == _selectedDate.day &&
          t.timestamp.month == _selectedDate.month &&
          t.timestamp.year == _selectedDate.year;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Live Translator'),
        backgroundColor: AppColors.cardCanvas,
      ),
      body: Column(
        children: [
          if (isViewingToday) _buildRealTimeStream(),
          Expanded(child: _buildHistoryLog(filteredHistory, isViewingToday)),
          _buildInputBar(context),
        ],
      ),
    );
  }

  Widget _buildRealTimeStream() {
    return ValueListenableBuilder<String>(
      valueListenable: _currentPhrase,
      builder: (_, phrase, __) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.cardCanvas,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
              )
            ],
          ),
          child: Text(
            phrase.isEmpty ? 'Waiting for Sign...' : phrase,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryTeal,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryLog(List<TranslationModel> history, bool today) {
    if (history.isEmpty) {
      return Center(
        child: Text(
          today ? 'Start signing to see history!' : 'No history for this date',
        ),
      );
    }

    return ListView.builder(
      reverse: today,
      itemCount: history.length,
      itemBuilder: (_, index) {
        final t = history[index];
        return ListTile(
          title: Text(t.translatedText),
          subtitle:
          Text('Confidence: ${(t.confidenceScore * 100).toInt()}%'),
        );
      },
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.cardCanvas,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search history...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline,
                color: AppColors.primaryTeal),
            onPressed: () => _currentPhrase.value = '',
          ),
        ],
      ),
    );
  }
}
