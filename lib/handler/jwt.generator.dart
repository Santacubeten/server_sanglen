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

///token validator check is valid or not expires or not
/// Returns a tuple of (isValid, payload) where isValid is a boolean indicating
Future<(bool, Map<String, dynamic>?)> isTokenValid(String token) async {
  try {
    // Decode the JWT token
    final jwt = JWT.verify(token, SecretKey("santa"));
    final payload = jwt.payload as Map<String, dynamic>?;

    // Check expiration
    final exp = payload?['exp'];
    if (exp is int) {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (exp < now) {
        // Token is expired
        return (false, null);
      }
    }

    // Return true and the payload if the token is valid and not expired
    return (true, payload);
  } catch (e) {
    // If verification fails, return false and null
    return (false, null);
  }
}
