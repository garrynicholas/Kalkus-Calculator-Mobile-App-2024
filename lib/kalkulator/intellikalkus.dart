import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  ScrollController _scrollController = ScrollController();

  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );
      _messages.insert(
        0,
        ChatMessage(
          text: 'Typing the answer...',
          isUser: false,
        ),
      );
    });

    Future.delayed(Duration(milliseconds: 1500), () {
      _scrollController.animateTo(
        0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );

      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          _messages.removeAt(0); // Remove the "Typing" indicator
          _messages.insert(
            0,
            ChatMessage(
              text: getResponse(text),
              isUser: false,
            ),
          );
        });
      });
    });
  }

  String getResponse(String message) {
    if (message.toLowerCase().contains('apa itu kalkulus?')) {
      return 'Menurut Kamus Besar Bahasa Indonesia (2015), kalkulus adalah bagian matematika yang melibatkan pengertian dan penggunaan deferensial dan integral fungsi serta konsep yang berkaitan (KBBI, 2020)';
    } else if (message.toLowerCase().contains('apa itu aljabar?')) {
      return 'Aljabar adalah salah satu bagian dari ilmu matematika terkait ilmu bilangan,geometri dan analisis penyelesaiannya dengan menggunakan atau mengandung huruf-huruf atau yang biasa kita sebut sebagai variabel.';
    } else {
      return "Maaf, saya tidak memahami pertanyaan Anda.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IntelliKalkus'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) =>
                  _messages[index],
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Colors.black),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _handleSubmitted(_controller.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(isUser ? 'User' : 'ITK')),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isUser ? 'Anda' : 'IntelliKalkus',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
