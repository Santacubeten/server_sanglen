import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../models/clan.model.dart';
import '../database/db_connection.dart';
import '../repository/clan_repository.dart';
import '../utils/response_helper.dart';

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
      final clan = ClanModel.fromJson(jsonDecode(body));
      await _clanRepository.createClan(clan);
      return AppResponse.success(
        message: 'Clan created successfully',
        data: clan.toJson(),
      );
    });

    router.get('/', (Request request) async {
      final clans = await _clanRepository.getAllClans();
      return AppResponse.success(data: clans.map((c) => c.toJson()).toList());
    });

    router.get('/origin', (Request request) async {
      final clans = await _clanRepository.getOrigin();
      return AppResponse.success(data: clans);
    });

    router.get('/<id>', (Request request, String id) async {
      final clan = await _clanRepository.getClanById(int.parse(id));
      if (clan != null) {
        return AppResponse.success(data: clan.toJson());
      }
      return AppResponse.notFound(message: 'Clan not found with ID: $id');
    });

    router.put('/<id>', (Request request, String id) async {
      final body = await request.readAsString();
      final clan = ClanModel.fromJson(jsonDecode(body));
      await _clanRepository.updateClan(clan);
      return AppResponse.success(
        message: 'Clan updated successfully',
        data: clan.toJson(),
      );
    });

    router.delete('/<id>', (Request request, String id) async {
      await _clanRepository.deleteClan(int.parse(id));
      return AppResponse.success(message: 'Clan deleted successfully');
    });

    return router;
  }
}
