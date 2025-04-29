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

  Future<void> addRecord(Map<String, dynamic> doc) async {
    final user = _auth.currentUser;

    if (user == null) {
      print("User not logged in");
      return; // Or handle appropriately
    }

    doc.addEntries([MapEntry('createdAt', FieldValue.serverTimestamp())]);
    doc.addEntries([MapEntry('userId', user.uid)]);

    try {
      await _firestore
          .collection('searches')
          .add(doc)
          .then(
            (documentSnapshot) =>
                print("Added Data with ID: ${documentSnapshot.id}"),
          );
    } catch (e) {
      print("Error adding record: $e");
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
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  // Get Firestore instance
  final firestore = ref.read(fireStoreProvider);
  final auth = ref.read(firebaseAuthProvider);
  return SearchRepository(firestore, auth);
}

// Create a provider that exposes the stream of results
@riverpod
Stream<List<Map<String, dynamic>>> searchHistory(Ref ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.getSearches().map((querySnapshot) {
    final documents = querySnapshot.docs;

    final searches =
        documents.map((doc) => doc.data()).toList(); // Non-null list of Strings
    return searches;
  });
}
