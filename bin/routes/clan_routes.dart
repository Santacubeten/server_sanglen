import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/clan.dart';
import '../database/db_connection.dart';
import '../repository/clan_repository.dart';

class ClanRoutes {
  final DBConnection _connection;
  late final ClanRepository _clanRepository;

  ClanRoutes(this._connection) {
    _clanRepository = ClanRepository(_connection);
  }

  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      final clan = Clan.fromJson(jsonDecode(body));
      await _clanRepository.createClan(clan);
      return Response.ok('Clan created');
    });

    router.get('/', (Request request) async {
      final clans = await _clanRepository.getAllClans();
      return Response.ok(jsonEncode(clans.map((e) => e.toJson()).toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      final clan = await _clanRepository.getClanById(int.parse(id));
      if (clan != null) {
        return Response.ok(jsonEncode(clan.toJson()));
      }
      return Response.notFound('Clan not found');
    });

    router.put('/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final clan = Clan.fromJson(jsonDecode(body));
      await _clanRepository.updateClan(clan);
      return Response.ok('Clan updated');
    });

    router.delete('/<id>', (Request request, String id) async {
      await _clanRepository.deleteClan(int.parse(id));
      return Response.ok('Clan deleted');
    });

    return router;
  }
}
