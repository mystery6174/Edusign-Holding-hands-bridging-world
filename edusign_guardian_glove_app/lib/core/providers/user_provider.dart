import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  // Initialize with empty fields so .fullName doesn't return null
  UserProfile _user = UserProfile(
    fullName: "Loading...",
    email: "",
    phoneNumber: "",
    dateOfBirth: "",
    userId: "", // Use this as your "is data ready?" flag
    personalizedSigns: {},
  );

  // ... rest of your code
  // Firebase Instances
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile get user => _user;

  Future<void> fetchUserData() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        DocumentSnapshot doc = await _db.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          // --- ADD THIS LINE BELOW ---
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          // ----------------------------

          _user = UserProfile(
            fullName: data['fullName'] ?? 'User',
            email: data['email'] ?? firebaseUser.email,
            phoneNumber: data['phoneNumber'] ?? '',
            dateOfBirth: data['dateOfBirth'] ?? '',
            userId: firebaseUser.uid,
            personalizedSigns: {},
          );
          notifyListeners();
        } else {
          // If doc doesn't exist yet, we still set the ID to stop the spinner
          _user = UserProfile(
            fullName: "New User",
            email: firebaseUser.email ?? "",
            phoneNumber: "",
            dateOfBirth: "",
            userId: firebaseUser.uid,
            personalizedSigns: {},
          );
          notifyListeners();
        }
      } catch (e) {
        debugPrint("Error fetching user: $e");
      }
    }
  }

  // --- LOGIN FUNCTION ---
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // ADD THIS LINE: Fetch the actual profile data before telling the UI we are done
      await fetchUserData();

      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // --- SIGN UP FUNCTION ---
  Future<String?> signUp(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      // Create the user profile in Firestore immediately after signup
      await _db.collection('users').doc(result.user!.uid).set({
        'fullName': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // --- UPDATE PROFILE FUNCTION ---
  Future<void> updateFullProfile({
    required String name,
    required String email,
    required String phone,
    required String dob,
  }) async {
    _user = UserProfile(
      fullName: name,
      email: email,
      phoneNumber: phone,
      dateOfBirth: dob,
      userId: _user.userId,
      personalizedSigns: _user.personalizedSigns,
    );

    try {
      // Use the actual logged in user's ID if available, otherwise fallback to demo
      String uid = _auth.currentUser?.uid ?? 'demo_user_id';

      await _db.collection('users').doc(uid).set({
        'fullName': name,
        'email': email,
        'phoneNumber': phone,
        'dateOfBirth': dob,
      }, SetOptions(merge: true));

      notifyListeners();
      debugPrint("Cloud Sync Success");
    } catch (e) {
      debugPrint("Cloud Sync Error: $e");
    }
  }
}