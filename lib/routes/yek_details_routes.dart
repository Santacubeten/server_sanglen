import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../database/db_connection.dart';
import '../repository/yek_details_repository.dart';
import '../models/yek_details.model.dart';
import '../utils/response_helper.dart';



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
        return AppResponse.error(
          message: 'Invalid JSON format: ${e.toString()}',
          code: 400,
        );
      }
      final yekDetails = YekDetailsModel.fromJson(jsonDecode(body));
      await _yekDetailRepository.createYekDetails(yekDetails);
      return AppResponse.success(
        message: 'Yek details created successfully',
        data: yekDetails.toJson(),
      );
    });
    router.get('/', (Request request) async {
      final yekDetails = await _yekDetailRepository.getAllYekDetails();
      return AppResponse.success(
        data: yekDetails.map((e) => e.toJson()).toList(),
      );
    });

    router.get('/<id>', (Request request, String id) async {
      final yekDetails =
          await _yekDetailRepository.getYekDetailById(int.parse(id));
      if (yekDetails != null) {
        return AppResponse.success(data: yekDetails.toJson());
      }
      return AppResponse.notFound(message: 'Yek Detail not found with ID: $id');
    });
    router.get('/by_clan_id/<clanId>', (Request request, String clanId) async {
      try {
        final int id = int.parse(clanId);
        final yekDetail = await _yekDetailRepository.getYekDetailsByClanId(id);

        if (yekDetail == null) {
          return AppResponse.notFound(
            message: 'No Yek details found for clan ID: $clanId',
          );
        }
        return AppResponse.success(
          data: jsonEncode(yekDetail.toJson()),
        );
      } catch (e) {
        return AppResponse.error(
          message: 'Invalid clan ID format: $clanId',
          code: 400,
        );
      }
    });

    router.patch('/<id>', (Request request, String id) async {
      try {
        final body = await request.readAsString();
        final Map<String, dynamic> data = jsonDecode(body);

        // Clean empty or invalid values
        data.removeWhere((key, value) => value == null);

        if (data.isEmpty) {
          return AppResponse.error(
            message: 'No valid fields provided for update',
            code: 400,
          );
        }

        final parsedId = int.tryParse(id);
        if (parsedId == null) {
          return AppResponse.error(
            message: 'Invalid ID format: $id',
            code: 400,
          );
        }

        await _yekDetailRepository.updatePartialYekDetails(parsedId, data);
      } catch (e) {
        return AppResponse.error(
          message: 'Error updating Yek details: ${e.toString()}',
          code: 400,
        );
      }
    });

    router.delete('/<id>', (Request request, String id) async {
      await _yekDetailRepository.deleteYekDetail(int.parse(id));
      return AppResponse.success(message: 'Yek detail deleted successfully');
    });

    router.post('/yekthoknabra', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      if (data['ahanba_yumak_id'] == null || data['akomba_yumak_id'] == null) {
        return AppResponse.error(
          message: 'ahanba_yumak_id and akomba_yumak_id are required',
          code: 400,
        );
      }
      final phol = await _yekDetailRepository.yekThonknabra(
        data['ahanba_yumak_id'],
        data['akomba_yumak_id'],
      );

      if (phol == null) {
        return AppResponse.notFound(
          message: 'No Yek Thonknabra found for the provided IDs',
        );
      }
      return AppResponse.success(
        data: phol,
        message: 'Yek Thonknabra retrieved successfully',
      );
    });

    return router;
  }
}
