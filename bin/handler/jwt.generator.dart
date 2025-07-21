import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Generates a JWT token for the given username.
/// The token expires in 7 days.
String generateToken(String username) {
  // Create JWT payload with username and expiration time (in seconds)
  var jwtPayload = JWT(
    {
      'username': username,
      'exp':
          DateTime.now().add(Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    },
  );
  // Sign the JWT with a secret key and return the token
  var token = jwtPayload.sign(SecretKey("santa"));
  return token;
}