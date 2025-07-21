import '../database/db_connection.dart';
import '../models/yek_details.model.dart';

class YekDetailRepository {
  final DBConnection _connection;

  YekDetailRepository(this._connection);

  /// ✅ Create the 'yek_details' table if it doesn't exist
  Future<void> createTable() async {
    print('Creating yek_details table if not exists');
    final conn = _connection.pool;

    await conn.execute('''
  CREATE TABLE IF NOT EXISTS yek_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clan_id INT NOT NULL,
    firewood VARCHAR(255) NOT NULL,
    color VARCHAR(10),
    flower VARCHAR(100),
    fruit VARCHAR(100),
    fish VARCHAR(100),
    sword VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clan_id) REFERENCES clans(id) ON DELETE CASCADE
  )
  ''');
  }

  /// ✅ Insert a new yek detail
  Future<void> createYekDetails(YekDetailsModel yekDetails) async {
    final conn = _connection.pool;

    await conn.execute(
      '''
      INSERT INTO yek_details (
        clan_id, firewood, color, flower, fruit, fish, sword
      ) VALUES (
        :clan_id, :firewood, :color, :flower, :fruit, :fish, :sword
      )
      ''',
      {
        'clan_id': yekDetails.clanId,
        'firewood': yekDetails.firewood,
        'color': yekDetails.color,
        'flower': yekDetails.flower,
        'fruit': yekDetails.fruit,
        'fish': yekDetails.fish,
        'sword': yekDetails.sword,
      },
    );
  }

  /// ✅ Get all yek details
  Future<List<YekDetailsModel>> getAllYekDetails() async {
    final conn = _connection.pool;

    final results = await conn.execute('SELECT * FROM yek_details');

    return results.rows.map((row) {
      final data = row.assoc();

      return YekDetailsModel.fromJson({
        'id': int.tryParse(data['id'] ?? ''),
        'clan_id': int.parse(data['clan_id'] ?? '0'),
        'firewood': data['firewood'] ?? '',
        'color': data['color'] ?? '',
        'flower': data['flower'],
        'fruit': data['fruit'],
        'fish': data['fish'],
        'sword': data['sword'],
        'created_at': data['created_at'],
      });
    }).toList();
  }

  /// ✅ Get a single yek detail by ID
  Future<YekDetailsModel?> getYekDetailById(int id) async {
    final conn = _connection.pool;

    final result = await conn.execute(
      'SELECT * FROM yek_details WHERE id = :id',
      {'id': id},
    );

    if (result.rows.isEmpty) return null;

    final data = result.rows.first.assoc();

    return YekDetailsModel.fromJson({
      'id': int.tryParse(data['id'] ?? ''),
      'clan_id': int.parse(data['clan_id'] ?? '0'),
      'firewood': data['firewood'] ?? '',
      'color': data['color'] ?? '',
      'flower': data['flower'],
      'fruit': data['fruit'],
      'fish': data['fish'],
      'sword': data['sword'],
      'created_at': data['created_at'],
    });
  }

  /// ✅ Get a single yek detail by ID
  Future<YekDetailsModel?> getYekDetailsByClanId(int clanId) async {
    final conn = _connection.pool;

    final result = await conn.execute(
      'SELECT * FROM yek_details WHERE clan_id = :id',
      {'id': clanId},
    );

    if (result.rows.isEmpty) return null;

    final data = result.rows.first.assoc();

    return YekDetailsModel.fromJson({
      'id': int.tryParse(data['id'] ?? ''),
      'clan_id': int.parse(data['clan_id'] ?? '0'),
      'firewood': data['firewood'] ?? '',
      'color': data['color'] ?? '',
      'flower': data['flower'],
      'fruit': data['fruit'],
      'fish': data['fish'],
      'sword': data['sword'],
      'created_at': data['created_at'],
    });
  }

  Future<void> updatePartialYekDetails(
      int id, Map<String, dynamic> data) async {
    final conn = _connection.pool;

    // Check if the record exists
    final result = await conn.execute(
      'SELECT COUNT(*) as count FROM yek_details WHERE id = :id',
      {'id': id},
    );

    final count = int.tryParse(result.rows.first.assoc()['count'] ?? '0') ?? 0;

    if (count == 0) {
      throw Exception('YekDetail with ID $id does not exist.');
    }

    // Build dynamic SQL
    final setClauses = data.keys.map((key) => '$key = :$key').join(', ');
    final sql = '''
    UPDATE yek_details
    SET $setClauses
    WHERE id = :id
  ''';

    // Add 'id' to the data map
    data['id'] = id;

    await conn.execute(sql, data);
  }

  /// ✅ Delete a yek detail by ID
  Future<void> deleteYekDetail(int id) async {
    final conn = _connection.pool;

    await conn.execute(
      'DELETE FROM yek_details WHERE id = :id',
      {'id': id},
    );
  }

  Future<Map<String, dynamic>?> yekThonknabra(
      int ahanbaYumakId, int akombaYumakId) async {
    final conn = _connection.pool;

    // Query first surname
    final result1 = await conn.execute(
      '''
    SELECT name, clan_id 
    FROM sanglen.surnames 
    WHERE id = :id
    ''',
      {'id': ahanbaYumakId},
    );

    // Query second surname
    final result2 = await conn.execute(
      '''
    SELECT name, clan_id 
    FROM sanglen.surnames 
    WHERE id = :id
    ''',
      {'id': akombaYumakId},
    );

    // If either result is empty
    if (result1.rows.isEmpty || result2.rows.isEmpty) {
      return {
        'surname1': '',
        'clanId1': null,
        'surname2': '',
        'clanId2': null,
        'sameClan': false,
        'clanName': null,
      };
    }

    final row1 = result1.rows.first;
    final row2 = result2.rows.first;

    final surname1 = row1.colByName('name') ?? '';
    final clanId1 = row1.colByName('clan_id');

    final surname2 = row2.colByName('name') ?? '';
    final clanId2 = row2.colByName('clan_id');

    final sameClan = clanId1 != null && clanId1 == clanId2;

    // Optional: get clan name if same clan

    final clan1Result = await conn.execute(
      '''
      SELECT name FROM sanglen.clans WHERE id = :id
      ''',
      {'id': clanId1},
    );

    final clan2Result = await conn.execute(
      '''
      SELECT name FROM sanglen.clans WHERE id = :id
      ''',
      {'id': clanId2},
    );

    return {
      'surname_1': surname1,
      'clan_id_1': clanId1,
      'clan_name_1': clan1Result.rows.first.colByName('name'),
      'surname_2': surname2,
      'clan_id_2': clanId2,
      'same_clan': sameClan,
      'clan_name_2': clan2Result.rows.first.colByName('name'),
    };
  }
}
