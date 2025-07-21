import 'package:bcrypt/bcrypt.dart';

import '../database/db_connection.dart';
import '../models/modes.dart';
import '../config/utils/validation_helper.dart';

class UserRepository {
  final DBConnection _connection;

  UserRepository(this._connection);

  //create table if not exists
  Future<void> createTable() async {
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
  Future<void> createUser(User user) async {
    final db = _connection.pool;

    final missingKeys = validateRequiredParams(
      model: user,
      params: ['username', 'email', 'role', 'password'],
    );

    if (missingKeys.isNotEmpty) {
      throw Exception('Missing required fields: ${missingKeys.join(', ')}');
    }

    final password = BCrypt.hashpw(user.password!, BCrypt.gensalt());

    await db.execute(
      '''
      INSERT INTO users (username, email, role, password, created_by, jwt_token) 
      VALUES (:username, :email, :role, :password, :created_by, :jwt_token)
      ''',
      {
        'username': user.username,
        'email': user.email,
        'role': user.role,
        'password': password,
        'created_by': user.createdBy,
        'jwt_token': user.jwtToken,
      },
    );
  }
}
