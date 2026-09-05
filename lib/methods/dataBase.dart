import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class dbInstance {
  static final dbInstance instance = dbInstance._init();
  static Database? _database;

  dbInstance._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sleepData.db');
    return _database!;
  }

  Future<Database> _initDB(String filename)  async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database dB, int version) async {
    await dB.execute(
      '''
      CREATE TABLE IF NOT EXISTS recordings (
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT NOT NULL, 
      date DATETIME NOT NULL, 
      duration INTEGER, 
      filePath TEXT
      );
      '''
    );
  }

  Future _onUpgrade(Database bd, int oldVersion, int newVersion) async {

  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}