import 'package:flutter/material.dart';

class CalculatorHistoryPage extends StatefulWidget {
  final List<String> history;
  final Function clearLimitedHistory;

  CalculatorHistoryPage(
      {required this.history, required this.clearLimitedHistory});

  @override
  _CalculatorHistoryPageState createState() => _CalculatorHistoryPageState();
}

class _CalculatorHistoryPageState extends State<CalculatorHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                widget.history.clear();
                widget.clearLimitedHistory();
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              widget.history[index],
              style: TextStyle(fontSize: 16),
            ),
          );
        },
      ),
    );
  }
}
