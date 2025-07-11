import 'package:mysql_client/mysql_client.dart';
import './todo_table.dart';

class DBConnection {
  DBConnection._();

  static final DBConnection _instance = DBConnection._();
  static DBConnection get instance => _instance;

  late final MySQLConnectionPool pool;
  late final TodoTable todoTable;

  Future<void> connect() async {
    print('Connecting to database...');
    pool = MySQLConnectionPool(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: 'root',
      databaseName: 'sanglen',
      maxConnections: 10,
    );
    todoTable = TodoTable(this);
    await todoTable.createTable();
    print('Database connected.');
  }

  Future<void> close() async {
    await pool.close();
  }
}
