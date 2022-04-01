class ModelMetal {
//_name means that it is private for application
      String? _metalId;
      String? _item;
      double? _weight;
      double? _carat;
      String? _date; //Date of Purchase
      String? _note;
      String? _type;
      String? _userId;
      int? _totalGold;
      int? _totalSilver;
  ModelMetal(this._metalId, this._item, this._weight, this._carat,
      this._date, this._note, this._type, this._userId);

  ModelMetal.withoutId(this._item, this._weight, this._carat, this._date,
      this._note, this._type, this._userId);

    int get TotalOfGold => _totalGold ?? 0;
    int get TotalOfSilver => _totalSilver ?? 0;
    set TotalOfGold(int value) {
    _totalGold = value;
  }

  set TotalOfSilver(int value) {
    _totalSilver = value;
  }

  String get userId => _userId ?? '';
  String get type => _type ?? '';
  String get note => _note ?? '';

  String get date => _date ?? '';

  double get carat => _carat ?? 0;

  double get weight => _weight ?? 0;

  String get item => _item ?? '';

  String get metalId => _metalId ?? '';

  set userId(String value) {
    _userId = value;
  }

  set type(String value) {
    _type = value;
  }

  set note(String value) {
    _note = value;
  }

  set date(String value) {
    _date = value;
  }

  set carat(double value) {
    _carat = value;
  }

  set weight(double value) {
    _weight = value;
  }

  set item(String value) {
    _item = value;
  }

  set metalId(String value) {
    _metalId = value;
  }

  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (metalId != null) {
      map['metalId'] = _metalId;
    }
    //then insert _name into map object with the key of name and so on
    map['item'] = _item;
    map['weight'] = _weight;
    map['carat'] = _carat;
    map['date'] = _date;
    map['note'] = _note;
    map['type'] = _type;
    map['userId'] = _userId;

    return map;
  }

  ModelMetal.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._metalId = map['metalId'];
    this._item = map['item'];
    this._weight = map['weight'];
    this._carat = map['carat'];
    this._date = map['date'];
    this._note = map['note'];
    this._type = map['type'];
    this._userId = map['userId'];
  }
}
