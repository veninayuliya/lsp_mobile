// ignore_for_file: depend_on_referenced_packages
import 'package:coba_sertif/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _db;

  static const int Version = 1;

  static const String UserName = 'user_name';
  static const String Nama = 'nama';
  static const String Password = 'pass_word';
  static const String NoTelp = 'no_telp';

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'test.db');
    var db = await openDatabase(path, version: Version, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int intVersion) async {
    await db.execute("CREATE TABLE user ("
        " $UserName TEXT, "
        " $Nama TEXT,"
        " $Password TEXT, "
        " $NoTelp TEXT, "
        " PRIMARY KEY ($UserName)"
        ")");
  }

  Future<int> saveData(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient!.insert('user', user.toMap());
    return res;
  }

  Future<UserModel?> getLoginUser(String userName, String password) async {
    var dbClient = await db;
    var res = await dbClient!.rawQuery("SELECT * FROM user WHERE "
        "$UserName = '$userName' AND "
        "$Password = '$password'");

    if (res.length > 0) {
      return UserModel.fromMap(res.first);
    }

    return null;
  }

  Future<int> updateUser(UserModel user) async {
    var dbClient = await db;
    var res = await dbClient!.update('user', user.toMap(),
        where: '$UserName = ?', whereArgs: [user.user_name]);
    return res;
  }

  Future<int> deleteUser(String user_name) async {
    var dbClient = await db;
    var res = await dbClient!
        .delete('user', where: '$UserName = ?', whereArgs: [user_name]);
    return res;
  }
}
