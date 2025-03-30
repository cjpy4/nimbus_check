import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'models/result.dart';

const String apiBaseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://checkdevice-x64tbucalq-uc.a.run.app',
);

Future<List<Result>> getResults(
  String format,
  String key,
  String service,
  String imei,
) async {
  try {
    print('Starting getResults with parameters:');
    print('format: $format');
    print('service: $service');
    print('imei: $imei');
    print('key: ${key.substring(0, 4)}***'); // Only show first 4 chars of key

    var url = Uri.parse(apiBaseUrl).replace(
      queryParameters: {
        'format': format,
        'key': key,
        'service': service,
        'imei': imei,
      },
    );

    print('Requesting URL: ${url.toString().replaceAll(key, "***")}');

    final stopwatch = Stopwatch()..start();
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    print('Request completed in ${stopwatch.elapsedMilliseconds}ms');

    print('Response status: ${response.statusCode}');
    print('Response headers: ${response.headers}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        print('Successfully parsed JSON response');

        if (!jsonResponse.containsKey('result')) {
          throw Exception('Response missing "result" key: $jsonResponse');
        }

        var result = jsonResponse['result'] as Map<String, dynamic>;
        var entries =
            result.entries.map((entry) => Result.fromJson(entry)).toList();
        print('Successfully converted ${entries.length} results');
        return entries;
      } catch (parseError) {
        print('JSON parsing error: $parseError');
        print('Raw response body: ${response.body}');
        rethrow;
      }
    } else {
      print('HTTP Error ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Error body: ${response.body}');
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e, stackTrace) {
    print('Error in getResults: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}

// void main() {
//   getResults(
//     'json',
//     'V29-1J2-0JX-CDL-DFT-TUZ-SM6-BHJ',
//     '81',
//     '357773245856787',
//   );
// }
