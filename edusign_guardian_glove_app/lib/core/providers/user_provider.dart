import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:edusign_guardian_glove_app/core/models/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  // --- ADD THESE VARIABLES ---
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // ---------------------------

  UserProfile _user = UserProfile(
    fullName: "Loading...",
    email: "",
    phoneNumber: "",
    dateOfBirth: "",
    userId: "",
    personalizedSigns: {},
  );

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile get user => _user;

  Future<void> fetchUserData() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      try {
        DocumentSnapshot doc = await _db.collection('users').doc(firebaseUser.uid).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
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

  // --- LOGIN FUNCTION (Now works with _setLoading) ---
  Future<String?> login(String email, String password) async {
    try {
      _setLoading(true);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);

      // --- THE PIGEON FIX ---
      if (e.toString().contains('PigeonUserDetails') || e.toString().contains('List<Object?>')) {
        if (_auth.currentUser != null) {
          return null;
        }
      }
      return e.toString();
    }
  }

  // --- SIGN UP FUNCTION ---
  Future<String?> signUp(String email, String password, String name) async {
    try {
      _setLoading(true);
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await _db.collection('users').doc(result.user!.uid).set({
        'fullName': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      _setLoading(false);
      return null;
    } catch (e) {
      _setLoading(false);
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
      String uid = _auth.currentUser?.uid ?? 'demo_user_id';

      await _db.collection('users').doc(uid).set({
        'fullName': name,
        'email': email,
        'phoneNumber': phone,
        'dateOfBirth': dob,
      }, SetOptions(merge: true));

      notifyListeners();
    } catch (e) {
      debugPrint("Cloud Sync Error: $e");
    }
  }
}