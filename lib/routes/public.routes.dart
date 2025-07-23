import '../database/db_connection.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
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

    // Example: POST /upload
    // Serve files from the 'public/upload' folder
    router.get('/upload/<file|.*>', (Request request, String file) {
      final filePath = 'public/upload/$file';
      final fileToServe = File(filePath);
      if (!fileToServe.existsSync()) {
      return Response.notFound('File not found');
      }
      // Infer content type based on file extension
      final ext = file.split('.').last;
      final contentTypes = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'pdf': 'application/pdf',
      'txt': 'text/plain',
      'mp3': 'audio/mpeg',
      'mp4': 'video/mp4',
      'json': 'application/json',
      'csv': 'text/csv',
      };
      final contentType = contentTypes[ext] ?? 'application/octet-stream';
      return Response.ok(
      fileToServe.readAsBytesSync(),
      headers: {'content-type': contentType},
      );
    });



    return router;
  }
}
