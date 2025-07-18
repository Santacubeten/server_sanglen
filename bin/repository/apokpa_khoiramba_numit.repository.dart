import '../database/db_connection.dart';
import '../models/apokpa_khoiramba_numit.model.dart';

class ApokpaKhoirambaNumitRepository {
  final DBConnection _connection;
  ApokpaKhoirambaNumitRepository(this._connection);

  Future<void> createTable() async {
    final conn = _connection.pool;
    await conn.execute('''
  CREATE TABLE IF NOT EXISTS apokpa_khoiramba_numit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    clan_id INT NOT NULL,
    numit VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (clan_id) REFERENCES clans(id) ON DELETE CASCADE
  )
  ''');
  }

  Future<void> createApokpaKhoirambaNumit(int clanId, String numit) async {
    final conn = _connection.pool;
    await conn.execute(
      'INSERT INTO apokpa_khoiramba_numit (clan_id, numit) VALUES (:clan_id, :numit)',
      {'clan_id': clanId, 'numit': numit},
    );
  }

  Future<List<ApokpaKhoirambaNumitModel>> getAllApokpaKhoirambaNumit() async {
    final conn = _connection.pool;
    final result = await conn.execute('SELECT * FROM apokpa_khoiramba_numit');
    return result.rows.map((row) {
      return ApokpaKhoirambaNumitModel(
        id: int.tryParse('${row.colByName('id')}') ?? 0,
        numit:'${row.colByName('numit')}',
        clanId: int.tryParse('${row.colByName('clan_id')}') ?? 0,
      );
    }).toList();
  }

  Future getApokpaKhoirambaNumitById(int parse) async {
    final conn = _connection.pool;
    final result = await conn.execute(
      'SELECT * FROM apokpa_khoiramba_numit WHERE id = :id',
      {'id': parse},
    );
    if (result.rows.isNotEmpty) {
      final row = result.rows.first;
      return ApokpaKhoirambaNumitModel(
        id: int.tryParse('${row.colByName('id')}') ?? 0,
        numit: '${row.colByName('numit')}',
        clanId: int.tryParse('${row.colByName('clan_id')}') ?? 0,
      );
    }
    return null;
  }

  Future<void> deleteApokpaKhoirambaNumit(int parse) async {
    final conn = _connection.pool;
    await conn.execute(
      'DELETE FROM apokpa_khoiramba_numit WHERE id = :id',
      {'id': parse},
    );
  }

  Future getApokpaKhoirambaNumitByClanId(int id) async {
    final conn = _connection.pool;
    final result = await conn.execute(
      'SELECT * FROM apokpa_khoiramba_numit WHERE clan_id = :clan_id',
      {'clan_id': id},
    );
    return result.rows.map((row) {
      return ApokpaKhoirambaNumitModel(
        id: int.tryParse('${row.colByName('id')}') ?? 0,
        numit: '${row.colByName('numit')}',
        clanId: int.tryParse('${row.colByName('clan_id')}') ?? 0,
      );
    }).toList();
  }


}
