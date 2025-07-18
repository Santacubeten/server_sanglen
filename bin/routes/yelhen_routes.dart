import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../repository/yelhen_repository.dart';
import '../models/yelhen.model.dart';
import '../config/utils/response_helper.dart';



class YelhenRoutes {
  final DBConnection _connection;
  late final YelhenRepository _yelhenRepository;

  YelhenRoutes(this._connection) {
    _yelhenRepository = YelhenRepository(_connection);
  }

  Router get route {
    final router = Router();

    router.post('/', (Request request) async {
      try {
        final body = await request.readAsString();
        final yelhen = YelhenModel.fromJson(jsonDecode(body));
        await _yelhenRepository.createYelhen(yelhen);
        return AppResponse.success(
          message: 'Yelhen created successfully',
          data: yelhen.toJson(),
        );
      } catch (e) {
        return AppResponse.error(
          message: 'Error creating Yelhen: ${e.toString()}',
          code: 400,
        );
      }
    });

    router.get('/', (Request request) async {
      final yelhens = await _yelhenRepository.getAllYelhens();
    return AppResponse.success(
        data: yelhens.map((e) => e.toJson()).toList(),
      );
    });

    router.get('/<id>', (Request request, String id) async {
      final yelhen = await _yelhenRepository.getYelhenById(int.parse(id));
      if (yelhen != null) {
       return AppResponse.success(data: yelhen.toJson());
      }else {
        return AppResponse.notFound(
          message: 'Yelhen not found with ID: $id',
        );
      }
  
    });

    router.get('/by_clan_id/<clanId>', (Request request, String clanId) async {
      try {
        final int id = int.parse(clanId);
        final yelhens = await _yelhenRepository.getYelhensByClanId(id);

        if (yelhens.isEmpty) {
          return Response.notFound('No Yelhens found for clan ID: $clanId');
        }

        return AppResponse.success(
          data: yelhens.map((e) => e.toJson()).toList(),
        );
      } catch (e) {
        return Response(400, body: 'Invalid clan ID format: $clanId');
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      await _yelhenRepository.deleteYelhen(int.parse(id));
      return AppResponse.success(
        message: 'Yelhen deleted successfully',
      );
    });

    return router;
  }
}
