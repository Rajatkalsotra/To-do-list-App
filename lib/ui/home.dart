import 'package:flutter/material.dart';
import 'package:todo_list/ui/todoscreen.dart';
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: new AppBar(
      //   title: new Text("Todo list"),
      //   centerTitle: true,
      //   backgroundColor: Colors.black,
      // ),
      body:new todoscreen(),
      // floatingActionButton: new FloatingActionButton(
      //   child: new Icon(Icons.add),
      //   onPressed: () {},),     
    );
  }
}