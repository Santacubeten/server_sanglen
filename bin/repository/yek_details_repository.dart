import '../database/db_connection.dart';
import '../models/yek_details.dart';

class YekDetailRepository {
  final DBConnection _connection;

  YekDetailRepository(this._connection);

  /// ✅ Create the 'yek_details' table if it doesn't exist
  Future<void> createTable() async {
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
  Future<void> createYekDetails(YekDetails yekDetails) async {
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
  Future<List<YekDetails>> getAllYekDetails() async {
    final conn = _connection.pool;

    final results = await conn.execute('SELECT * FROM yek_details');

    return results.rows.map((row) {
      final data = row.assoc();

      return YekDetails.fromJson({
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
  Future<YekDetails?> getYekDetailById(int id) async {
    final conn = _connection.pool;

    final result = await conn.execute(
      'SELECT * FROM yek_details WHERE id = :id',
      {'id': id},
    );

    if (result.rows.isEmpty) return null;

    final data = result.rows.first.assoc();

    return YekDetails.fromJson({
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
  Future<YekDetails?> getYekDetailsByClanId(int clanId) async {
    final conn = _connection.pool;

    final result = await conn.execute(
      'SELECT * FROM yek_details WHERE clan_id = :id',
      {'id': clanId},
    );

    if (result.rows.isEmpty) return null;

    final data = result.rows.first.assoc();

    return YekDetails.fromJson({
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
}
