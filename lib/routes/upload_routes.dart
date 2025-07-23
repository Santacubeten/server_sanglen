import 'dart:io';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'package:server/database/db_connection.dart';
import 'package:server/utils/response_helper.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class UploadRoute {
  final DBConnection _connection;

  UploadRoute(this._connection);

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      final res = await _connection.uploadRepositoy.getAllUploaded();
      return AppResponse.success(data: res);
    });

    router.post('/', (Request request) async {
      final contentType = request.headers['Content-Type'];
      if (contentType == null || !contentType.contains('multipart/form-data')) {
        return Response(400, body: 'Bad Request: Expected multipart/form-data');
      }

      // Extract boundary
      final boundary = contentType.split('boundary=').last.trim();
      final transformer = MimeMultipartTransformer(boundary);
      final bodyStream = request.read().cast<List<int>>();

      try {
        final parts = await bodyStream.transform(transformer).toList();

        for (final part in parts) {
          final headers = part.headers;
          final disposition = headers['content-disposition'];
          final match =
              RegExp(r'filename="(.+?)"').firstMatch(disposition ?? '');

          if (match != null) {
            final filename = match.group(1)!;
            final fileBytes =
                await part.fold<List<int>>([], (b, d) => b..addAll(d));

            final uploadDir = Directory('uploads');
            if (!uploadDir.existsSync()) {
              uploadDir.createSync(recursive: true);
            }

            final file = File('uploads/$filename');
            await file.writeAsBytes(fileBytes);

            await _connection.uploadRepositoy.upload(filename, file.path);

            return Response.ok('File "$filename" uploaded successfully.');
          }
        }

        return Response(400, body: 'No valid file found in request.');
      } catch (e) {
        return Response.internalServerError(body: 'Error: $e');
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      final (path, msg) = await _connection.uploadRepositoy.delete(id);

      if (path == null) {
        return AppResponse.error(message: msg);
      } else {
        // Debugging log
        print('Returned path: $path');

        final file = File(path);

        print('Absolute path: ${file.absolute.path}');
        final exists = await file.exists();
        print('Exists: $exists');

        if (exists) {
          await file.delete();
          print('Deleted file: ${file.path}');
        } else {
          print('File not found: ${file.path}');
        }

        return AppResponse.success(message: "Successfully deleted! ' ${path.split('/').last} '");
      }
    });

    return router;
  }
}
