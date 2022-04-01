class ModelSetting {
//_name means that it is private for application
  String? _settingId;
  String? _country;
  String? _currency;
  double? _nisab;
  String? _startDate;
  String? _endDate;
  double? _goldRate18C;
  double? _goldRate20C;
  double? _goldRate22C;
  double? _goldRate24C;
  double? _silverRate18C;
  double? _silverRate20C;
  double? _silverRate22C;
  double? _silverRate24C;
  String? _userId;

  ModelSetting(
      this._settingId,
      this._country,
      this._currency,
      this._nisab,
      this._startDate,
      this._endDate,
      this._goldRate18C,
      this._goldRate20C,
      this._goldRate22C,
      this._goldRate24C,
      this._silverRate18C,
      this._silverRate20C,
      this._silverRate22C,
      this._silverRate24C,
      this._userId);

  ModelSetting.withoutId(
      this._country,
      this._currency,
      this._nisab,
      this._startDate,
      this._endDate,
      this._goldRate18C,
      this._goldRate20C,
      this._goldRate22C,
      this._goldRate24C,
      this._silverRate18C,
      this._silverRate20C,
      this._silverRate22C,
      this._silverRate24C,
      this._userId);

  String get settingId => _settingId ?? '';     set settingId(String value) => _settingId = value;
  String get country => _country ?? '';     set country(String value) => _country = value;
  String get currency => _currency ?? '';   set currency(String value) => _currency = value;
  double get nisab => _nisab ?? 0;           set nisab(double value) => _nisab = value;
  String get startDate => _startDate ?? '';    set startDate(String value) => _startDate = value;
  String get endDate => _endDate ?? '';        set endDate(String value) => _endDate = value;
  double get goldRate18C => _goldRate18C ?? 0;   set goldRate18C(double value) => _goldRate18C = value;
  double get goldRate20C => _goldRate20C ?? 0;   set goldRate20C(double value) => _goldRate20C = value;
  double get goldRate22C => _goldRate22C ?? 0;   set goldRate22C(double value) => _goldRate22C = value;
  double get goldRate24C => _goldRate24C ?? 0;   set goldRate24C(double value) => _goldRate24C = value;
  double get silverRate18C => _silverRate18C ?? 0;   set silverRate18C(double value) => _silverRate18C = value;
  double get silverRate20C => _silverRate20C ?? 0;   set silverRate20C(double value) => _silverRate20C = value;
  double get silverRate22C => _silverRate22C ?? 0;   set silverRate22C(double value) => _silverRate22C = value;
  double get silverRate24C => _silverRate24C ?? 0;   set silverRate24C(double value) => _silverRate24C = value;
  String get userId => _userId ?? '';                     set userId(String value) => _userId = value;





  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (settingId != null) {
      map['settingId'] = _settingId;
    }
    //then insert _name into map object with the key of name and so on
    map['country'] = _country;
    map['currency'] = _currency;
    map['nisab'] = _nisab;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['goldRate18C'] = _goldRate18C;
    map['goldRate20C'] = _goldRate20C;
    map['goldRate22C'] = _goldRate22C;
    map['goldRate24C'] = _goldRate24C;
    map['silverRate18C'] = _silverRate18C;
    map['silverRate20C'] = _silverRate20C;
    map['silverRate22C'] = _silverRate22C;
    map['silverRate24C'] = _silverRate24C;
    map['userId'] = _userId;
    return map;
  }

  ModelSetting.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this._settingId = map['settingId'];
    this._country = map['country'];
    this._currency = map['currency'];
    this._nisab = map['nisab'];
    this._startDate = map['startDate'];
    this._endDate = map['endDate'];
    this._goldRate18C = map['goldRate18C'];
    this._goldRate20C = map['goldRate20C'];
    this._goldRate22C = map['goldRate22C'];
    this._goldRate24C = map['goldRate24C'];
    this._silverRate18C = map['silverRate18C'];
    this._silverRate20C = map['silverRate20C'];
    this._silverRate22C = map['silverRate22C'];
    this._silverRate24C = map['silverRate24C'];
    this._userId = map['userId'];
  }
}
