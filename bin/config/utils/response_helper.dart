import 'dart:convert';
import 'package:shelf/shelf.dart';

class AppResponse {
  static const _headers = {'Content-Type': 'application/json'};

  static Response success({dynamic data, String message = 'Success'}) {
    return Response.ok(
      jsonEncode({
        'success': true,
        'message': message,
        if (data != null) 'data': data,
      }),
      headers: _headers,
    );
  }

  static Response error({String message = 'Something went wrong', int code = 400}) {
    return Response(code,
        body: jsonEncode({
          'success': false,
          'message': message,
        }),
        headers: _headers);
  }

  static Response notFound({String message = 'Resource not found'}) {
    return error(message: message, code: 404);
  }
}
