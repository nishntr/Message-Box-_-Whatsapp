import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class Msg {
  int _id;
  int _number;
  String _msg;
  String _name;

  Msg(this._name, this._number, this._msg);
  int get id => _id;
  int get number => _number;
  String get msg => _msg;
  String get name => _name;

  set setId(int id) {
    _id = id;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': _id,
      'number': _number,
      'msg': _msg,
      'name': _name
    };
    return map;
  }

  Msg.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._number = map['number'];
    this._msg = map['msg'];
    this._name = map['name'];
  }
}

class MsgProvider {
  final String table = 'Msg';
  final String columnId = 'id';
  final String number = 'number';
  final String msg = 'msg';
  final String name = 'name';

  static Database _db;

  static MsgProvider _instance = new MsgProvider.internal();
  factory MsgProvider() => _instance;
  MsgProvider.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDB();
    return _db;
  }

  initDB() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'data.db';
    var tempDB = openDatabase(path, version: 1, onCreate: _onCreate);
    return tempDB;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table($columnId integer primary key,$name text, $number integer, $msg text)");
    print('database createdd....*******000');
  }
  // Future open() async {
  //   Directory dir = await getApplicationDocumentsDirectory();
  //   String path = dir.path + 'data.db';
  //   _db = await openDatabase(path, onCreate: (Database db, int version) async {
  //     await db.execute('''create table $table(
  //        $columnId integer primary key,
  //        $number integer not null,
  //        $msg text not null,
  //      )''');
  //   });
  // }

  Future<int> insert(Msg msg) async {
    var dbClient = await db;
    int i = await dbClient.insert(table, msg.toMap());
    print(i);
    return i;
  }

  Future<Msg> getMsg(int id) async {
    var dbClient = await db;
    List<Map> map =
        await dbClient.query(table, where: '$columnId=?', whereArgs: [id]);
    return Msg.fromMap(map.first);
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    var dbClient = await db;
    List res = await dbClient.query(table);
    return res;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    int i = await dbClient.delete(table, where: '$columnId=?', whereArgs: [id]);
    return i;
  }

  Future<int> update(Msg msg) async {
    var dbClient = await db;
    return await dbClient.update(table, msg.toMap(),
        where: '$columnId=${msg.id}');
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
