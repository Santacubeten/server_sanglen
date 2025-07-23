import 'dart:math';

import 'package:bcrypt/bcrypt.dart';
import '../handler/jwt.generator.dart';
import '../database/db_connection.dart';
import '../models/modes.dart';
import '../utils/validation_helper.dart';
import '../handler/mailer.dart';
import '../utils/randon_password.generator.dart';

class UserRepository {
  final DBConnection _connection;

  UserRepository(this._connection);

  //create table if not exists
  Future<void> createTable() async {
    print('Creating users table if not exists');
    final db = _connection.pool;
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        role VARCHAR(20) NOT NULL,
        password VARCHAR(255) NOT NULL,
        status INT DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        created_by VARCHAR(50),
        jwt_token VARCHAR(255)
      )
    ''');
  }

  // get all users
  Future<List<User>> getAllUsers() async {
    final db = _connection.pool;
    final result = await db.execute('SELECT * FROM users');
    return result.rows.map((row) => User.fromJson(row.assoc())).toList();
  }

  //create user
  Future<void> createUser(User user, String creatorjwt) async {
    final db = _connection.pool;

    final result = await db.execute(
      "SELECT * FROM users WHERE jwt_token = :jwt_token",
      {'jwt_token': creatorjwt},
    );

    final creatorId = result.rows.first.assoc()['username']!;

    final missingKeys = validateRequiredParams(
      model: user,
      params: ['username', 'email', 'role'],
    );

    if (missingKeys.isNotEmpty) {
      throw Exception('Missing required fields: ${missingKeys.join(', ')}');
    }

    //randomly generate a password using Randowm() Santa@1245 this expression

    final autoPwd = generateRandomPassword(length: 6);

    final password = BCrypt.hashpw(autoPwd, BCrypt.gensalt());

    final jwt = generateToken(user.username!);

    final q = await db.execute(
      '''
      INSERT INTO users (username, email, role, password, created_by, jwt_token) 
      VALUES (:username, :email, :role, :password, :created_by, :jwt_token)
      ''',
      {
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'password': password,
        'created_by': creatorId,
        'jwt_token': jwt,
      },
    );

    if (q.affectedRows.toString() == "1") {
      sendMail(user, autoPwd);
    }
  }
}
