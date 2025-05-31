import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_provider.g.dart';

@riverpod
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

@riverpod
Stream<User?> authStateChanges(Ref ref) {
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
FirebaseFirestore fireStore(Ref ref) {
  return FirebaseFirestore.instance;
}



