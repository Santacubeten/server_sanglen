import 'package:shelf/shelf.dart';

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
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        clan_id INT NOT NULL,
        FOREIGN KEY (clan_id) REFERENCES clans(id) ON DELETE CASCADE
      )
    ''');
  }

  // ─────────────────────────────────────────────────────────────
  /// CREATE (Insert new yelhen)
  Future<void> createYelhen(YelhenModel yelhen) async {
    final db = _connection.pool;
    
    final missingKeys = validateRequiredParams(
      model: yelhen,
      params: ['name', 'description', 'clan_id'],
    );

    if (missingKeys.isNotEmpty) {
      Response.badRequest(
        body: 'Missing required fields: ${missingKeys.join(', ')}',
      );
    } else if (yelhen.clanId <= 0) {
      Response.badRequest(body: 'Invalid clan ID: ${yelhen.clanId}');
    }
    await db.execute(
      '''
      INSERT INTO yelhen (name, description) 
      VALUES (:name, :description)
      ''',
      {
        'name': yelhen.name,
        'description': yelhen.description,
        'clan_id': yelhen.clanId,
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
        clanId:
            row.colByName('clan_id') as int, // Assuming description is optional
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
      clanId:
          row.colByName('clan_id') as int, // Assuming description is optional

      description: row.colByName('description'),
    );
  }

  ///READ (Get yelhens by clan ID)
  Future<List<YelhenModel>> getYelhensByClanId(int clanId) async {
    final db = _connection.pool;
    final result = await db.execute(
      'SELECT * FROM yelhen WHERE clan_id = :clan_id',
      {'clan_id': clanId},
    );

    return result.rows.map((row) {
      return YelhenModel(
        id: row.colByName('id') as int,
        name: row.colByName('name') as String,
        clanId: row.colByName('clan_id') as int,
        description: row.colByName('description'),
      );
    }).toList();
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

// helper;
List<String> validateRequiredParams<T>({
  required T model,
  required List<String> params,
}) {
  final json = (model as dynamic).toJson() as Map<String, dynamic>;

  List<String> missing = [];

  for (var key in params) {
    final value = json[key];
    if (value == null || (value is String && value.trim().isEmpty)) {
      missing.add(key);
    }
  }

  return missing;
}
