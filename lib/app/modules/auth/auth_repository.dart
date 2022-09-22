import 'package:fluttertest/app/data/models/user.dart';

/// Auth repository
abstract class AuthRepository {
  Stream<User?> authStateChanges();
  Future<User> signInAnonymously();
  Future<void> signOut();
}