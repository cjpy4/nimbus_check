import 'package:device_check/repositories/search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/check_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_provider.g.dart';

// Constant API key - in a production app, this should be securely stored
const apiKey = 'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ';

// Converting resultsProvider to use annotation
@riverpod
Future<Map<String, dynamic>> check(Ref ref, String imei) async {
  
  if (imei == 'IMEI Here' || imei.isEmpty) {
         return {};
       }
       
  final repository = ref.read(checkRepositoryProvider);
  final searchRepository = ref.read(searchRepositoryProvider);

  final results = await repository.getResults(imei: imei, key: apiKey);

  print("Results: $results");

  if (results.isNotEmpty) {
    await searchRepository.addRecord(results);
  }

  return results;
}
