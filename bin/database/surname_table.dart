import 'package:mysql_client/mysql_client.dart';
import '../models/surname.dart';
import 'db_connection.dart';

class SurnameTable {
  final DBConnection _connection;

  SurnameTable(this._connection);

  Future<void> createTable() async {
    final conn = _connection.pool;
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS surnames (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        clan_id INT NOT NULL,
        FOREIGN KEY (clan_id) REFERENCES clans(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> createSurname(Surname surname) async {
    final conn = _connection.pool;
    await conn.execute(
      'INSERT INTO surnames (name, clan_id) VALUES (:name, :clan_id)',
      {'name': surname.name, 'clan_id': surname.clanId},
    );
  }

  Future<List<Surname>> getAllSurnames() async {
    final conn = _connection.pool;
    final result = await conn.execute('SELECT * FROM surnames');
    return result.rows.map((row) => Surname.fromJson(row.assoc())).toList();
  }

  Future<List<Surname>> getSurnamesByClanId(int clanId) async {
    final conn = _connection.pool;
    final result = await conn.execute('SELECT * FROM surnames WHERE clan_id = :clan_id', {'clan_id': clanId});
    return result.rows.map((row) => Surname.fromJson(row.assoc())).toList();
  }

  Future<Surname?> getSurnameById(int id) async {
    final conn = _connection.pool;
    final result = await conn.execute('SELECT * FROM surnames WHERE id = :id', {'id': id});
    if (result.rows.isNotEmpty) {
      return Surname.fromJson(result.rows.first.assoc());
    }
    return null;
  }

  Future<void> updateSurname(Surname surname) async {
    final conn = _connection.pool;
    await conn.execute(
      'UPDATE surnames SET name = :name, clan_id = :clan_id WHERE id = :id',
      {'id': surname.id, 'name': surname.name, 'clan_id': surname.clanId},
    );
  }

  Future<void> deleteSurname(int id) async {
    final conn = _connection.pool;
    await conn.execute('DELETE FROM surnames WHERE id = :id', {'id': id});
  }
}
