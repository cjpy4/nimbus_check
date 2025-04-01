import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../models/result.dart';

class ResultRepository {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://tech-check.us/wkr/stdcheck',
  );

  // Cache to store results to avoid duplicate API calls
  final Map<String, ResultResponse> _cache = {};

  // Check if a result is cached and not expired (30 minutes cache time)
  ResultResponse? getCachedResult(String imei) {
    final cachedResponse = _cache[imei];
    if (cachedResponse != null) {
      final cacheExpiry = cachedResponse.timestamp.add(const Duration(minutes: 30));
      if (DateTime.now().isBefore(cacheExpiry)) {
        return cachedResponse;
      }
    }
    return null;
  }

  Future<List<Result>> getResults({
    required String imei,
    String format = 'beta',
    required String key,
    String service = 'demo',
    bool useCache = true,
  }) async {
    // Check cache first if enabled
    if (useCache) {
      final cachedResponse = getCachedResult(imei);
      if (cachedResponse != null) {
        return cachedResponse.results;
      }
    }

    try {
      var url = Uri.parse(apiBaseUrl);

      // Create request body from parameters
      Map<String, String> requestBody = {
        'format': format,
        'key': key,
        'service': service,
        'imei': imei,
      };

      var response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: convert.jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;

        if (!jsonResponse.containsKey('result')) {
          throw Exception('Response missing "result" key: $jsonResponse');
        }

        var result = jsonResponse['result'] as Map<String, dynamic>;
        var entries =
            result.entries.map((entry) => Result.fromJson(entry)).toList();
        
        // Cache the result
        _cache[imei] = ResultResponse(
          results: entries,
          timestamp: DateTime.now(),
          imei: imei,
        );
        
        return entries;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Clear the cache for a specific IMEI or the entire cache
  void clearCache({String? imei}) {
    if (imei != null) {
      _cache.remove(imei);
    } else {
      _cache.clear();
    }
  }
}

// Provide a singleton instance of the repository
final resultRepositoryProvider = Provider<ResultRepository>((ref) {
  return ResultRepository();
});
