import 'package:shelf/shelf.dart' as shelf;
import '../routes/open_routes.dart';
import '../handler/token_validator.dart';
import '../utils/response_helper.dart';

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

shelf.Handler jwtAuthMiddleware(shelf.Handler innerHandler) {
  return (shelf.Request request) async {
    // Extract JWT token from request headers or query parameters
    String? token = request.headers['Authorization'];

    /// checks the open routes
    if (openRoutes.contains(request.url.path)) {
      return innerHandler(request);
    }
    if (token == null || !token.startsWith('Bearer ')) {
      return AppResponse.unauthorized(
        message: 'Missing Authorization header (this is developer log => Change this Message on production)',
      );
    }

    token = token.substring(7); // Remove 'Bearer ' prefix

    // Decode and verify the JWT token
    try {
      var (isValid, map) = await checkToken(token);
      if (isValid) {
        // If verification succeeds, add the decoded token to the request context
        return innerHandler(request.change(context: map));
      }
      return AppResponse.unauthorized(
        message: 'Invalid token',
      );
    } catch (e) {
      return AppResponse.unauthorized(
        message: 'Error verifying token: $e',
      );

      // return shelf.Response(401, body: 'Unauthorized');
    }
  };
}
