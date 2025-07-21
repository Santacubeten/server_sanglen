import '../database/db_connection.dart';
Future<(bool, Map<String, dynamic>?)> isTokenValid(
    String token, ) async {
  final DBConnection connection = DBConnection.instance;
  var result = await connection.pool.execute(
      "SELECT * FROM users WHERE jwt_token = :jwt_token", {"jwt_token": token});

  if (result.rows.isEmpty) {
    return (false, null);
  } else {
    var raw = result.rows.first.assoc() as Map<String, dynamic>;
    Map<String, dynamic> filteredMap = {
      'id': raw['id'],
      'name': raw['username'],
      'email': raw['email'],
      'role': raw['role'],
    };
    return (true, filteredMap);
  }
}
