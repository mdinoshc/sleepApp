import 'package:sleepyer/methods/dataBase.dart';

import '../models/recordListModel.dart';

class crudRepo {
  final dbHelper = dbInstance.instance;

  // The 'Future' keyword is used because database operations are asynchronous.
  // It acts as a wrapper for a value (in this case, an 'int') that isn't
  // available yet but will be returned once the database finishes the task.
  // The 'async' keyword allows the use of 'await' inside the function,
  // ensuring the app doesn't freeze while waiting for the result.
  Future<int> insertRecording(RecordList recording) async {
    final db = await dbHelper.database;
    return await db.insert('recordings', recording.toJson());
  }

  Future<List<RecordList>> getAllRecordings() async {
    final db = await dbHelper.database;
    final result =  await db.query('recordings',orderBy: 'createdAt DESC');
    return result.map((map) => RecordList.fromJson(map)).toList();
  }

  Future<int> updateRecording(RecordList recordz) async {
    final db = await dbHelper.database;
    return await db.update(
        'recordings',
        recordz.toJson(),where: 'id = ?', whereArgs: [recordz.id]
    );
  }

  Future<int> deleteRecording(int id) async {
    final db = await dbHelper.database;
    return await db.delete('recordings', where: 'id = ?', whereArgs: [id]);
  }
}