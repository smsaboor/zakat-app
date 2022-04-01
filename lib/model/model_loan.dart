class ModelLoan {
//_name means that it is private for application
     String? _loanid;
     String? _description;
     double? _amount;
     String? _date;
     String? _type;
     String? _addnotes;
     String? _userId;

//if we want to make variable optional then put it within [] eg: [this.description]
  // below is a unnamed constructor in flutter there is only one unnamed constructor allowed
  ModelLoan.withoutId(this._description, this._amount, this._date, this._type,
      this._addnotes, this._userId);
//below is named constructor
  ModelLoan(this._loanid, this._description, this._amount, this._date,
      this._type, this._addnotes, this._userId);

  String get loanid => _loanid ?? '';
  String get description => _description ?? '';
  double get amount => _amount ?? 0;
  String get date => _date ?? '';
  String get type => _type ?? '';
  String get addnotes => _addnotes ?? '';
  String get userId => _userId ?? '';

  //below are setters ,here we do not create setter for id becouse it id  generate automatically
  //setters are with validations before saving it so we give more validation logics for our app

  set description(String value) {
    _description = value;
  }

  set amount(double value) {
    _amount = value;
  }

  set date(String newDate) {
    _date = newDate;
  }

  set type(String value) {
    _type = value;
  }

  set addnotes(String value) {
    _addnotes = value;
  }

  set userId(String value) {
    _userId = value;
  }
  set loanid(String value) {
    _loanid = value;
  }
  // function to Convert a UserModel object into a Map object
  //toMap() is a function is used to insert or any operation
  //String is used becouse map object is always string but normal object like id,name is of any type so dynamic keyword is used to represent both/all at runtime
  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (_loanid != null) {
      map['loanid'] = _loanid;
    }
    //then insert _name into map object with the key of name and so on

    map['description'] = _description;
    map['amount'] = _amount;
    map['date'] = _date;
    map['type'] = _type;
    map['addnotes'] = _addnotes;
    map['userId'] = _userId;
    return map;
  }

  // function help to Extract a UserModel object from a Map object
  //it looks like reverse of above function
  //below line we create a named cunstructor that will take map as a parameter and simply crete instance of a UserModel object
  ModelLoan.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._loanid = map['loanid'];
    this._description = map['description'];
    this._amount = map['amount'];
    this._date = map['date'];
    this._type = map['type'];
    this._addnotes = map['addnotes'];
    this._userId = map['userId'];
  }
}
