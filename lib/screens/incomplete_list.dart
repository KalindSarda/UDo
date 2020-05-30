import 'dart:async';
import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import 'package:sqflite/sqflite.dart';
import './todo_details.dart';

class IncompleteList extends StatefulWidget {

	final String appBarTitle;
	final Todo todo;
  final Color appBarColor;

	IncompleteList(this.todo, this.appBarTitle,this.appBarColor);

	@override
  State<StatefulWidget> createState() {

    return IncompListState(this.todo, this.appBarTitle,this.appBarColor);
  }
}

class IncompListState extends State<IncompleteList> {
	
  DatabaseHelper databaseHelper = DatabaseHelper();

	String appBarTitle;
  Color appBarColor;
	Todo todo;
  String whatHappened;
  List<Todo> todoList;
  int count = 0;
  String letter = 'A';

  IncompListState(this.todo,this.appBarTitle,this.appBarColor);
  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView(appBarTitle);
    }

    return Scaffold(
      body: getTodoListView(),
    );
  }


  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        final task = this.todoList[position];
        if(task.description==null){
          task.description=" ";
        }
        return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    if(direction == DismissDirection.startToEnd) { // Right Swipe
                      _complete(context,task);
                    }
                    else if(direction == DismissDirection.endToStart) {//Left Swipe
                      _delete(context, task);//add event to Calendar 
                    }
                    else{
                      debugPrint("ListTile Swiped");
                    }
                  },
                  confirmDismiss: (DismissDirection dismissDirection) async {
                    switch(dismissDirection) {
                      case DismissDirection.endToStart:
                        whatHappened = 'DELETED';
                        return await _showConfirmationDialog(context, 'delete') == true;
                      case DismissDirection.startToEnd:
                        whatHappened = 'Complete';
                        return await _showConfirmationDialog(context, 'complete') == true;
                      case DismissDirection.horizontal:
                      case DismissDirection.vertical:
                      case DismissDirection.up:
                      case DismissDirection.down:
                      assert(false);
                    }
                    return false;
                  },
                  background:Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    color: Colors.lightGreenAccent,
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.check),
                  ),
                  secondaryBackground: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.remove_circle_outline),
                  ),
                  child: Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                      backgroundColor: appBarColor,
                      child: 
                        Text(getFirstLetter(this.todoList[position].title),
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)
                        ),
                      ),
                    title:
                        Text(this.todoList[position].title,
                          style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                    subtitle: Text(this.todoList[position].description),
                    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(this.todoList[position].date)
      ],
    ),
                    onTap: () {
                      debugPrint("ListTile Tapped");
                      navigateToEdit(this.todoList[position],appBarColor);
                    },
                  ),
                ),
              );
            },
          );
        }

 getFirstLetter(String title) {
    return title.substring(0, 2);
  }


  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnackBar(context, 'Task Deleted Successfully');
      updateListView(appBarTitle);
    }
  }

    void _complete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.updateTodoStatus(todo,todo.id);
    if (result != 0) {
      if(todo.isCompleted==true)
      {
        _showSnackBar(context, 'Task incomplete');
      }
      else{
        todoList.remove(todo);
        _showSnackBar(context, 'Task Completed');
      }
      updateListView(appBarTitle);
    }
    else{
      _showSnackBar(context, 'Task is not yet completed');
      updateListView(appBarTitle);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToEdit(Todo todo,Color appBarColor) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo,appBarColor);
    }));

    if (result == true) {
      updateListView(appBarTitle);
    }
  }

    void moveToLastScreen() {
		Navigator.pop(context, true);
  }

  void updateListView(String category) {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getIncompleteTodoList(category);
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }

  Future<bool> _showConfirmationDialog(BuildContext context, String action) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Do you want to mark this item as $action?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.pop(context, true); // showDialog() returns true
            },
          ),
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.pop(context, false); // showDialog() returns false
            },
          ),
        ],
      );
    },
  );
}

  


  Widget buildPopupMenuButton() {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      initialValue: letter,
      onSelected: (val) => setState(() => letter = val),
      child: ListTile(
        title: Text('The letter $letter'),
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'A',
            child: Text('The letter A'),
          ),
          PopupMenuItem<String>(
            value: 'B',
            child: Text('The letter B'),
          ),
        ];
      },
    );
  }



}