class Todo {

	int _id;
	String _title;
	String _description;
	String _date;
  String _category;
  bool _isCompleted;

	Todo(this._title, this._date,this._category,this._isCompleted, [this._description]);

	Todo.withId(this._id, this._title, this._date,this._category,this._isCompleted, [this._description]);

	int get id => _id;

	String get title => _title;

	String get description => _description;

	String get date => _date;

  String get category =>_category;

  bool get isCompleted => _isCompleted;


	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}
	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}

	set date(String newDate) {
		this._date = newDate;
	}

  set category(String newCategory) {
		this._category = newCategory;
	}
  
  set isCompleted(bool status) {
		this._isCompleted = status;
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['title'] = _title;
		map['description'] = _description;
		map['date'] = _date;
    map['category']=_category;
    if(_isCompleted==false){
        map['isCompleted']=0;
    }
    else{
      map['isCompleted']=1;
    }
    

		return map;
	}

	// Extract a Note object from a Map object
	Todo.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._title = map['title'];
		this._description = map['description'];
		this._date = map['date'];
    this._category=map['category'];
    if(map['isCompleted']==0)
    {
      this._isCompleted=false;  
    }
    else{
      this._isCompleted=true;
    }
	}
}