import 'package:device_check/models/serviceTypes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'check_repository.g.dart';

class CheckRepository {
  static String get apiBaseUrl {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'prod');

    if (env == 'dev') {
      return 'http://localhost:8787/wkr';
    }
    return 'https://tech-check.us/wkr';
  }
  // TODO: Implement caching
  //
  // // Cache to store results to avoid duplicate API calls
  // final Map<String, ResultResponse> _cache = {};

  // // Check if a result is cached and not expired (30 minutes cache time)
  // ResultResponse? getCachedResult(String imei) {
  //   final cachedResponse = _cache[imei];
  //   if (cachedResponse != null) {
  //     final cacheExpiry = cachedResponse.timestamp.add(
  //       const Duration(minutes: 30),
  //     );
  //     if (DateTime.now().isBefore(cacheExpiry)) {
  //       return cachedResponse;
  //     }
  //   }
  //   return null;
  // }

  Future<Map<String, dynamic>> getResults({
    required String imei,
    String format = 'beta',
    required ServiceType service,
    bool useCache = true,
  }) async {
    // Check cache first if enabled
    // if (useCache) {
    //   final cachedResponse = getCachedResult(imei);
    //   if (cachedResponse != null) {
    //     return cachedResponse.results;
    //   }
    // }
    final route = service.route;
    try {
      var url = Uri.parse(apiBaseUrl + route);

      // Create request body from parameters
      Map<String, String> requestBody = {'imei': imei};

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

        // var entries =
        //     result.entries.map((entry) => Result.fromJson(entry)).toList();

        // Cache the result
        // _cache[imei] = ResultResponse(
        //   results: entries,
        //   timestamp: DateTime.now(),
        //   imei: imei,
        // );
        return jsonResponse;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Clear the cache for a specific IMEI or the entire cache
  //   void clearCache({String? imei}) {
  //     if (imei != null) {
  //       _cache.remove(imei);
  //     } else {
  //       _cache.clear();
  //     }
  //   }
}

@riverpod
CheckRepository checkRepository(Ref ref) {
  return CheckRepository();
}
