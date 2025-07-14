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
      final yekDetails = YekDetails.fromJson(jsonDecode(body));
      await _yekDetailRepository.createYekDetails(yekDetails);
      return Response.ok('yek created');
    });
    router.get('/', (Request request)async{
      final yekDetails = await _yekDetailRepository.getAllYekDetails();
      return Response.ok(jsonEncode(yekDetails.map((e) => e.toJson(),).toList()));
    });

    return router;
  }
}
