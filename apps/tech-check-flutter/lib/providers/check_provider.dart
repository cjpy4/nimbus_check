import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/check_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_provider.g.dart';

// Constant API key - in a production app, this should be securely stored
const apiKey = 'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ';

// Converting resultsProvider to use annotation
@riverpod
Future<Map<String, dynamic>> check(Ref ref, String imei) async {
  final repository = ref.watch(checkRepositoryProvider);

  // Add to search history
  // ref.read(checkHistoryProvider.notifier).addSearch(imei);

  final results = repository.getResults(imei: imei, key: apiKey);
  print(results.then((map) {
    map.forEach((key, value) {
      print('$key: $value');
    });
    return map;
  }));

  return results;
}
