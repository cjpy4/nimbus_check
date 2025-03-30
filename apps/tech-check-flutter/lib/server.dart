import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

void main() async {
  final app = Router();

  app.get('/api/check-device', (Request request) async {
    final params = request.url.queryParameters;
    final url = Uri.https(
      'www.sickw.com',
      '/api.php',
      {
        'format': params['format'],
        'key': params['key'],
        'service': params['service'],
        'imei': params['imei'],
      },
    );

    try {
      final response = await http.get(url);
      return Response(
        response.statusCode,
        body: response.body,
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.internalServerError(
        body: '{"error": "${e.toString()}"}',
      );
    }
  });

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app);

  final server = await shelf_io.serve(
    handler,
    'localhost',
    3000,
  );

  print('Server running on localhost:${server.port}');
}