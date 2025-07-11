
import '../models/todo.dart';
import './db_connection.dart';

class TodoTable {
  final DBConnection _connection;

  TodoTable(this._connection);

  Future<void> createTable() async {
    final conn =  _connection.pool;
    await conn.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        is_completed BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  Future<void> createTodo(Todo todo) async {
    final conn =  _connection.pool;
    await conn.execute(
      'INSERT INTO todos (title, description) VALUES (:title, :description)',
      {'title': todo.title, 'description': todo.description},
    );
  }

  Future<List<Todo>> getAllTodos() async {
    final conn =  _connection.pool;
    final result = await conn.execute('SELECT * FROM todos');
    return result.rows.map((row) => Todo.fromJson(row.assoc())).toList();
  }

  Future<Todo?> getTodoById(int id) async {
    final conn =  _connection.pool;
    final result = await conn.execute('SELECT * FROM todos WHERE id = :id', {'id': id});
    if (result.rows.isNotEmpty) {
      return Todo.fromJson(result.rows.first.assoc());
    }
    return null;
  }

  Future<void> updateTodo(Todo todo) async {
    final conn =  _connection.pool;
    await conn.execute(
      'UPDATE todos SET title = :title, description = :description, is_completed = :is_completed WHERE id = :id',
      {'id': todo.id, 'title': todo.title, 'description': todo.description, 'is_completed': todo.isCompleted},
    );
  }

  Future<void> deleteTodo(int id) async {
    final conn =  _connection.pool;
    await conn.execute('DELETE FROM todos WHERE id = :id', {'id': id});
  }
}
