import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/surname.model.dart';
import '../database/db_connection.dart';

class SurnameRoutes {
  final DBConnection _connection;

  SurnameRoutes(this._connection);

  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final surname = SurnameModel.fromJson(jsonDecode(body));
      await _connection.surnameTable.createSurname(surname);
      return Response.ok('Surname created');
    });

    router.get('/', (Request request) async {
      final surnames = await _connection.surnameTable.getAllSurnames();
      return Response.ok(jsonEncode(surnames.map((e) => e.toJson()).toList()));
    });

    router.get('/clan/<clanId>', (Request request, String clanId) async {
      final surnames = await _connection.surnameTable.getSurnamesByClanId(int.parse(clanId));
      return Response.ok(jsonEncode(surnames.map((e) => e.toJson()).toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      final surname = await _connection.surnameTable.getSurnameById(int.parse(id));
      if (surname != null) {
        return Response.ok(jsonEncode(surname.toJson()));
      }
      return Response.notFound('Surname not found');
    });

    router.put('/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final surname = SurnameModel.fromJson(jsonDecode(body));
      await _connection.surnameTable.updateSurname(surname);
      return Response.ok('Surname updated');
    });

    router.delete('/<id>', (Request request, String id) async {
      await _connection.surnameTable.deleteSurname(int.parse(id));
      return Response.ok('Surname deleted');
    });

    return router;
  }
}
