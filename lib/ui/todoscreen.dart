import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/utils/database_helper.dart';
import 'package:todo_list/utils/date.dart';

class todoscreen extends StatefulWidget {
  @override
  _todoscreenState createState() => _todoscreenState();
}

class _todoscreenState extends State<todoscreen> {
  var db = new DatabaseHelper();
  final TextEditingController _newTask = new TextEditingController();
  final List<Task> _taskslist = <Task>[];
  @override
  void initState() {
    super.initState();
    _todolist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(
        title: new Text("Todo list"),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              itemCount: _taskslist.length,
              reverse: false,
              itemBuilder: (BuildContext context, int index) {
                return new Card(
                  //  color: Colors.black87,
                  child: new ListTile(
                    title: _taskslist[index],
                    onLongPress: () => _taskUpdate(_taskslist[index], index),
                    trailing: new Listener(
                      key: new Key(_taskslist[index].name),
                      child: new Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPointerDown: (PointerEvent) =>
                          _deleteTask(_taskslist[index].id, index),
                    ),
                  ),
                );
              },
            ),
          ),
          new Divider()
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Add item',
        backgroundColor: Colors.blue,
        child: new Icon(Icons.add),
        onPressed: _showForm,
      ),
    );
  }

  void _showForm() {
    var alert = new AlertDialog(
      title: new Text("Add new task"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _newTask,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: "Task",
                  hintText: "E.g Buy groceries.",
                  icon: new Icon(Icons.note_add)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
            child: Text("Save"),
            onPressed: () {
              _handle(_newTask.text);
              _newTask.clear();
              Navigator.pop(context);
            }),
        new FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _handle(String text) async {
    _newTask.clear();
    Task task = new Task(text, date());
    int savedItemId = await db.saveTask(task);
    print(savedItemId);
    Task addedTask = await db.gettask(savedItemId);
    setState(() {
      _taskslist.insert(0, addedTask);
    });
  }

  _todolist() async {
    List tasks = await db.getAlltasks();
    tasks.forEach((task) {
      Task _task = Task.fromMap(task);
      setState(() {
        _taskslist.add(_task);
      });
      print("Tasks:" + _task.name);
    });
  }

  _deleteTask(int id, int index) async {
    await db.deletetask(id);
    setState(() {
      _taskslist.removeAt(index);
    });
  }

  _taskUpdate(Task task, int index) {
    final TextEditingController _updatedTask = new TextEditingController();
    var alert = new AlertDialog(
      title: new Text("Update the Task"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _updatedTask,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: 'Task',
                  hintText: 'E.g. Buy medicines',
                  icon: new Icon(Icons.update)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          child: Text("Update"),
          onPressed: () async {
            Task taskUpdated = Task.fromMap(
                {'name': _updatedTask.text, 'date': date(), 'id': task.id});
            _handleUpdate(taskUpdated, index);
            Navigator.pop(context);
            await db.updatetask(taskUpdated);
            setState(() {
             _todolist(); 
            });
            
          },
        ),
        new FlatButton(
          child: Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  _handleUpdate(Task taskUpdated, int index) async {
    
    setState(() {
     _taskslist.removeWhere((element){
       _taskslist[index].name == taskUpdated.name;
     });
     
    });

  }
}
