import 'dart:io';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'database/db_connection.dart';
import 'routes/routes.dart';
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
    return shelf.Response.ok(File('public/swagger.yaml').readAsStringSync(),
        headers: {'content-type': 'text/yaml'});
  });

  app.get("/custom.css", (shelf.Request request) {
    return shelf.Response.ok(File('public/custom.css').readAsStringSync(),
        headers: {'content-type': 'text/css'});
  });

  app.get("/meitei_mayek.ttf", (shelf.Request request) {
    return shelf.Response.ok(File('public/meitei_mayek.ttf').readAsBytesSync(),
        headers: {'content-type': 'font/ttf'});
  });



  // Mount the /todos routes
  // app.mount('/todos', TodoRoutes(db).router.call);
  app.mount('/auth', AuthRoutes(db).router.call);
  app.mount('/users', UserRoute(db).router.call);
  app.mount('/clans', ClanRoutes(db).router.call);
  app.mount('/surnames', SurnameRoutes(db).router.call);
  app.mount('/yek_details', YekDetailsRoutes(db).route.call);
  app.mount('/yelhen', YelhenRoutes(db).route.call);
  app.mount('/apokpa_khoiramba_numit', ApokpaKhoirambaNumitroutes(db).router.call);




  // Build middleware + handler pipeline
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addMiddleware(corsMiddleware) // your custom CORS middleware
      .addMiddleware(jwtAuthMiddleware) // add database middleware
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
  return shelf.Response.ok(File('public/index.html').readAsStringSync(),
      headers: {'content-type': 'text/html'});
}
