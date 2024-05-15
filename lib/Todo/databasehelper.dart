import 'package:mapfeature_project/Todo/event_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
// import 'package:todo3/event_model.dart';

class DBHelper {
  DBHelper._(); // a named private constructor
  static final DBHelper db = DBHelper._();

  static Database? _database;
  static Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return await openDatabase(path.join(dbPath, "events_database.db"),
        version: 1, onOpen: (_) {}, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Events (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, start_time TEXT, end_time TEXT, date TEXT)');
    });
  }

  Future<int> insertEvent(Map<String, dynamic> eventMap) async {
    // return the event id created by the databse
    try {
      return await _database!.insert("Events", eventMap,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    List<EventModel> returnedEvents = [];
    List<Map<String, Object?>> queryResult =
        await _database!.rawQuery('SELECT * FROM Events');

    for (var event in queryResult) {
      returnedEvents.add(EventModel.fromMap(event));
    }
    return returnedEvents;
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _database!.rawQuery('Delete FROM Events WHERE id = $id');
    } catch (error) {
      rethrow;
    }
  }
}
