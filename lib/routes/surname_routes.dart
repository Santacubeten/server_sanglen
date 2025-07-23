import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/surname.model.dart';
import '../database/db_connection.dart';
import '../utils/response_helper.dart';

class SurnameRoutes {
  final DBConnection _connection;

  SurnameRoutes(this._connection);

  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final surname = SurnameModel.fromJson(jsonDecode(body));
      await _connection.surnameTable.createSurname(surname);
      return AppResponse.success(
        message: 'Surname created successfully',
        data: surname.toJson(),
      );
      // return Response.ok('Surname created');
    });

    router.get('/', (Request request) async {
      final surnames = await _connection.surnameTable.getAllSurnames();
      return AppResponse.success(
        data: surnames.map((s) => s.toJson()).toList(),
      );
    });

    router.get('/clan/<clanId>', (Request request, String clanId) async {
      final surnames =
          await _connection.surnameTable.getSurnamesByClanId(int.parse(clanId));
      if (surnames.isEmpty) {
        return AppResponse.notFound(
          message: 'No surnames found for clan ID: $clanId',
        );
      }
      return AppResponse.success(
        data: surnames.map((s) => s.toJson()).toList(),
      );
    });

    router.get('/<id>', (Request request, String id) async {
      final surname =
          await _connection.surnameTable.getSurnameById(int.parse(id));
      if (surname != null) {
        return AppResponse.success(data: surname.toJson());
      }
      return AppResponse.notFound(message: 'Surname not found with ID: $id');
    });

    router.put('/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final surname = SurnameModel.fromJson(jsonDecode(body));
      await _connection.surnameTable.updateSurname(surname);
      return AppResponse.success(
        message: 'Surname updated successfully',
        data: surname.toJson(),
      );
    });

    router.delete('/<id>', (Request request, String id) async {
      await _connection.surnameTable.deleteSurname(int.parse(id));
      return AppResponse.success(message: 'Surname deleted successfully');
    });

    return router;
  }
}
