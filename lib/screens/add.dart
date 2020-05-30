import 'dart:async';
import 'package:flutter/material.dart';
import '../model/todo.dart';
import '../util/dbhelper.dart';
import 'package:intl/intl.dart';

class Add extends StatefulWidget {

	final Todo todo;

	Add(this.todo);

	@override
  State<StatefulWidget> createState() {
    return AddState(this.todo);
  }
}

class AddState extends State<Add> {

	DatabaseHelper helper = DatabaseHelper();

	Todo todo;
  DateTime selectedDate = DateTime.now();
  String dropdownValue;
  


	TextEditingController titleController = TextEditingController();
	TextEditingController descriptionController = TextEditingController();

	AddState(this.todo);

	@override
  Widget build(BuildContext context) {

		TextStyle textStyle = TextStyle(color: Color(0xff20948B));
    double screenwidth = MediaQuery.of(context).size.width;
		titleController.text = todo.title;
		descriptionController.text = todo.description;

    return WillPopScope(
	    onWillPop: () {
		    moveToLastScreen();
	    },

	    child: Scaffold(
	    appBar: AppBar(
        iconTheme: IconThemeData(
    
  ),
  title: const Text('Add', style: TextStyle(color: Colors.white)),
		     backgroundColor:Color(0xff20948B),
		    leading: IconButton(color: Colors.white,icon: Icon(
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
      color: Color(0xff20948B),
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
      dropdownColor: Color(0xff20948B),
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
      color: Color(0xff20948B),
      borderRadius: BorderRadius.circular(5.0),
      shape: BoxShape.rectangle,
      ),
            child: FlatButton(
                      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
									    color:Color(0xff20948B),
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
				    

				    Padding(
					    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
					    child: Container(
                      height: screenwidth/10,
                      padding:
      EdgeInsets.symmetric(horizontal: 10,vertical: 5.0),
  decoration: BoxDecoration(
      color: Colors.redAccent,
      borderRadius: BorderRadius.circular(5.0),
      shape: BoxShape.rectangle,
      ),
            child: Row(
						    children: <Widget>[
						    	Expanded(
								    child: FlatButton(shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(5.0),
  ),
									    color:Colors.redAccent,
									    textColor: Colors.white,
									    child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.white,size: 32,),
                          Text(
										    'Save',
										    textScaleFactor: 1.5,style: TextStyle(fontSize: 20),
									    ),
                        ],
                      ) ,
                      
									    onPressed: () {
									    	setState(() {
									    	  debugPrint("Save button clicked");
									    	  _save();
									    	});
									    },
								    ),
							    ),
						    ],
					    ),
				    ),)


			    ],
		    ),
	    ),

    ));
  }

  void moveToLastScreen() {
		Navigator.pop(context, true);
  }

	// Update the title of todo object
  void updateTitle(){
    if(titleController.text!=null){
      todo.title = titleController.text;  
    }
    else{
      todo.title = " ";
    }
  }

    void updateCategory(String category){
    todo.category = category;
  }

	// Update the description of todo object
	void updateDescription() {
    if(descriptionController.text!=null){
      todo.description = descriptionController.text; 
    }
    else{
      todo.description =" ";
    }
		
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
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

	// Save data to database
	void _save() async {
    updateCategory(dropdownValue);
    updateDate(selectedDate);  
		moveToLastScreen();

    todo.isCompleted=false;
		int result;
		result = await helper.insertTodo(todo);

		if (result != 0) {  // Success
			_showAlertDialog('Status', 'Task Added Successfully');
		} else {  // Failure
			_showAlertDialog('Status', 'Problem Adding Task');
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