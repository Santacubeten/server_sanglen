import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../data/todo.dart';
import '../database/db_connection.dart';

class TodoRoutes {
  final DBConnection _connection;

  TodoRoutes(this._connection);

  Router get router {
    final router = Router();

    router.post('/', (Request request) async {
    // {
    // "title": "My First Todo",
    // "description": "This is a test todo.",
    // "isCompleted": false
    // }
      final body = await request.readAsString();
      final todo = Todo.fromJson(jsonDecode(body));
      await _connection.todoTable.createTodo(todo);
      return Response.ok('Todo created');
    });

    router.get('/', (Request request) async {
      final todos = await _connection.todoTable.getAllTodos();
      return Response.ok(jsonEncode(todos.map((e) => e.toJson()).toList()));
    });

    router.get('/<id|\d+>', (Request request, String id) async {
      final todo = await _connection.todoTable.getTodoById(int.parse(id));
      if (todo != null) {
        return Response.ok(jsonEncode(todo.toJson()));
      }
      return Response.notFound('Todo not found');
    });

    router.put('/<id|\d+>', (Request request, String id) async {
      final body = await request.readAsString();
      final todo = Todo.fromJson(jsonDecode(body));
      await _connection.todoTable.updateTodo(todo.copyWith(id: int.parse(id)));
      return Response.ok('Todo updated');
    });

    router.delete('/<id|\d+>', (Request request, String id) async {
      await _connection.todoTable.deleteTodo(int.parse(id));
      return Response.ok('Todo deleted');
    });

    return router;
  }
}

extension on Todo {
  Todo copyWith({int? id}) {
    return Todo(
      id: id ?? this.id,
      title: title,
      description: description,
      isCompleted: isCompleted,
    );
  }
}
