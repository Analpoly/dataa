import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  AuthProvider() {
    checkLoginStatus();
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signIn(String email, String password, {bool keepLoggedIn = false}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      notifyListeners();

      if (keepLoggedIn) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keepLoggedIn', true);
        await prefs.setString('userEmail', email);
        await prefs.setString('userPassword', password);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('keepLoggedIn');
    await prefs.remove('userEmail');
    await prefs.remove('userPassword');
    _user = null;
    notifyListeners();
  }

  Future<void> checkLoginStatus() async {
    _user = _auth.currentUser;
    notifyListeners();
    if (_user == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('keepLoggedIn') == true) {
        String? email = prefs.getString('userEmail');
        String? password = prefs.getString('userPassword');
        if (email != null && password != null) {
          await signIn(email, password, keepLoggedIn: true);
        }
      }
    }
  }

  void _onAuthStateChanged(User? user) {
    _user = user;
    notifyListeners();
  }
}
