import '../database/db_connection.dart';
import '../models/yek_details.dart';

class YekDetailRepository {
  final DBConnection _connection;

  YekDetailRepository(this._connection);

  Future<void> createYekDetails(YekDetails yekDetails) async {
    final conn = _connection.pool;

    await conn.execute(
      '''
      INSERT INTO yek_details (
        clan_id, name, color, flower, fruit, fish, sword
      ) VALUES (
        :clan_id, :name, :color, :flower, :fruit, :fish, :sword
      )
      ''',
      {
        'clan_id': yekDetails.clanId,
        'name': yekDetails.name,
        'color': yekDetails.color,
        'flower': yekDetails.flower,
        'fruit': yekDetails.fruit,
        'fish': yekDetails.fish,
        'sword': yekDetails.sword,
      },
    );
  }

Future<List<YekDetails>> getAllYekDetails() async {
  final conn = _connection.pool;

  final results = await conn.execute('SELECT * FROM yek_details');

  return results.rows.map((row) {
    final data = row.assoc();

    return YekDetails.fromJson({
      'id': int.tryParse(data['id'] ?? ''),
      'clan_id': int.parse(data['clan_id'] ?? '0'),
      'name': data['name'] ?? '',
      'color': data['color'] ?? '',
      'flower': data['flower'],
      'fruit': data['fruit'],
      'fish': data['fish'],
      'sword': data['sword'],
      'created_at': data['created_at'],
    });
  }).toList();
}

}
