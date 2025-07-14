
// import 'db_connection.dart';

// class ClanTable {
//   final DBConnection _connection;

//   ClanTable(this._connection);

//   Future<void> createTable() async {
//     final conn = _connection.pool;
//     await conn.execute(''''
//       CREATE TABLE IF NOT EXISTS clans (
//         id INT AUTO_INCREMENT PRIMARY KEY,
//         name VARCHAR(255) NOT NULL,
//         created_by VARCHAR(255) NOT NULL
//       )
//     ''');
//   }
// }
