import 'dart:convert';

import 'package:shelf/shelf.dart';
import '../database/db_connection.dart';
import 'package:shelf_router/shelf_router.dart';
import '../config/utils/response_helper.dart';
import '../models/apokpa_khoiramba_numit.model.dart';
import '../repository/apokpa_khoiramba_numit.repository.dart';

class ApokpaKhoirambaNumitroutes {
  final DBConnection _connection;
  late final ApokpaKhoirambaNumitRepository _apokpaKhoirambaNumitRepository;

  ApokpaKhoirambaNumitroutes(this._connection) {
    _apokpaKhoirambaNumitRepository =
        ApokpaKhoirambaNumitRepository(_connection);
  }

  Router get router {
    final router = Router();

    router.get('/', (Request request) async {
      final numitDetails =
          await _apokpaKhoirambaNumitRepository.getAllApokpaKhoirambaNumit();
      if (numitDetails.isEmpty) {
        return AppResponse.success(
          message: 'No Apokpa Khoiramba Numit record found',
          data: [],
        );
      }
      return AppResponse.success(
        data: numitDetails.map((e) => e.toJson()).toList(),
      );
    });
    router.get('/<id>', (Request request, String id) async {
      final numitDetail = await _apokpaKhoirambaNumitRepository
          .getApokpaKhoirambaNumitById(int.parse(id));
      if (numitDetail != null) {
        return AppResponse.success(data: numitDetail.toJson());
      }
      return AppResponse.notFound(
        message: 'Apokpa Khoiramba Numit not found with ID: $id',
      );
    });
    router.post('/', (Request request) async {
      final body = await request.readAsString();
      try {
        final numitDetail =
            ApokpaKhoirambaNumitModel.fromJson(jsonDecode(body));
        await _apokpaKhoirambaNumitRepository.createApokpaKhoirambaNumit(
            numitDetail.clanId, numitDetail.numit);
        return AppResponse.success(
          message: 'Apokpa Khoiramba Numit created successfully',
          data: numitDetail.toJson(),
        );
      } catch (e) {
        return AppResponse.error(
          message: 'Error creating Apokpa Khoiramba Numit: ${e.toString()}',
          code: 400,
        );
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      try {
        await _apokpaKhoirambaNumitRepository
            .deleteApokpaKhoirambaNumit(int.parse(id));
        return AppResponse.success(
            message: 'Apokpa Khoiramba Numit deleted successfully');
      } catch (e) {
        return AppResponse.error(
          message: 'Error deleting Apokpa Khoiramba Numit: ${e.toString()}',
          code: 400,
        );
      }
    });

    router.get('/by_clan_id/<clanId>', (Request request, String clanId) async {
      try {
        final int id = int.parse(clanId);
        final numitDetails = await _apokpaKhoirambaNumitRepository
            .getApokpaKhoirambaNumitByClanId(id);

        if (numitDetails.isEmpty) {
          return AppResponse.notFound(
            message: 'No Apokpa Khoiramba Numit found for clan ID: $clanId',
          );
        }

        return AppResponse.success(
          data: numitDetails.map((e) => e.toJson()).toList(),
        );
      } catch (e) {
        return AppResponse.error(
          message: 'Invalid clan ID format: $clanId',
          code: 400,
        );
      }
    });

    

    return router;
  }
}
