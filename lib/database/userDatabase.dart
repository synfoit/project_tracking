import 'package:path/path.dart';
import 'package:project_tracking/model/token.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  late String path;
  static const _databaseName = "mydb.db";
  static const _databaseVersion = 1;
  static const tableName = 'users';

  UserDatabase._privateConstructor();

  static final UserDatabase instance = UserDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE users ( token TEXT, ssonumber Text)",
    );
  }

  Future getFileData() async {
    return getDatabasesPath().then((s) {
      return path = s;
    });
  }

  Future insertUser(String token, String ssonumber) async {
    Database db = await instance.database;
    print(token);
    var map = <String, dynamic>{'token': token, 'ssonumber': ssonumber};
    var result = await db.insert("users", map,
        conflictAlgorithm: ConflictAlgorithm.ignore);
    print("result" + result.toString());
    return result;
  }

  Future<Token> getEmployee() async {
    Database db = await instance.database;
    var res = await db.rawQuery("select * from users");
    List<Token> token = [];
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        token.add(Token.fromMap(res[i]));
      }
    }
    return token[0];
  }

  Future getUser() async {
    Database db = await instance.database;
    var logins = await db.rawQuery("select * from users");

    if (logins.isEmpty) {
      return 0;
    }

    return logins.length;
  }

  Future getUserData() async {
    Database db = await instance.database;
    var res = await db.rawQuery("select * from users");
    List<Token> employees = [];
    if (res.isNotEmpty) {
      for (int i = 0; i < res.length; i++) {
        employees.add(Token.fromMap(res[i]));
      }
    }
    return employees[0];
  }

  Future deleteUser(String ssonumber) async {
    Database db = await instance.database;
    var logins =
        db.delete(tableName, where: "ssonumber = ?", whereArgs: [ssonumber]);
    return logins;
  }
}
