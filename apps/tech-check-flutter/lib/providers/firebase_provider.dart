import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_provider.g.dart';

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
Stream<User?> authStateChanges(AuthStateChangesRef ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return firebaseAuth.authStateChanges();
}

// Uncomment when firebase_options.dart is available
// @riverpod
// Future<FirebaseApp> firebaseInstance(FirebaseInstanceRef ref) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   return Firebase.app();
// }
// 
@riverpod
FirebaseFirestore fireStore(FireStoreRef ref) {
  return FirebaseFirestore.instance;
}



