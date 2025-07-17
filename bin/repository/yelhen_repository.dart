import '../models/yelhen.model.dart';
import '../database/db_connection.dart';

class YelhenRepository {
  final DBConnection _connection;

  YelhenRepository(this._connection);

  // ─────────────────────────────────────────────────────────────
  /// CREATE TABLE if not exists
  Future<void> createTable() async {
    final db = _connection.pool;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS yelhen (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        description TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // ─────────────────────────────────────────────────────────────
  /// CREATE (Insert new yelhen)
  Future<void> createYelhen(YelhenModel yelhen) async {
    final db = _connection.pool;
    await db.execute(
      '''
      INSERT INTO yelhen (name, description) 
      VALUES (:name, :description)
      ''',
      {
        'name': yelhen.name,
        'description': yelhen.description,
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  /// READ (Get all yelhens)
  Future<List<YelhenModel>> getAllYelhens() async {
    final db = _connection.pool;
    final result = await db.execute('SELECT * FROM yelhen');

    return result.rows.map((row) {
      return YelhenModel(
        id: row.colByName('id') as int,
        name: row.colByName('name') as String,
        description: row.colByName('description'),
      );
    }).toList();
  }

  // ─────────────────────────────────────────────────────────────
  /// READ (Get yelhen by ID)
  Future<YelhenModel?> getYelhenById(int id) async {
    final db = _connection.pool;
    final result = await db.execute(
      'SELECT * FROM yelhen WHERE id = :id',
      {'id': id},
    );

    if (result.rows.isEmpty) return null;

    final row = result.rows.first;
    return YelhenModel(
      id: row.colByName('id') as int,
      name: row.colByName('name') as String,
      description: row.colByName('description'),
    );
  }

  // ─────────────────────────────────────────────────────────────
  /// UPDATE
  Future<void> updateYelhen(int id, Map<String, dynamic> fields) async {
    final db = _connection.pool;
    if (fields.isEmpty) return;

    final setClauses = fields.keys.map((key) => '$key = :$key').join(', ');
    final params = Map<String, dynamic>.from(fields)..['id'] = id;

    await db.execute(
      '''
      UPDATE yelhen 
      SET $setClauses
      WHERE id = :id
      ''',
      params,
    );
  }

  // ─────────────────────────────────────────────────────────────
  /// DELETE
  Future<void> deleteYelhen(int id) async {
    final db = _connection.pool;
    await db.execute(
      'DELETE FROM yelhen WHERE id = :id',
      {'id': id},
    );
  }
}
// ─────────────────────────────────────────────────────────────
/// COPY WITH
