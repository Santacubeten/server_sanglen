import 'dart:math';

String generateRandomPassword({int length = 12}) {
  const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789!@#';
  final Random rnd = Random.secure();
  return List.generate(length, (index) => chars[rnd.nextInt(chars.length)])
      .join();
}
