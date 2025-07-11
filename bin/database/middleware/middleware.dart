// CORS middleware function

import 'package:shelf/shelf.dart' as shelf;



// import 'package:shelf_cors_headers/shelf_cors_headers.dart' as cors;

Future<shelf.Response> Function(shelf.Request request) corsMiddleware(
    shelf.Handler innerHandler) {
  return (shelf.Request request) async {
    // Handle preflight (OPTIONS) requests
    if (request.method == 'OPTIONS') {
      return shelf.Response.ok('', headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization, X-Requested-With',
      });
    }

    // Handle regular requests
    final response = await innerHandler(request);
    return response.change(
      headers: {
        'Access-Control-Allow-Origin': '*', // Allow requests from any origin
        'Access-Control-Allow-Methods':
            'GET, POST, PUT, DELETE, OPTIONS', // Allowed methods
        'Access-Control-Allow-Headers':
            'Origin, Content-Type, Accept, Authorization, X-Requested-With', // Allowed headers
      },
    );
  };
}

