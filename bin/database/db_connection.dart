import 'package:mysql_client/mysql_client.dart';

import './surname_table.dart';

class DBConnection {
  DBConnection._();

  static final DBConnection _instance = DBConnection._();
  static DBConnection get instance => _instance;

  late final MySQLConnectionPool pool;
  late final SurnameTable surnameTable;

  /* ---------- Helpers ---------- */
  Future<int> _rowCount(String tableName) async {
    final res = await pool.execute('SELECT COUNT(*) AS c FROM $tableName');
    return int.parse(res.rows.first.colAt(0).toString());
  }

  /* ---------- Init / Connect ---------- */
  Future<void> initDatabase() async {
    print('Checking / Creating database …');
    final conn = await MySQLConnection.createConnection(
      host: '127.0.0.1',
      port: 3306,
      userName: 'root',
      password: 'root',
    );
    await conn.connect();
    await conn.execute('CREATE DATABASE IF NOT EXISTS sanglen');
    await conn.close();
    print('Database ready.');
  }

  Future<void> connectdb() async {
    try {
      await initDatabase();

      pool = MySQLConnectionPool(
        host: '127.0.0.1',
        port: 3306,
        userName: 'root',
        password: 'root',
        databaseName: 'sanglen',
        maxConnections: 10,
      );

      surnameTable = SurnameTable(this);
      await surnameTable.createTable();
      await seedData();
      
      print('✅ Database connected & seeded.');
    } catch (e) {
      print('❌ Error: $e');
      rethrow;
    }
  }

  /* ---------- Seeding ---------- */
  Future<void> seedData() async {
    /* --- clans --- */
    if (await _rowCount('clans') == 0) {
      const clans = [
        {'id': '1', 'name': 'Mangang', 'created_by': 'admin'},
        {'id': '2', 'name': 'Luwang',  'created_by': 'admin'},
        {'id': '3', 'name': 'Khuman',  'created_by': 'admin'},
        {'id': '4', 'name': 'Angom',   'created_by': 'admin'},
        {'id': '5', 'name': 'Moirang', 'created_by': 'admin'},
        {'id': '6', 'name': 'Kha Nganba', 'created_by': 'admin'},
        {'id': '7', 'name': 'Sarang Leishangthem', 'created_by': 'admin'},
      ];
      for (final c in clans) {
        await pool.execute(
          'INSERT INTO clans (id, name, created_by) VALUES (:id, :name, :created_by)',
          c,
        );
      }
      print('✅ Clans seeded.');
    }

    /* --- surnames --- */
    if (await _rowCount('surnames') == 0) {
      const surnames = [
        /* 1 = Mangang */
        {'name': 'AHEIBAM', 'clan_id': '1'},
        {'name': 'ACHURAM', 'clan_id': '1'},
        {'name': 'AHANTHEM', 'clan_id': '1'},
        {'name': 'AKHENGBAM', 'clan_id': '1'},
        {'name': 'AKHOM', 'clan_id': '1'},
        {'name': 'ATOM', 'clan_id': '1'},
        {'name': 'AYEKPAM', 'clan_id': '1'},
        {'name': 'CHAKAMAYUM', 'clan_id': '1'},
        {'name': 'CHANAMBAM', 'clan_id': '1'},
        {'name': 'CHANINGHANBAM', 'clan_id': '1'},
        {'name': 'CHANNABAM', 'clan_id': '1'},
        {'name': 'CHARAIMAYUM', 'clan_id': '1'},
        {'name': 'CHEROM', 'clan_id': '1'},
        {'name': 'CHINGKHAM', 'clan_id': '1'},
        {'name': 'CHIROM', 'clan_id': '1'},
        {'name': 'CHONGJAMBAM', 'clan_id': '1'},
        {'name': 'CHONGTHAM', 'clan_id': '1'},
        {'name': 'HAKWANTHEM', 'clan_id': '1'},
        {'name': 'HAOKHOM', 'clan_id': '1'},
        {'name': 'HEISNAM', 'clan_id': '1'},
        {'name': 'HUIDROM', 'clan_id': '1'},
        {'name': 'IROM', 'clan_id': '1'},
        {'name': 'KEISHAM', 'clan_id': '1'},
        {'name': 'MAIRENBAM', 'clan_id': '1'},
        {'name': 'MUTUM', 'clan_id': '1'},
        {'name': 'SINGKHAM', 'clan_id': '1'},
        {'name': 'THINGNAM', 'clan_id': '1'},
        {'name': 'YUMNAM', 'clan_id': '1'},

        /* 2 = Luwang */
        {'name': 'ABUJAM', 'clan_id': '2'},
        {'name': 'ACHOIBAM', 'clan_id': '2'},
        {'name': 'ANGAMBAM', 'clan_id': '2'},
        {'name': 'ARAMBAM', 'clan_id': '2'},
        {'name': 'ASANGBAM', 'clan_id': '2'},
        {'name': 'CHINGGAIBAM', 'clan_id': '2'},
        {'name': 'HAORONGBAM', 'clan_id': '2'},
        {'name': 'HEIKHAM', 'clan_id': '2'},
        {'name': 'KAMBONGMAYUM', 'clan_id': '2'},
        {'name': 'LAIRENJAM', 'clan_id': '2'},
        {'name': 'MAISNAM', 'clan_id': '2'},
        {'name': 'NAHAKPAM', 'clan_id': '2'},
        {'name': 'NAOROIBAM', 'clan_id': '2'},
        {'name': 'THANGJAM', 'clan_id': '2'},
        {'name': 'WAHENGBAM', 'clan_id': '2'},
        {'name': 'WAIKHOM', 'clan_id': '2'},
        {'name': 'YANGLEM', 'clan_id': '2'},

        /* 3 = Khuman */
        {'name': 'AHABAM', 'clan_id': '3'},
        {'name': 'CHANDAM', 'clan_id': '3'},
        {'name': 'HAOBAM', 'clan_id': '3'},
        {'name': 'KHUMANTHEM', 'clan_id': '3'},
        {'name': 'KHURAIJAM', 'clan_id': '3'},
        {'name': 'MAIBAM', 'clan_id': '3'},
        {'name': 'MEIPHARAM', 'clan_id': '3'},
        {'name': 'MOIRENGBAM', 'clan_id': '3'},
        {'name': 'SINAM', 'clan_id': '3'},
        {'name': 'SORAM', 'clan_id': '3'},
        {'name': 'TAOBAM', 'clan_id': '3'},
        {'name': 'THOUDAM', 'clan_id': '3'},

        /* 4 = Angom */
        {'name': 'ANGOM', 'clan_id': '4'},
        {'name': 'ACHUBAM', 'clan_id': '4'},
        {'name': 'HEIKRAMBAM', 'clan_id': '4'},
        {'name': 'KAIKOM', 'clan_id': '4'},
        {'name': 'KHACHENBAM', 'clan_id': '4'},
        {'name': 'LONGMAITHEM', 'clan_id': '4'},
        {'name': 'SENJAM', 'clan_id': '4'},
        {'name': 'USHAM', 'clan_id': '4'},
        {'name': 'WANGKHEM', 'clan_id': '4'},

        /* 5 = Moirang */
        {'name': 'ACHOM', 'clan_id': '5'},
        {'name': 'ELANGBAM', 'clan_id': '5'},
        {'name': 'KHAITHENLAKPAM', 'clan_id': '5'},
        {'name': 'LAIPHRAKPAM', 'clan_id': '5'},
        {'name': 'MOIRANGMAYUM', 'clan_id': '5'},
        {'name': 'MOIRANGTHEM', 'clan_id': '5'},
        {'name': 'NGANGCHENGBAM', 'clan_id': '5'},
        {'name': 'THOKCHOM', 'clan_id': '5'},

        /* 6 = Kha Nganba */
        {'name': 'AHEIBAM', 'clan_id': '6'},
        {'name': 'HAOBIJAM', 'clan_id': '6'},
        {'name': 'KHURAIJAM', 'clan_id': '6'},
        {'name': 'KONJENGBAM', 'clan_id': '6'},
        {'name': 'LANGOLJAM', 'clan_id': '6'},
        {'name': 'MANTANGBAM', 'clan_id': '6'},
        {'name': 'NGAKPAM', 'clan_id': '6'},
        {'name': 'WANGBAJAM', 'clan_id': '6'},

        /* 7 = Salang Leisangthem */
        {'name': 'LEISHANGTHEM', 'clan_id': '7'},
        {'name': 'AMOM', 'clan_id': '7'},
        {'name': 'CHANAM', 'clan_id': '7'},
        {'name': 'HEIBAM', 'clan_id': '7'},
        {'name': 'KHORIYEMBAM', 'clan_id': '7'},
        {'name': 'POTSANGBAM', 'clan_id': '7'},
        {'name': 'SARANGTHEM', 'clan_id': '7'},
        {'name': 'TOURANGBAM', 'clan_id': '7'},
      ];

      for (final s in surnames) {
        await pool.execute(
          'INSERT INTO surnames (name, clan_id) VALUES (:name, :clan_id)',
          s,
        );
      }
      print('✅ Surnames seeded.');
    }
  }

  /* ---------- Shutdown ---------- */
  Future<void> close() async => await pool.close();
}