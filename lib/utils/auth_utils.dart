import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Authentication utility class to manage Firebase authentication
class AuthUtils {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Singleton pattern
  static final AuthUtils _instance = AuthUtils._internal();
  factory AuthUtils() => _instance;
  AuthUtils._internal();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Future to get user type from Firestore
  Future<String?> get userType async => await getUserType();
  
  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Get current user email
  String? get currentUserEmail => currentUser?.email;

  // Check if user is expert or mentee
  Future<bool> get isExpert async => await _isUserType('expert');
  Future<bool> get isMentee async => await _isUserType('user');
  bool get isTestAccount => currentUserEmail == 'test@example.com';

  Future<bool> _isUserType(String type) async {
    if (!isLoggedIn) return false;
    try {
      final doc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();
      return doc.data()?['userType'] == type;
    } catch (_) {
      return false;
    }
  }

  // Sign up with email and password
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String userType, // 'user' or 'expert'
    String? name,
  }) async {
    try {
      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Store additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': email,
          'userType': userType,
          'name': name ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        return null; // Success, no error
      }
      return 'Failed to create user';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Sign in with email and password
  Future<Map<String, dynamic>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Get user type from Firestore
        final userData = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (userData.exists) {
          return {
            'success': true,
            'userType': userData.data()?['userType'] ?? 'user',
            'error': null,
          };
        }
      }
      return {
        'success': false,
        'userType': null,
        'error': 'Failed to get user data',
      };
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return {
          'success': false,
          'userType': null,
          'error': 'No user found for that email',
        };
      } else if (e.code == 'wrong-password') {
        return {
          'success': false,
          'userType': null,
          'error': 'Wrong password provided',
        };
      }
      return {
        'success': false,
        'userType': null,
        'error': e.message,
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user type from Firestore
  Future<String?> getUserType() async {
    if (currentUser == null) return null;
    
    try {
      final userData = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userData.exists) {
        return userData.data()?['userType'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
