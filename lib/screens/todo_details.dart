import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {
	final Todo todo;
  final Color appBarcolor;
	TodoDetail(this.todo,this.appBarcolor);

	@override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo,this.appBarcolor);
  }
}

class TodoDetailState extends State<TodoDetail> {

	DatabaseHelper helper = DatabaseHelper();

	Todo todo;
  Color appBarColor;
	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();
   DateTime selectedDate;
  String dropdownValue;
  
  
   bool isSwitched = false;
	TodoDetailState(this.todo,this.appBarColor);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle =  TextStyle(color:appBarColor);
    double screenwidth = MediaQuery.of(context).size.width;
		titleController.text = todo.title;
		descriptionController.text = todo.description;
    dropdownValue=todo.category;
    selectedDate=DateFormat("yMMMMd").parse(todo.date);
    return WillPopScope(

	    onWillPop: () {
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
		    title: Text('Edit Todo'),
        backgroundColor: appBarColor,
		    leading: IconButton(icon: Icon(
				    Icons.arrow_back),
				    onPressed: () {
		    	    moveToLastScreen();
				    }
		    ),
	    ),

	    body: Padding(
		    padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
		    child: ListView(
			    children: <Widget>[

				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: titleController,
						    style: textStyle,
						    onChanged: (value) {
						    	debugPrint('Something changed in Title Text Field');
						    	updateTitle();
						    },
						    decoration: InputDecoration(
							    labelText: 'Title',
							    labelStyle: textStyle,
							    border: OutlineInputBorder(
								    borderRadius: BorderRadius.circular(5.0)
							    )
						    ),
					    ),
				    ),

				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: TextField(
						    controller: descriptionController,
						    style: textStyle,
						    onChanged: (value) {
							    debugPrint('Something changed in Description Text Field');
							    updateDescription();
						    },
						    decoration: InputDecoration(
								    labelText: 'Description',
								    labelStyle: textStyle,
								    border: OutlineInputBorder(
										    borderRadius: BorderRadius.circular(5.0)
								    )
						    ),
					    ),
				    ),
            

            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Container(
                      height: screenwidth/10,
  padding:
      EdgeInsets.symmetric(horizontal: 10),
  decoration: BoxDecoration(
      color: appBarColor,
      borderRadius: BorderRadius.circular(5.0),
      shape: BoxShape.rectangle
      ),
      child:Center(
          child: DropdownButton<String>(
            hint:  Text("Select Category",style: TextStyle(color: Colors.white),),
            icon: Icon(Icons.swap_vert,color: Colors.white,),
      iconSize: 32,
      style: TextStyle(color:Colors.white),
      underline: SizedBox(),
      dropdownColor: appBarColor,
            isExpanded: false,
      onChanged: (String newValue) {
        updateCategory(newValue);
        setState(() {
          dropdownValue = newValue;
        });
      },
            items: <String>['Work', 'Personal', 'Studies', 'Others']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,style: TextStyle(fontSize: 20),),
        );
      }).toList(),
            value: dropdownValue,
          ) ,
      )
      ,
          )
				    ),

           
            Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    
                child:
                    
          Container(
                      height: screenwidth/10,
                      padding:
      EdgeInsets.symmetric(horizontal: 10,vertical: 5.0),
  decoration: BoxDecoration(
      color: appBarColor,
      borderRadius: BorderRadius.circular(5.0),
      shape: BoxShape.rectangle,
      ),
            child: FlatButton(
                      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
									    color:appBarColor,
									    textColor: Colors.white,
									    child: Row(
                        
                        children: <Widget>[
                          
                      Padding(
					    padding: EdgeInsets.only(right: 15.0),
					    
                child:Icon(Icons.calendar_today,color: Colors.white,size: 32,),),
                          Text(
										    selectedDate == null //ternary function to check if date is null
            ? 'Select Date'
            : 'Deadline : ${DateFormat.yMMMd().format(selectedDate)}',
										    style: TextStyle(fontSize: 20),
									    ),
                        ],
                      ) ,
									    onPressed: () {
                        _selectDate(context);
                      },
								    ),
          )
          ,
         
				    ),
				    
				    


			    ],
		    ),
	    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
									    	  debugPrint("Update button clicked");
									    	  _save();
									    	});
        },
        tooltip: 'Update Todo',
        label: Text('Save'),
        elevation: 12.0,
        icon: Icon(Icons.check),
        backgroundColor: appBarColor,
        shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
      ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Update the title of todo object
void updateTitle(){
    todo.title = titleController.text;
  }

    void updateCategory(String category){
    todo.category = category;
  }

	// Update the description of todo object
	void updateDescription() {
		todo.description = descriptionController.text;
	}

  void updateDate(DateTime dt ) {
		todo.date = DateFormat.yMMMMd('en_US').format(dt).toString();
	}

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate){
        updateDate(picked);
        setState(() {
        selectedDate = picked;
      });
    }
      
  }

	// Save data to database
	void _save() async {
    updateCategory(dropdownValue);
    updateDate(selectedDate);  
		moveToLastScreen();
    todo.isCompleted=todo.isCompleted;
		int result;
		if (todo.id != null) {  // Case 1: Update operation
			result = await helper.updateTodo(todo);
		} else { // Case 2: Insert Operation
			result = await helper.insertTodo(todo);
		}

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Task Updated Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Updating Task');
		}

	}

	void _showAlertDialog(String title, String message) {

		AlertDialog alertDialog = AlertDialog(
			title: Text(title),
			content: Text(message),
		);
		showDialog(
				context: context,
				builder: (_) => alertDialog
		);
	}





      
}