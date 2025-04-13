import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/result.dart';
import '../repositories/result_repository.dart';

part 'result_providers.g.dart';

// Constant API key - in a production app, this should be securely stored
const apiKey = 'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ';

// Provider to track all IMEIs that have been searched
final checkHistoryProvider = StateNotifierProvider<CheckHistoryNotifier, List<String>>((ref) {
  return CheckHistoryNotifier();
});


class CheckHistoryNotifier extends StateNotifier<List<String>> {
  CheckHistoryNotifier() : super([]);

  void addSearch(String imei) {
    // Add to the beginning of the list and ensure no duplicates
    state = [imei, ...state.where((item) => item != imei)];
  }

  void removeSearch(String imei) {
    state = state.where((item) => item != imei).toList();
  }

  void clearHistory() {
    state = [];
  }
}

// Provider for loading results for a specific IMEI
final resultsProvider = FutureProvider.family<Map<String, dynamic>>((ref, imei) async {
  final repository = ref.watch(resultRepositoryProvider);
  
  // Add to search history
  ref.read(checkHistoryProvider.notifier).addSearch(imei);
  
  return repository.getResults(
    imei: imei,
    key: apiKey,
  );
});

// Provider for the loading state of a specific IMEI search
final resultsLoadingProvider = StateProvider.family<bool, String>((ref, imei) {
  final resultsAsync = ref.watch(resultsProvider(imei));
  return resultsAsync.isLoading;
});

// Provider for error state of a specific IMEI search
final resultsErrorProvider = StateProvider.family<String?, String>((ref, imei) {
  final resultsAsync = ref.watch(resultsProvider(imei));
  return resultsAsync.hasError ? resultsAsync.error.toString() : null;
});
