// FILE 2: Defines the data model for a single translation event.

class TranslationModel {
  // 1. The resulting text of the sign or sentence.
  final String translatedText;

  // 2. Timestamp of when the sign was completed (for history log).
  final DateTime timestamp;

  // 3. Source sign language (e.g., 'ASL', 'ISL').
  final String signLanguage;

  // 4. Target spoken language (e.g., 'English', 'Hindi').
  final String targetLanguage;

  // 5. ML Confidence Score (used to measure Gesture Accuracy).
  final double confidenceScore;

  // Constructor
  TranslationModel({
    required this.translatedText,
    required this.timestamp,
    required this.signLanguage,
    required this.targetLanguage,
    required this.confidenceScore,
  });
}