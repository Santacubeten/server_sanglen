import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'database/middleware/middleware.dart';
import 'database/db_connection.dart';

void main() async {
  // Initialize MySQL database connection
  SqlDataBaseHelper();

  // Initialize Shelf Router
  final app = Router();

  app.get("/", serveHTML);



  //user CRUD



  //user CRUD END



  // Create a Shelf handler function
  var handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(corsMiddleware)
      // .addMiddleware(corsHeaders(headers: _corsHeaders))
      // .addMiddleware(jwtAuthMiddleware) // Authentication
      .addHandler(app.call);

  // Start the server
  try {
    var server = await io.serve(handler, InternetAddress.anyIPv4, 3000);

    // Get local IP addresses
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );

    for (var interface in interfaces) {
      for (var addr in interface.addresses) {
        print('Sanglen Server running on http://${addr.address}:${server.port}');
      }
    }
  } catch (e) {
    print('Server error: $e');
  }
}



shelf.Response serveHTML(shelf.Request request) {
  return shelf.Response.ok(File('index.html').readAsStringSync(),
      headers: {'content-type': 'text/html'});
}
