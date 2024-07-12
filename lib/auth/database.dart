import 'package:flutter/material.dart';
import 'package:kalkus_unreleased/JsonModels/users.dart';
import 'package:kalkus_unreleased/SQLite/sqlite.dart';

class Database extends StatefulWidget {
  @override
  _DatabaseState createState() => _DatabaseState();
}

class _DatabaseState extends State<Database> {
  late Future<List<Users>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<Users>> _fetchUsers() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.initDB();

    final List<Map<String, dynamic>> usersMap = await db.query('users');
    return usersMap.map((userMap) => Users.fromMap(userMap)).toList();
  }

  Future<void> _deleteUser(Users user) async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.initDB();
    await db.delete(
      'users',
      where: 'usrId = ?',
      whereArgs: [user.usrId],
    );

    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: FutureBuilder<List<Users>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text('ID: ${user.usrId} : ${user.usrName}'),
                  subtitle: Text('Password: ${user.usrPassword}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteUser(user);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
