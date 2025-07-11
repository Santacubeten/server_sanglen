import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/clan.dart';
import '../database/db_connection.dart';

class ClanRoutes {
  final DBConnection _connection;

  ClanRoutes(this._connection);

  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final clan = Clan.fromJson(jsonDecode(body));
      await _connection.clanTable.createClan(clan);
      return Response.ok('Clan created');
    });

    router.get('/', (Request request) async {
      final clans = await _connection.clanTable.getAllClans();
      return Response.ok(jsonEncode(clans.map((e) => e.toJson()).toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      final clan = await _connection.clanTable.getClanById(int.parse(id));
      if (clan != null) {
        return Response.ok(jsonEncode(clan.toJson()));
      }
      return Response.notFound('Clan not found');
    });

    router.put('/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final clan = Clan.fromJson(jsonDecode(body));
      await _connection.clanTable.updateClan(clan);
      return Response.ok('Clan updated');
    });

    router.delete('/<id>', (Request request, String id) async {
      await _connection.clanTable.deleteClan(int.parse(id));
      return Response.ok('Clan deleted');
    });

    return router;
  }
}
