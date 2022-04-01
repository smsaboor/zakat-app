class ModelUser {
//_name means that it is private for application
  String? userId;
   String? name;
   String? email;
   String? phone;
   String? password;
   String? registrationDate; // user registration date
   String? isPaid;
   int? age;
   String? paymentDate;
   String? city;
   int? pin;
  String? familyId;
   String? photoUrl;

  ModelUser(
      this.userId,
      this.name,
      this.email,
      this.phone,
      this.password,
      this.registrationDate,
      this.isPaid,
      this.age,
      this.paymentDate,
      this.city,
      this.pin,
      this.familyId,
      this.photoUrl);

  ModelUser.withoutId(
      this.name,
      this.email,
      this.phone,
      this.password,
      this.registrationDate,
      this.isPaid,
      this.age,
      this.paymentDate,
      this.city,
      this.pin,
      this.familyId,
      this.photoUrl);


  Map<String, dynamic> toMap() {
    //below line is instantiation for empty map object
    var map = Map<String, dynamic>();
    if (userId != null) {
      map['userId'] = userId;
    }
    //then insert _name into map object with the key of name and so on
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['password'] = password;
    map['age'] = age;
    map['registrationDate'] = registrationDate;
    map['isPaid'] = isPaid;
    map['paymentDate'] = paymentDate;
    map['city'] = city;
    map['pin'] = pin;
    map['familyId'] = familyId;
    map['photoUrl'] =photoUrl;

    return map;
  }

  ModelUser.fromMapObject(Map<String, dynamic> map) {
    //below line for extract a id
    //keys in green color or used within map[] should be same which we used above mapping
    this.userId = map['userId'];
    this.name = map['name'];
    this.email = map['email'];
    this.phone = map['phone'];
    this.password = map['password'];
    this.age = map['age'];
    this.registrationDate = map['registrationDate'];
    this.isPaid = map['isPaid'];
    this.paymentDate = map['paymentDate'];
    this.city = map['city'];
    this.pin = map['pin'];
    this.familyId = map['familyId'];
    this.photoUrl = map['photoUrl'];
  }
}
