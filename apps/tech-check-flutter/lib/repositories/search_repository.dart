import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/providers/firebase_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '/models/result.dart';

part 'search_repository.g.dart';

class SearchRepository {
  final FirebaseFirestore _firestore;
  SearchRepository(this._firestore);

  Future<void> addRecord(Map<String, dynamic> doc) async {
    await _firestore
        .collection('searches')
        .add(doc)
        .then(
          (documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"),
        );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getResults() {
    return _firestore.collection('searches').snapshots();
  }
  
  Stream<QuerySnapshot<Map<String, dynamic>>> getIMEIs() {
    return _firestore.collection('searches').snapshots();
  }
}

@riverpod
SearchRepository searchRepository(Ref ref) {
  // Get Firestore instance
  final firestore = FirebaseFirestore.instance;
  return SearchRepository(firestore);
}

// Create a provider that exposes the stream of results
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> searchHistory(Ref ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.getResults();
}