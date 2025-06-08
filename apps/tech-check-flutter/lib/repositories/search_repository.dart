import 'package:cloud_firestore/cloud_firestore.dart';
import '/providers/firebase_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_repository.g.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  SearchRepository(this._firestore, this._auth);

  Future<String> addRecord(Map<String, dynamic> doc) async {
    final user = _auth.currentUser;

    if (user == null) {
      print("User not logged in");
      return 'User not logged in'; // Or handle appropriately
    }

    doc.addEntries([MapEntry('createdAt', FieldValue.serverTimestamp())]);
    doc.addEntries([MapEntry('userId', user.uid)]);

    try {
      final documentSnapshot = await _firestore.collection('searches').add(doc);
      print("Added Data with ID: ${documentSnapshot.id}");
      return documentSnapshot.id;
    } catch (e) {
      print("Error adding record: $e");
      return e.toString();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSearches() {
    final user = _auth.currentUser;
    if (user == null) {
      // Return an empty stream or handle as appropriate
      return Stream.empty();
    }
    return _firestore
        .collection('searches')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentSearch(docId) {
    final user = _auth.currentUser;
    if (user == null) {
      // Return an empty stream or handle as appropriate
      return Stream.empty();
    }
    return _firestore
        .collection('searches')
        .where('userId', isEqualTo: user.uid)
        .where('id', isEqualTo: docId)
        .snapshots();
  }
}

// Provider for the SearchRepository
@riverpod
SearchRepository searchRepository(Ref ref) {
  // Get Firestore instance
  final firestore = ref.read(fireStoreProvider);
  final auth = ref.read(firebaseAuthProvider);
  return SearchRepository(firestore, auth);
}

