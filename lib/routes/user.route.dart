import '../database/db_connection.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';
import '../models/user.model.dart';
import 'dart:convert';
import '../utils/response_helper.dart';

class UserRoute {
  final DBConnection _connection;

  UserRoute(this._connection);
  Router get router {
    final router = Router();

    // Define user-related routes here
    router.get('/', (Request request) async {
      final users = await _connection.userTable.getAllUsers();
      return AppResponse.success(
        data: users.map((user) {
          final m = user.toJson();
          //remove password from the response
          m.remove('password');
          m.remove('jwt_token');
          return m;
        }).toList(),
      );
    });

    //create user
    router.post('/', (Request request) async {
      // get the bear token from the request header
      final authHeader = request.headers['Authorization'];
      final token = authHeader!.substring(7); // Remove 'Bearer ' prefix

      final body = await request.readAsString();
      final user = User.fromJson(jsonDecode(body));
      await _connection.userTable.createUser(user, token);
      return AppResponse.success(message: 'User created successfully', data: {
        'username': user.username,
        'email': user.email,
      });
    });

    // //reset password
    // router.post('/reset_password/', (Request request) async {
    //   final body = await request.readAsString();
    //   final data = jsonDecode(body);
    //   final username = data['username'];
    //   final newPassword = data['new_password'];

    //   if (username == null || newPassword == null) {
    //     return AppResponse.error(
    //       message: 'Username and new password are required',
    //     );
    //   }

    //   await _connection.userTable.resetPassword(username, newPassword);
    //   return AppResponse.success(
    //     message: 'Password reset successfully',
    //   );
    // });

    // //active user or deactive user by id patch
    // router.patch('/<id>', (Request request, String id) async {
    //   final body = await request.readAsString();
    //   final data = jsonDecode(body);
    //   final status = data['status'];
    //   // if the status is 1 active, if 0 deactive give msg
    //   if (status == null || (status != 0 && status != 1)) {
    //     return AppResponse.error(
    //       message: 'Status must be either 0 (inactive) or 1 (active)',
    //     );
    //   }
    //   await _connection.userTable.updateUserStatus(int.parse(id), status);
    //   return AppResponse.success(
    //     message:
    //         'User successfully ${status == 1 ? 'activated' : 'deactivated'}',
    //   );
    // });

    return router;
  }
}
