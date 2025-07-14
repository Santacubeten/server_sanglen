import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../repository/yek_details_repository.dart';
import '../models/yek_details.dart';

class YekDetailsRoutes {
  final DBConnection _connection;
  late final YekDetailRepository _yekDetailRepository;

  YekDetailsRoutes(this._connection) {
    _yekDetailRepository = YekDetailRepository(_connection);
  }

  Router get route {
    final router = Router();

    router.post('/', (Request request) async {
      final body = await request.readAsString();
      print(body);
      try {
        jsonDecode(body);
      } catch (e) {
        return Response(400, body: 'Invalid JSON format $e');
      }
      final yekDetails = YekDetails.fromJson(jsonDecode(body));
      await _yekDetailRepository.createYekDetails(yekDetails);
      return Response.ok('yek created');
    });
    router.get('/', (Request request) async {
      final yekDetails = await _yekDetailRepository.getAllYekDetails();
      return Response.ok(jsonEncode(yekDetails
          .map(
            (e) => e.toJson(),
          )
          .toList()));
    });

    router.get('/<id>', (Request request, String id) async {
      final yekDetails =
          await _yekDetailRepository.getYekDetailById(int.parse(id));
      if (yekDetails != null) {
        return Response.ok(jsonEncode(yekDetails.toJson()));
      }
      return Response.notFound('Yek details not found');
    });
    router.get('/by_clan_id/<clanId>', (Request request, String clanId) async {
      try {
        final int id = int.parse(clanId);
        final yekDetail = await _yekDetailRepository.getYekDetailsByClanId(id);

        if (yekDetail == null) {
          return Response.notFound('Yek Detail not found for clan ID: $clanId');
        }

        return Response.ok(jsonEncode(yekDetail.toJson()), headers: {
          'Content-Type': 'application/json',
        });
      } catch (e) {
        return Response.internalServerError(body: 'Error: ${e.toString()}');
      }
    });

    router.patch('/<id>', (Request request, String id) async {
      try {
        final body = await request.readAsString();
        final Map<String, dynamic> data = jsonDecode(body);

        // Clean empty or invalid values
        data.removeWhere((key, value) => value == null);

        if (data.isEmpty) {
          return Response(400, body: 'No valid fields provided for update.');
        }

        final parsedId = int.tryParse(id);
        if (parsedId == null) {
          return Response(400, body: 'Invalid ID');
        }

        await _yekDetailRepository.updatePartialYekDetails(parsedId, data);
        return Response.ok('Yek details updated');
      } catch (e) {
        return Response.internalServerError(body: 'Error: $e');
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      await _yekDetailRepository.deleteYekDetail(int.parse(id));
      return Response.ok('Yek details deleted');
    });

    return router;
  }
}
