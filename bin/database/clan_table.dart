import 'package:mysql_client/mysql_client.dart';
import '../models/clan.dart';
import 'db_connection.dart';

class ClanTable {
  final DBConnection _connection;

  ClanTable(this._connection);

  Future<void> createTable() async {
    final conn = _connection.pool;
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS clans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        created_by VARCHAR(255)
      )
    ''');
  }

  Future<void> createClan(Clan clan) async {
    final conn = _connection.pool;
    await conn.execute(
      'INSERT INTO clans (name, created_by) VALUES (:name, :created_by)',
      {'name': clan.name, 'created_by': clan.createdBy},
    );
  }

  Future<List<Clan>> getAllClans() async {
    final conn = _connection.pool;
    final result = await conn.execute('SELECT * FROM clans');
    return result.rows.map((row) => Clan.fromJson(row.assoc())).toList();
  }

  Future<Clan?> getClanById(int id) async {
    final conn = _connection.pool;
    final result =
        await conn.execute('SELECT * FROM clans WHERE id = :id', {'id': id});
    if (result.rows.isNotEmpty) {
      return Clan.fromJson(result.rows.first.assoc());
    }
    return null;
  }

  Future<void> updateClan(Clan clan) async {
    final conn = _connection.pool;
    await conn.execute(
      'UPDATE clans SET name = :name, created_by = :created_by WHERE id = :id',
      {'id': clan.id, 'name': clan.name, 'created_by': clan.createdBy},
    );
  }

  Future<void> deleteClan(int id) async {
    final conn = _connection.pool;
    await conn.execute('DELETE FROM clans WHERE id = :id', {'id': id});
  }
}
