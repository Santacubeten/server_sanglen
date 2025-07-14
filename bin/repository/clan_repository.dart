import '../database/db_connection.dart';
import '../database/surname_table.dart';
import '../models/clan.dart';
import '../models/surname.dart';

class ClanRepository {
  final DBConnection _connection;
  final SurnameTable _surnameTable;

  ClanRepository(this._connection) : _surnameTable = SurnameTable(_connection);

  Future<void> createTable() async {
    final conn = _connection.pool;
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS clans (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        created_by VARCHAR(255) NOT NULL
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
    final clans = <Clan>[];
    for (final row in result.rows) {
      final clanData = row.assoc();
      final clanId = int.parse(clanData['id']!);
      final surnames = await _surnameTable.getSurnamesByClanId(clanId);
      clans.add(Clan.fromJson(clanData).copyWith(surnames: surnames));
    }
    return clans;
  }

  Future<Clan?> getClanById(int id) async {
    final conn = _connection.pool;
    final result =
        await conn.execute('SELECT * FROM clans WHERE id = :id', {'id': id});
    if (result.rows.isNotEmpty) {
      final clanData = result.rows.first.assoc();
      final clanId = int.parse(clanData['id']!);
      final surnames = await _surnameTable.getSurnamesByClanId(clanId);
      return Clan.fromJson(clanData).copyWith(surnames: surnames);
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

extension ClanCopyWith on Clan {
  Clan copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    String? createdBy,
    List<Surname>? surnames,
  }) {
    return Clan(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      surnames: surnames ?? this.surnames,
    );
  }
}
