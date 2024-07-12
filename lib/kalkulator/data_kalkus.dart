import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DataCalculator(),
  ));
}

class DataCalculator extends StatefulWidget {
  @override
  _DataCalculatorState createState() => _DataCalculatorState();
}

class _DataCalculatorState extends State<DataCalculator> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  List<String> units = [
    'Byte',
    'Kilobyte',
    'Megabyte',
    'Gigabyte',
    'Terabyte',
  ];

  String _selectedUnit1 = 'Byte';
  String _selectedUnit2 = 'Byte';

  Map<String, double> conversionFactors = {
    'Byte': 1,
    'Kilobyte': 1024,
    'Megabyte': 1024 * 1024,
    'Gigabyte': 1024 * 1024 * 1024,
    'Terabyte': 1024 * 1024 * 1024 * 1024,
  };

  @override
  void initState() {
    super.initState();
    _controller1.addListener(_calculateResult);
  }

  @override
  void dispose() {
    _controller1.removeListener(_calculateResult);
    super.dispose();
  }

  void _calculateResult() {
    if (_controller1.text.isEmpty) {
      _controller2.text = '';
      return;
    }

    double inputValue = double.tryParse(_controller1.text) ?? 0;

    double result = _convert(inputValue, _selectedUnit1, _selectedUnit2);

    _controller2.text = result.toStringAsFixed(6);
  }

  double _convert(double value, String fromUnit, String toUnit) {
    double valueInByte = value * conversionFactors[fromUnit]!;
    double result = valueInByte / conversionFactors[toUnit]!;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Calculator',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                _buildTextField(_controller1, _selectedUnit1),
                SizedBox(height: 20.0),
                _buildTextField(_controller2, _selectedUnit2),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDropdownButton(_selectedUnit1, (String? value) {
                      setState(() {
                        _selectedUnit1 = value!;
                      });
                      _calculateResult();
                    }),
                    _buildDropdownButton(_selectedUnit2, (String? value) {
                      setState(() {
                        _selectedUnit2 = value!;
                      });
                      _calculateResult();
                    }),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 188,
                      child: _buildButton('⌫'),
                    ),
                    Container(
                      width: 188,
                      child: _buildButton('Clear'),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('0'),
                    _buildButton('000'),
                    _buildButton('.'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String unit) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: (_) {
          _calculateResult();
        },
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Data ($unit)',
          filled: true,
          fillColor: Color.fromARGB(255, 235, 235, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.black),
          suffixStyle: TextStyle(color: Colors.black),
          counterStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          errorStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(
    String selectedValue,
    ValueChanged<String?>? onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Color.fromARGB(255, 235, 235, 255),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          icon: Icon(Icons.arrow_drop_down, color: Colors.black),
          items: units.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildButton(
    String text, {
    Color textColor = Colors.white,
    Color buttonColor = const Color.fromARGB(255, 68, 0, 255),
  }) {
    if (text == 'Clear' || text == '⌫') {
      buttonColor = Color.fromARGB(255, 48, 48, 48);
    }
    return Container(
      width: 125.0,
      height: 100.0,
      child: MaterialButton(
        onPressed: () {
          if (text == 'Clear') {
            _controller1.clear();
            _controller2.clear();
          } else if (text == '⌫') {
            if (_controller1.text.isNotEmpty) {
              _controller1.text =
                  _controller1.text.substring(0, _controller1.text.length - 1);
              _calculateResult();
            }
          } else {
            if (_controller1.text.isEmpty) {
              _controller1.text = text;
            } else {
              _controller1.text += text;
            }
          }
        },
        color: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.0),
          side: BorderSide(color: Colors.grey),
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20.0),
        ),
      ),
    );
  }
}
