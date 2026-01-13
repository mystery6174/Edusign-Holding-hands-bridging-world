// FILE 3: Defines the data model for the authenticated user's profile and settings.

class UserProfile {
  // --- AUTHENTICATION & CORE IDENTITY (Collected at Sign Up) ---
  final String userId; // Unique identifier (from Firebase/Auth)
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;

  // --- APP SETTINGS & PREFERENCES ---
  // Default language user is signing in (e.g., 'ISL')
  final String signLanguage;
  // Default language for speech output (e.g., 'English')
  final String speechLanguage;

  // --- ADVANCED & CUSTOM DATA (Settings Sub-Pages) ---

  // Example: Map a custom gesture index (int) to a full sentence (String).
  // Accessed via PersonalDataPage.
  final Map<int, String> personalizedSigns;

  // Example: List of contacts for the Haptic Safety Feature.
  // Accessed via PersonalDataPage.
  final List<String> emergencyContacts;

  // Example: Current theme preference for persistent Dark/Light Mode.
  final String themeMode;

  // Constructor
  UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    this.signLanguage = 'ISL', // Default to ISL
    this.speechLanguage = 'English', // Default to English
    this.personalizedSigns = const {},
    this.emergencyContacts = const [],
    this.themeMode = 'light',
  });

  // --- DEMO DATA AND UTILITY ---

  // Factory constructor to create the default profile after Sign Up
  factory UserProfile.fromSignUp(
      String userId,
      String name,
      String email,
      String phone,
      String dob
      ) {
    return UserProfile(
      userId: userId,
      fullName: name,
      email: email,
      phoneNumber: phone,
      dateOfBirth: dob,
    );
  }

  // Demo Profile Instance
  static UserProfile getDemoUser() {
    return UserProfile(
      userId: 'user_12345',
      fullName: 'Rishika Lawankar (Demo)',
      email: 'rishika.demo@vpm.edu',
      phoneNumber: '9876543210',
      dateOfBirth: '01 / 01 / 2000',
      signLanguage: 'ISL (Indian)',
      speechLanguage: 'English (UK)',
      personalizedSigns: {
        1: "I need immediate assistance!",
        5: "Please wait one moment."
      },
      emergencyContacts: ["Mom: 9876543211", "Guardian: 9876543212"],
    );
  }
}
