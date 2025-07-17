import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'database/db_connection.dart';
import 'routes/clan_routes.dart';
import 'routes/surname_routes.dart';
import 'routes/yek_details_routes.dart';
import 'routes/yelhen_routes.dart';


import 'database/middleware/middleware.dart';

Future<void> main() async {
  // Initialize MySQL database connection
  final db = DBConnection.instance;
  await db.connectdb();

  // Initialize Shelf Router
  final app = Router();

  // Simple root GET route (optional HTML responder)
  app.get("/", serveHTML);
  

  app.get("/swagger.yaml", (shelf.Request request) {
    return shelf.Response.ok(File('bin/config/swagger.yaml').readAsStringSync(),
        headers: {'content-type': 'text/yaml'});
  });

  // Mount the /todos routes
  // app.mount('/todos', TodoRoutes(db).router.call);
  app.mount('/clans', ClanRoutes(db).router.call);
  app.mount('/surnames', SurnameRoutes(db).router.call);
  app.mount('/yek_details', YekDetailsRoutes(db).route.call);
  app.mount('/yelhen', YelhenRoutes(db).route.call);



  // Build middleware + handler pipeline
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(corsMiddleware) // your custom CORS middleware
      .addHandler(app.call);

  // Start server
  try {
    final server = await io.serve(handler, InternetAddress.anyIPv4, 3000);

    // Display all IPv4 network interfaces
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );

    for (final interface in interfaces) {
      for (final addr in interface.addresses) {
        print(
            '✅ Sanglen Server running on http://${addr.address}:${server.port}');
      }
    }
  } catch (e, stack) {
    print('❌ Server failed to start: $e');
    print(stack);
  }
}

shelf.Response serveHTML(shelf.Request request) {
  return shelf.Response.ok(File('index.html').readAsStringSync(),
      headers: {'content-type': 'text/html'});
}
