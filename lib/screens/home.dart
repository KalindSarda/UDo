import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './add.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import './details.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}


class HomeState extends State<Home> {

  
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;
  

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
		
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
     }

    return WillPopScope(
     onWillPop: () => showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Warning!!!!'),
        
        content: Text('Do you really want to exit?'),
        actions:  <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
									      color:Colors.redAccent,
									      textColor: Colors.white,
                        child: const Text('Yes'),
                        onPressed: () {
                          Navigator.pop(c, true); // showDialog() returns true
                        },
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
									      color:Colors.green,
									      textColor: Colors.white,
									      child: const Text('No'),
                        onPressed: () {
                          Navigator.pop(c, false); // showDialog() returns false
                        },
                      ),
                    ],
        ),
    ),
      child: Scaffold(
      appBar: AppBar( 
        title: Row(
          children: <Widget>[
            Icon(Icons.check,size: 40,),
              Text('UDo',style: TextStyle(fontSize: 25))
          ],
        ),
        
        backgroundColor: Color(0xffF07995),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              _delete(context);
            },
            child:Row(
              children: <Widget>[
                Icon(Icons.delete_outline),
                Text("Delete All")
              ],
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: //getTodoGridView(),
      getTodoListView(screenwidth),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('Add Button clicked');
            navigateToAdd(Todo('','','',false));
          },
          tooltip: 'Add',
          elevation: 12.0,
          child: Icon(Icons.add,size: 40,),
          backgroundColor: Color(0xffF07995),
          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
        ),
      ),
    );
  }

  /*GridView getTodoGridView() {
    return GridView.builder(
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 0.5, mainAxisSpacing: 0.5),
      itemBuilder: (BuildContext context, int position){
        
        return _cardCreator(todoList[position].category, todoList[position],);
      },
    );
  }*/

  ListView getTodoListView(double width) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        
        return _cardCreator(todoList[position].category, todoList[position],width);
      },
    );
  }

 _cardCreator(String category,Todo todo,double width){
    Icon caticon;
    Color catcolor;
    switch(category){
      case 'Work':
                catcolor=Colors.redAccent;
                caticon =Icon(Icons.work,color: catcolor,size: 54,);
                break;
      case 'Personal':
                catcolor=Color(0xffF0810F);
                caticon =Icon(Icons.people,color: catcolor,size: 54,);
                break;
      case 'Studies':
                catcolor=Color(0xff824CA7);
                caticon =Icon(Icons.book,color: catcolor,size: 54,);
                break;
      case 'Others':
                catcolor=Color(0xff8EBA43);
                caticon =Icon(Icons.apps,color: catcolor,size: 54,);
                break;
    }
    return Card(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(150.0), 
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
      color: Colors.white,
      elevation: 6.0,
      child:ListTile(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            caticon,
            Container( 
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child:Text(category,style: TextStyle(fontSize: 18)),
            )   
          ]
        ),      
        onTap: () {
          debugPrint("Todo Tapped");
          navigateToDetail(todo,category,catcolor);
        },
      )
    )
    ;
  }

  void _delete(BuildContext context) async {
    int result;
    if(await _showConfirmationDialog(context, 'Delete') == true){
      result = await databaseHelper.deleteAllTodo();
      if (result != 0) {
        updateListView();
      }
    }
    updateListView();
  }

  void navigateToDetail(Todo todo, String title,Color appBarColor) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Details(todo, title,appBarColor);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToAdd(Todo todo) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Add(todo);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoCategoryList();
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
          title: Text('$action all?'),
          actions: <Widget>[
            RaisedButton(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
									    color:Colors.redAccent,
									    textColor: Colors.white,
									  child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true); // showDialog() returns true
              },
            ),
            RaisedButton(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
									    color:Colors.green,
									    textColor: Colors.white,
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

}