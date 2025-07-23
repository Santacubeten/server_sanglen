import 'package:server/handler/mailer.dart';
import 'package:server/handler/token_validator.dart';
import 'package:server/models/modes.dart';

import '../database/db_connection.dart';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:bcrypt/bcrypt.dart';
import '../utils/response_helper.dart';
import '../utils/randon_password.generator.dart';
import '../utils/validation_helper.dart';
import '../handler/jwt.generator.dart';

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
    //
    // Registration route
    // email username password and role
    router.post('/register', (Request request) async {
      final body = await request.readAsString();
      final authHeader = request.headers['Authorization'];
      final token = authHeader!.substring(7);

      var (isValid, tokenDdata) = await checkToken(token);

      final data = jsonDecode(body);
      if (isValid == false) {
        return AppResponse.error(
          message: 'Invalid token',
          code: 401,
        );
      }
      final missingKeys = validateRequiredParamsFromMap(
        data: data,
        params: ['username', 'email', 'role'],
      );
      if (missingKeys.isNotEmpty) {
        return AppResponse.error(
          message: 'Missing required fields: ${missingKeys.join(', ')}',
        );
      }
      final username = data['username'];
      final email = data['email'];
      final role = data['role'];
      final creatorBy = tokenDdata!['username'];
      final password = generateRandomPassword(length: 6);
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final jwt = generateToken(username);
      final status = 1; // Default status to active

      try {
        final result = await _connection.pool.execute(
          '''
          INSERT INTO users (username, email, role, password, created_by, jwt_token, status) 
          VALUES (:username, :email, :role, :password, :created_by, :jwt_token, :status)
          ''',
          {
            'username': username,
            'email': email,
            'role': role,
            'password': hashedPassword,
            'created_by': creatorBy,
            'jwt_token': jwt,
            'status': status,
          },
        );

        if (result.affectedRows.toString() == "1") {
          sendMail(User(username: username, email: email), password);
          return AppResponse.success(
            message:
                'Registration successful and password has been sent to your email',
            data: {
              'username': username,
              'email': email,
              'role': role,
            },
          );
        } else {
          return AppResponse.error(
            message: 'Registration failed',
          );
        }
      } catch (e) {
        // Check for duplicate entry error (MySQL error code 1062)
        if (e.toString().contains('Duplicate entry')) {
          return AppResponse.error(
            message: 'Duplicate entry: email already exists',
            code: 409,
          );
        }
        return AppResponse.error(
          message: 'Registration failed: $e',
        );
      }
    });

    return router;
  }
}
