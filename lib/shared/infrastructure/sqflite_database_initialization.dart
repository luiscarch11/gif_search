import 'package:gif_searcher/shared/domain/string_constants.dart';
import 'package:sqflite/sqflite.dart';

class SQFLiteDatabaseInitialization {
  static const String databaseName = '${StringConstants.localDatabaseName}.db';
  static Future<Database> initialize() async {
    final db = await openDatabase(
      databaseName,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE IF NOT EXISTS favorite_gifs ('
            'id TEXT PRIMARY KEY,'
            'title TEXT,'
            'is_favorite INTEGER'
            ')');
      },
    );
    return db;
  }
}
