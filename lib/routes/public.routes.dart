import '../database/db_connection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../utils/response_helper.dart';
import 'dart:io';

class PublicRoutes {
  final DBConnection _connection;
  PublicRoutes(this._connection);

  Router get router {
    final router = Router();

    router.get("/", (Request request) {
      final html = File('public/index.html');
      return Response.ok(
        html.readAsStringSync(),
        headers: {'content-type': 'text/html'},
      );
    });

    router.get("/swagger.yaml", (Request request) {
      return Response.ok(
        File('public/swagger.yaml').readAsStringSync(),
        headers: {'content-type': 'text/yaml'},
      );
    });

    // Example: GET /open/custom.css
    router.get("/custom.css", (Request request) {
      return Response.ok(
        File('public/custom.css').readAsStringSync(),
        headers: {'content-type': 'text/css'},
      );
    });

    // Example: GET /open/meitei_mayek.ttf
    router.get("/meitei_mayek.ttf", (Request request) {
      return Response.ok(
        File('public/meitei_mayek.ttf').readAsBytesSync(),
        headers: {'content-type': 'font/ttf'},
      );
    });

    return router;
  }
}
