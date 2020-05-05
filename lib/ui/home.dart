import 'package:flutter/material.dart';
import 'package:flutterapp/ui/todoscreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "To Do"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: ToDoScreen(

      ),
    );
  }
}
