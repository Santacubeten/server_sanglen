import '../database/db_connection.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import '../config/utils/response_helper.dart';

class AuthRoutes {
  final DBConnection _connection;
  AuthRoutes(this._connection);
  Router get router {
    final router = Router();

    // Define your authentication routes here
    router.post('/login', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final username = data['username'];
      final password = data['password'];

      final result = await _connection.pool.execute(
          'SELECT * FROM users WHERE username = :username',
          {'username': username});
      if (result.rows.isEmpty) {
        return AppResponse.notFound(
          message: 'User not found with username: $username',
        );
      }

      final user = result.rows.first;
      final raw = user.assoc();

      if (int.tryParse(raw["status"]!) == 0) {
        return AppResponse.error(
          message: 'User is not active',
        );
      }

      var verify = BCrypt.checkpw(password, raw["password"]!);

      if (verify == false) {
        return AppResponse.error(
          message: 'Invalid password',
        );
      }

      return AppResponse.success(
        message: 'Login successful',
        data: {
          'id': raw['id'],
          'username': raw['username'],
          'email': raw['email'],
          'status': raw['status'],
          'role': raw['role'],
          'jwt': raw['jwt_token'],
        },
      );
    });

    router.post('/register', (Request request) async {
      final body = await request.readAsString();
      // Handle registration logic here
      return Response.ok('Registration successful');
    });

    return router;
  }
}
