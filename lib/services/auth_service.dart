import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

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

  // Sign up with email and password
  Future<String?> signUpWithEmail({
    required String email,
    required String password,
    required String userType,
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

  // Set or update user type
  Future<String?> updateUserType(String userType) async {
    try {
      if (currentUser == null) return 'No user logged in';

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .update({'userType': userType});

      return null; // Success, no error
    } catch (e) {
      return e.toString();
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get user type
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
