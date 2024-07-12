import 'package:flutter/material.dart';
import 'package:kalkus_unreleased/auth/login.dart';
import 'package:kalkus_unreleased/auth/signup.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class Kalkus extends StatefulWidget {
  const Kalkus({Key? key}) : super(key: key);

  @override
  State<Kalkus> createState() => _KalkusState();
}

class _KalkusState extends State<Kalkus> {
  String _expression = '';
  String _result = '';
  NumberFormat _numberFormat = NumberFormat('#,##0.###');
  Parser parser = Parser();

  ContextModel cm = ContextModel();

  List<String> history = [];

  void _onPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          Expression exp = parser.parse(_expression.replaceAll(',', ''));

          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = _numberFormat.format(eval);

          history.add('$_expression = $_result');

          if (history.length > 6) {
            history.removeAt(0);
          }

          _expression = _result;
        } catch (e) {
          _result = 'Error: Invalid Input';
        }
      } else if (buttonText == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '+/-') {
        List<String> values = _expression.split(' ');

        if (values.isNotEmpty && values.last.isNotEmpty) {
          if (values.last[0] != '-') {
            values.last = '-${values.last}';
          } else {
            values.last = values.last.substring(1);
          }

          _expression = values.join(' ');
        }
      } else if (buttonText == '%') {
        try {
          Expression exp = parser.parse(_expression.replaceAll(',', ''));
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          double percentage = eval / 100;
          _result = _numberFormat.format(percentage);
          _expression = _result;
        } catch (e) {
          _result = 'Error: Invalid Input';
        }
      } else if (buttonText == '000') {
        _expression += '000';
      } else {
        if (RegExp(r'[0-9.]').hasMatch(buttonText)) {
          _expression += buttonText;
        } else {
          _expression += ' $buttonText ';
        }
      }

      try {
        List<String> values = _expression.split(' ');

        for (int i = 0; i < values.length; i++) {
          if (RegExp(r'[0-9.]').hasMatch(values[i])) {
            values[i] = _numberFormat
                .format(double.parse(values[i].replaceAll(',', '')));
          }
        }
        _expression = values.join(' ');
      } catch (e) {}
    });
  }

  void _showAccessDeniedDialog() {
    showDialog(
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
            "You must Login or Register to access this feature. Are you willing to be redirected to the Login page?",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Color.fromARGB(255, 68, 0, 255),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Color.fromARGB(255, 68, 0, 255),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
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
                        'Yes',
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

  Widget _buildButton(String buttonText,
      {Color? color, double? fontSize, FontWeight? fontWeight}) {
    if (buttonText == '=') {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ElevatedButton(
            onPressed: () => _onPressed(buttonText),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
              ),
              fixedSize: Size(80.0, 80.0),
              backgroundColor: Colors.white,
              padding: EdgeInsets.all(0.0),
              textStyle: TextStyle(
                fontSize: fontSize ?? 20.0,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: Colors.black,
              ),
            ),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: ElevatedButton(
            onPressed: () => _onPressed(buttonText),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0),
              ),
              fixedSize: Size(80.0, 85.0),
              backgroundColor: color ?? const Color.fromARGB(255, 68, 0, 255),
              padding: EdgeInsets.all(0.0),
              textStyle: TextStyle(
                fontSize: fontSize ?? 20.0,
                fontWeight: fontWeight ?? FontWeight.normal,
                color: Colors.white,
              ),
            ),
            child: Center(
              child: Text(
                buttonText,
                style:
                    TextStyle(fontSize: fontSize ?? 20.0, color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      endDrawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(2), bottomLeft: Radius.circular(2)),
        ),
        elevation: 0,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Image.asset('assets/images/2.png',
                          fit: BoxFit.contain),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      bottom: 12,
                    ),
                    child: Text(
                      'Calculator',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    color: Color.fromARGB(255, 68, 0, 255),
                    child: ListTile(
                      leading: Icon(
                        Icons.numbers,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Calculator',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.calculate),
                    title: Text('Length Calculator'),
                    onTap: () {
                      _showAccessDeniedDialog();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Time Calculator'),
                    onTap: () {
                      _showAccessDeniedDialog();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.data_usage),
                    title: Text('Data Calculator'),
                    onTap: () {
                      _showAccessDeniedDialog();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text('Mass Calculator'),
                    onTap: () {
                      _showAccessDeniedDialog();
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Register'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) => SignUp())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.login),
                    title: Text('Login'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginScreen())));
                    },
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 68, 0, 255),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: ListTile(
                    title: Text(
                      "Kalkus v.1.0.3",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                    subtitle: Text(
                      'Update: Improve UI Pop Up',
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.topRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: history.map((item) => Text(item)).toList(),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _expression,
                    style: TextStyle(fontSize: 30.0),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    _result,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  _buildButton('C', color: Color.fromARGB(255, 48, 48, 48)),
                  _buildButton('⌫', color: Color.fromARGB(255, 48, 48, 48)),
                  _buildButton('%', color: Color.fromARGB(255, 48, 48, 48)),
                  _buildButton('/', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('*', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('-', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('+', color: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _buildButton('0'),
                  _buildButton('000'),
                  _buildButton('+/-', fontSize: 16.0),
                  _buildButton('='),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
