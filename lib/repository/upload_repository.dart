import 'package:server/database/db_connection.dart';

class UploadRepositoy {
  final DBConnection _connection;
  UploadRepositoy(this._connection);
  Future<void> createTable() async {
    print('Creating upload table if not exists');
    final db = _connection.pool;

    final query = '''
      CREATE TABLE IF NOT EXISTS upload (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name TEXT NOT NULL,
        path TEXT NOT NULL
      );
    ''';
    await db.execute(query);
  }

  Future<void> upload(String name, String path) async {
    final db = _connection.pool;

    await db.execute(
      '''
      INSERT INTO upload (name, path)
      VALUES (:name, :path)
      ''',
      {'name': name, 'path': path},
    );
  }

  Future<List<Map<String, dynamic>>> getAllUploaded() async {
    final db = _connection.pool;
    final results = await db.execute('SELECT * FROM upload');
    return results.rows
        .map((row) => Map<String, dynamic>.from(row.assoc()))
        .toList();
  }

Future<(String?,String)> delete(String id) async {
  final db = _connection.pool;

  try {
    // Step 1: Check if the record exists and get the file path
    final selectResult = await db.execute(
      '''
      SELECT path FROM upload WHERE id = :id
      ''',
      {'id': id},
    );

    if (selectResult.rows.isEmpty) {
      // Record not found
      return (null,"No record found");
    }

    final filePath = selectResult.rows.first.assoc()['path'];

    // Step 2: Delete the record
    final deleteResult = await db.execute(
      '''
      DELETE FROM upload WHERE id = :id
      ''',
      {'id': id},
    );

    // Step 3: Optionally check if deletion was successful
    if (deleteResult.affectedRows.toString() == "0") {
      // Nothing was deleted, though this is unlikely
      return (null,"Failed to delete");
    }

    // Step 4: Return the file path
    return (filePath,"Deleted successfully!");
  } catch (e) {
    print('Error deleting upload record: $e');
    return (null, e.toString());
  }
}

}
