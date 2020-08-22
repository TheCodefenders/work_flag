import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_flag/blocs/checkpoint.dart';

Future<Database> createDatabase() {
  return getDatabasesPath().then((dbPath) {
    final String path = join(dbPath, "checkpoint.db");
    return openDatabase(path, onCreate: (db, version) {
      db.execute("CREATE TABLE checkpoint("
          "id INTEGER PRIMARY KEY, "
          "date TEXT, "
          "start TEXT, "
          "stop TEXT, "
          "address TEXT)");
    }, version: 1);
  });
}

Future<int> save(CheckpointBloc checkpoint) {
  return createDatabase().then((db) {
    final Map<String, dynamic> checkpointMap = Map();
    checkpointMap["date"] = checkpoint.date.toString();
    checkpointMap["start"] = checkpoint.start.toString();
    checkpointMap["stop"] = checkpoint.stop.toString();
    checkpointMap["address"] = checkpoint.address;

    return db.insert("checkpoint", checkpointMap);
  });
}

Future<List<CheckpointBloc>> findAll() {
  return createDatabase().then((db) {
    return db.query("checkpoint").then((maps) {
      final List<CheckpointBloc> checkpoints = new List();
      for (Map<String, dynamic> map in maps) {
        final CheckpointBloc checkpoint = CheckpointBloc(
            id: map["id"],
            date: DateTime.tryParse(map["date"]),
            start: DateTime.tryParse(map["start"]),
            stop: DateTime.tryParse(map["stop"]),
            address: map["address"]);

        checkpoints.add(checkpoint);
      }
      return checkpoints;
    });
  });
}

Future<CheckpointBloc> findLast() {
  return createDatabase().then((db) {
    return db.query("checkpoint", orderBy: "id").then((map) {
      return CheckpointBloc(
          id: map.last["id"],
          date: DateTime.tryParse(map.last["date"]),
          start: DateTime.tryParse(map.last["start"]),
          stop: DateTime.tryParse(map.last["stop"]),
          address: map.last["address"]);
    });
  });
}

Future updateCheckpoint(CheckpointBloc checkpoint) {
  createDatabase().then((db) {
    db.update("checkpoint", checkpoint.toMap(),
        where: "id = ?", whereArgs: [checkpoint.id]);
  });
}
