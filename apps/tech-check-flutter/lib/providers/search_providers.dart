import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:nimbus_check/repositories/search_repository.dart';

part 'search_providers.g.dart';

@riverpod
Stream<List<Map<String, dynamic>>> searchHistory(Ref ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.getSearches().map((querySnapshot) {
    final documents = querySnapshot.docs;

    final searches =
        documents.map((doc) => doc.data()).toList();
    return searches;
  });
}

@riverpod
Stream<Map<String, dynamic>> currentSearch(Ref ref, docId) {
  final repository = ref.watch(searchRepositoryProvider);
  return repository.getCurrentSearch(docId).map((querySnapshot) {
    final documents = querySnapshot.docs;

    final lastSearch =
        documents.map((doc) => doc.data()).toList().first;
    return lastSearch;
  });
}