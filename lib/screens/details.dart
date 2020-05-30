import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import './incomplete_list.dart';
import './complete_list.dart';

class Details extends StatefulWidget {

	final String appBarTitle;
	final Todo todo;
  final Color appBarColor;

	Details(this.todo, this.appBarTitle,this.appBarColor);

	@override
  State<StatefulWidget> createState() {

    return CatListState(this.todo, this.appBarTitle,this.appBarColor);
  }
}

class CatListState extends State<Details> {
	
  DatabaseHelper databaseHelper = DatabaseHelper();

	String appBarTitle;
  Color appBarColor;
	Todo todo;

  CatListState(this.todo,this.appBarTitle,this.appBarColor);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
      moveToLastScreen();
      },
      child: MaterialApp(
        home: DefaultTabController(
          length: 2,
          child:Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
              backgroundColor: appBarColor,
              leading: IconButton(icon: Icon(
				          Icons.arrow_back),
				          onPressed: () {
		    	          moveToLastScreen();
				          }
		          ),
              bottom: TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.cancel),text:"Incomplete",),
                  Tab(icon: Icon(Icons.check),text:"Complete",),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                IncompleteList(todo, appBarTitle, appBarColor),
                CompleteList(todo, appBarTitle, appBarColor)
              ],
            ),
          )
        ),
      ),
    ) ;
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }
}