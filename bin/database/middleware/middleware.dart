import 'package:shelf/shelf.dart' as shelf;

Future<shelf.Response> Function(shelf.Request request) corsMiddleware(
    shelf.Handler innerHandler) {
  // ✅ List of allowed origins
  const allowedOrigins = [
    'http://localhost:3000',
    'http://192.168.29.191:3000',
    'http://192.168.29.184:3000',
    'http://10.10.1.38:3000',    
    'http://127.0.0.1:3000',
  ];

  return (shelf.Request request) async {
    final origin = request.headers['origin'];
    final allowOrigin =
        (origin != null && allowedOrigins.contains(origin)) ? origin : '';

    // Handle preflight
    if (request.method == 'OPTIONS') {
      return shelf.Response.ok('', headers: {
        'Access-Control-Allow-Origin': allowOrigin,
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization, X-Requested-With',
        'Access-Control-Allow-Credentials': 'true',
      });
    }

    // Handle regular requests
    final response = await innerHandler(request);
    return response.change(headers: {
      'Access-Control-Allow-Origin': allowOrigin,
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers':
          'Origin, Content-Type, Accept, Authorization, X-Requested-With',
      'Access-Control-Allow-Credentials': 'true',
    });
  };
}
