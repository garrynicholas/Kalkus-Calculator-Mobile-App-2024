import 'package:flutter/material.dart';
import 'package:kalkus_unreleased/JsonModels/users.dart';
import 'package:kalkus_unreleased/SQLite/sqlite.dart';
import 'package:kalkus_unreleased/auth/login.dart';

class EditUserScreen extends StatefulWidget {
  final String username;
  final String password;

  const EditUserScreen(
      {Key? key, required this.username, required this.password})
      : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late String newUsername;
  late String newPassword;
  late int usrId;
  bool dataUpdated = false;
  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    fetchUserId();
  }

  Future<void> fetchUserId() async {
    final db = DatabaseHelper();
    try {
      Users user = await db.getUserByUsernameAndPassword(
          widget.username, widget.password);
      setState(() {
        usrId = user.usrId!;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> updateUser() async {
    final db = DatabaseHelper();
    try {
      Users updatedUser =
          Users(usrId: usrId, usrName: newUsername, usrPassword: newPassword);
      await db.updateUser(updatedUser);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User updated successfully')));
      setState(() {
        dataUpdated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update user')));
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (dataUpdated) {
          _showSuccessDialog();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  child: Image.asset(
                    "assets/images/edit.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        const Color.fromARGB(255, 0, 82, 223).withOpacity(.2),
                  ),
                  child: TextFormField(
                    initialValue: widget.username,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      newUsername = value;
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      border: InputBorder.none,
                      hintText: "Username",
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        const Color.fromARGB(255, 0, 82, 223).withOpacity(.2),
                  ),
                  child: TextFormField(
                    initialValue: widget.password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      newPassword = value;
                    },
                    obscureText: !isVisible,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      border: InputBorder.none,
                      hintText: "Password",
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(!isVisible
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 68, 0, 255),
                    ),
                    child: TextButton(
                      onPressed: () {
                        updateUser().then((_) {
                          if (dataUpdated) {
                            _showSuccessDialog();
                          }
                        });
                      },
                      child: Text(
                        "UPDATE",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Color.fromARGB(255, 68, 0, 255),
                size: 36,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Text(
                  "Access Denied",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 68, 0, 255),
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            "Your Username and Password was succesfully updated. You must Login back to confirm the update. Are you willing to be redirected to the Login page?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 68, 0, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      child: Text(
                        'Took Me There',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
