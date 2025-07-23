import 'dart:io';
import 'package:server/database/db_connection.dart';
import 'package:server/middleware/middleware.dart';
import 'package:server/routes/apokpa_khoiramba_numit.routes.dart';
import 'package:server/routes/auth.routes.dart';
import 'package:server/routes/clan_routes.dart';
import 'package:server/routes/public.routes.dart';
import 'package:server/routes/surname_routes.dart';
import 'package:server/routes/user.route.dart';
import 'package:server/routes/yek_details_routes.dart';
import 'package:server/routes/yelhen_routes.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';


Future<void> main() async {
  // Initialize MySQL database connection
  final db = DBConnection.instance;
  await db.connectdb();

  // Initialize Shelf Router
  final protected = Router();
  final public = Router();

  //Public routes
  // This route does not require authentication
  public.mount('/', PublicRoutes(db).router.call);

  //Protected routes
  protected.mount('/auth', AuthRoutes(db).router.call);
  protected.mount('/users', UserRoute(db).router.call);
  protected.mount('/clans', ClanRoutes(db).router.call);
  protected.mount('/surnames', SurnameRoutes(db).router.call);
  protected.mount('/yek_details', YekDetailsRoutes(db).route.call);
  protected.mount('/yelhen', YelhenRoutes(db).route.call);
  protected.mount(
      '/apokpa_khoiramba_numit', ApokpaKhoirambaNumitroutes(db).router.call);

  final handler = shelf.Cascade()
      .add(
        const shelf.Pipeline()
            .addMiddleware(shelf.logRequests())
            .addMiddleware(corsMiddleware)
            .addHandler(public.call),
      )
      .add(
        const shelf.Pipeline()
            .addMiddleware(shelf.logRequests())
            .addMiddleware(corsMiddleware)
            .addMiddleware(jwtAuthMiddleware) // ✅ Only applied to non-open
            .addHandler(protected.call),
      )
      .handler;

  // // Build middleware + handler pipeline
  // final handler = const shelf.Pipeline()

  //     .addMiddleware(shelf.logRequests())
  //     .addMiddleware(corsMiddleware) // your custom CORS middleware
  //     .addMiddleware(jwtAuthMiddleware) // add database middleware
  //     .addHandler(app.call);

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
