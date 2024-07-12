import 'package:flutter/material.dart';
import 'package:kalkus_unreleased/accounts/profilepage.dart';
import 'package:kalkus_unreleased/kalkulator/data_kalkus.dart';
import 'package:kalkus_unreleased/kalkulator/history.dart';
import 'package:kalkus_unreleased/kalkulator/length_kalkus.dart';
import 'package:kalkus_unreleased/kalkulator/mass_calculator.dart';
import 'package:kalkus_unreleased/kalkulator/time_kalkus.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

class KalkusUser extends StatefulWidget {
  final String username;

  const KalkusUser({Key? key, required this.username}) : super(key: key);

  @override
  State<KalkusUser> createState() => _KalkusState();
}

class _KalkusState extends State<KalkusUser> {
  List<String> limitedHistory = [];
  String _expression = '';
  String _result = '';
  NumberFormat _numberFormat = NumberFormat('#,##0.###');
  Parser parser = Parser();
  ContextModel cm = ContextModel();
  List<String> history = [];

  void clearLimitedHistory() {
    setState(() {
      limitedHistory.clear();
    });
  }

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
          limitedHistory.add('$_expression = $_result');

          if (limitedHistory.length > 6) {
            limitedHistory.removeAt(0);
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
              fixedSize: Size(80.0, 80.0),
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
        backgroundColor: Colors.white,
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
                    padding: const EdgeInsets.only(left: 16.0, bottom: 12),
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
                        Icons.calculate,
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
                    leading: Icon(Icons.numbers),
                    title: Text('Length Calculator'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LengthCalculator())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('Time Calculator'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TimeCalculator())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.data_usage),
                    title: Text('Data Calculator'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => DataCalculator())));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.fitness_center),
                    title: Text('Mass Calculator'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MassCalculator())));
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.history),
                    title: Text('View History'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalculatorHistoryPage(
                            history: history,
                            clearLimitedHistory: clearLimitedHistory,
                          ),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Accounts'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) =>
                              ProfilePage(username: widget.username)),
                        ),
                      );
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
                    children: limitedHistory.map((item) => Text(item)).toList(),
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
                  _buildButton('C',
                      color: const Color.fromARGB(255, 48, 48, 48)),
                  _buildButton('⌫',
                      color: const Color.fromARGB(255, 48, 48, 48)),
                  _buildButton('%',
                      color: const Color.fromARGB(255, 48, 48, 48)),
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
