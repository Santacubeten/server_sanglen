import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../repository/yelhen_repository.dart';
import '../models/yelhen.model.dart';

final header = {
  'Content-Type': 'application/json',
};

class YelhenRoutes {
  final DBConnection _connection;
  late final YelhenRepository _yelhenRepository;

  YelhenRoutes(this._connection) {
    _yelhenRepository = YelhenRepository(_connection);
  }

  Router get route {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      try {
        jsonDecode(body);
      } catch (e) {
        return Response(400, body: 'Invalid JSON format $e');
      }
      final yelhen = YelhenModel.fromJson(jsonDecode(body));
      await _yelhenRepository.createYelhen(yelhen);
      return Response.ok('Yelhen created');
    });

    router.get('/', (Request request) async {
      final yelhens = await _yelhenRepository.getAllYelhens();
      return Response.ok(jsonEncode(yelhens.map((e) => e.toJson()).toList()),
          headers: header);
    });

    router.get('/<id>', (Request request, String id) async {
      final yelhen = await _yelhenRepository.getYelhenById(int.parse(id));
      if (yelhen != null) {
        return Response.ok(jsonEncode(yelhen.toJson()), headers: header);
      }
      return Response.notFound('Yelhen not found');
    });

    router.get('/by_clan_id/<clanId>', (Request request, String clanId) async {
      try {
        final int id = int.parse(clanId);
        final yelhens = await _yelhenRepository.getYelhensByClanId(id);

        if (yelhens.isEmpty) {
          return Response.notFound('No Yelhens found for clan ID: $clanId');
        }

        return Response.ok(jsonEncode(yelhens.map((e) => e.toJson()).toList()),
            headers: header);
      } catch (e) {
        return Response(400, body: 'Invalid clan ID format: $clanId');
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      await _yelhenRepository.deleteYelhen(int.parse(id));
      return Response.ok('Yelhen deleted');
    });

    return router;
  }
}
