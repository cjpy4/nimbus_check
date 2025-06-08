import '../models/service_types.dart';
import '../repositories/search_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/check_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'check_provider.g.dart';

@riverpod
Future<String> check(Ref ref, String imei, ServiceType service) async {
  if (imei.isEmpty) {
    return '';
  }

  final repository = ref.read(checkRepositoryProvider);
  final searchRepository = ref.read(searchRepositoryProvider);
  final results = await repository.getResults(imei: imei, service: service);

  print("Results: $results");

  final String docId;
  if (results.isNotEmpty) {
    docId = await searchRepository.addRecord(results);
  } else {
    // TODO: Handle missing docId
    docId = '';
  }

  return docId;
}
