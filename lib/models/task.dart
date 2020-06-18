import 'package:flutter/material.dart';
class Task extends StatelessWidget {
  String _name;
  String _date;
  int _id;

  Task(this._name,this._date);

  Task.map(dynamic obj){
    this._name=obj["username"];
    this._date=obj["date"];
    this._id=obj['id'];
  }

  String get name=>_name;
  String get date=>_date;
  int get id=>_id;

  Map<String,dynamic> toMap(){
    var map=new Map<String,dynamic>();
    map['name']=_name;
    map['date']=_date;
    if(_id!=null)
      map['id']=_id;
    return map;
  }

  Task.fromMap(Map<String,dynamic> map){
    this._name=map['name'];
    this._date=map['date'];
    this._id=map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListTile(
        title: new Text(_name),
        subtitle: new Text("Created on: $_date"),
      ),
      
    );
  }
}