import 'package:kalkus_unreleased/JsonModels/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "kalkus.db";

  String users =
      "CREATE table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
    });
  }

  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "SELECT * FROM users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");

    return result.isNotEmpty;
  }

  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }

  Future<Users> getUserByUsername(String username) async {
    final Database db = await initDB();

    List<Map<String, dynamic>> maps =
        await db.query('users', where: 'usrName = ?', whereArgs: [username]);

    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      throw Exception("User not found");
    }
  }

  Future<Users> getUserByUsernameAndPassword(
      String username, String password) async {
    final Database db = await initDB();
    List<Map<String, dynamic>> maps = await db.query('users',
        where: 'usrName = ? AND usrPassword = ?',
        whereArgs: [username, password]);
    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      throw Exception("User not found");
    }
  }

  Future<int> updateUser(Users user) async {
    final Database db = await initDB();
    return db.update('users', user.toMap(),
        where: 'usrId = ?', whereArgs: [user.usrId]);
  }
}
