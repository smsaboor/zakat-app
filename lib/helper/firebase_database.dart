import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zakat_app/model/model_riba.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/model/model_user.dart';
import 'package:zakat_app/model/model_zakat_paid.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:zakat_app/model/model_cash.dart';
import 'package:zakat_app/model/model_metal.dart';
import 'package:zakat_app/model/model_loan.dart';

class FirebaseHelper {
  //--------------------------- Common implementation for all Assets (Gold, Silver, Cash-in-hand, Cash-in-Bank)------------
  static int? firebaseUser;
  static FirebaseHelper?
      _firebaseHelper; // Define Singleton DatabaseHelper object
  FirebaseHelper._createInstance();

  factory FirebaseHelper() {
    if (_firebaseHelper == null) {
      _firebaseHelper = FirebaseHelper._createInstance();
    }
    return _firebaseHelper!;
  }

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection("user");
  CollectionReference settingCollection =
      FirebaseFirestore.instance.collection("setting");
  CollectionReference cashCollection =
      FirebaseFirestore.instance.collection("cash");
  CollectionReference ribaCollection =
      FirebaseFirestore.instance.collection("riba");
  CollectionReference metalCollection =
      FirebaseFirestore.instance.collection("metal");
  CollectionReference loanCollection =
      FirebaseFirestore.instance.collection("loan");
  CollectionReference zakatPaymentsCollection =
      FirebaseFirestore.instance.collection("zakatPayments");

  //---------------------------- All Functions for Cash Asset are implemented below----------------------------------

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelCash>> getCashList(String userId, String table, String type,
      {String startDate = '1900-01-01', String endDate = '3000-01-01'}) async {
    List<ModelCash> cashList = <ModelCash>[]; //third create empty List of Gold
    var cashSnapShot = await cashCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        // .where("date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();

    cashSnapShot.docs.forEach((map) {
      ModelCash modelCash = new ModelCash(
      map.id,
      map['title'],
      map['amount'],
      map['date'],
      map['note'],
      map['type'],
      map['userId'],
      );
      cashList.add(modelCash);
      print(map.data());
    });
    return cashList; // finally return our
  }

  Future<int> insertCash(ModelCash cash) async {
    var result = await cashCollection
        .add(cash.toJson())
        .then((value) => print("cash Inserted"))
        .catchError((error) => print("Failed to insert cash: $error"));
    return 1;
  }

  Future<int> updateCash(ModelCash cash) async {
    var result = await cashCollection
        .doc(cash.cashId.toString())
        .update(cash.toJson())
        .then((value) => print("cash Updated"))
        .catchError((error) => print("Failed to update cash: $error"));
    return 1;
  }

  Future<int> deleteCash(String cashId) async {
    int result=0;
    await cashCollection
        .doc(cashId)
        .delete()
        .then((value) => print("cash deleted ${result=1}"))
        .catchError((error) => print("Failed to delet cash: $error"));
    return result;
  }

  Future<int> getCashCount(String userId) async {
    var cashSnapShot =
        await cashCollection.where("userId", isEqualTo: userId).get();
    int result = cashSnapShot.docs.length;
    return result;
  }

  //------------------------------All Functions For Metal Asset are implemented below------------------------------------------

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]

  Future<List<ModelMetal>> getMetalList(
      String userId, String table, String type,
      {String startDate = '1900-01-01', String endDate = '3000-01-01'}) async {
    List<ModelMetal> metalList = <ModelMetal>[];
    var metalSnapShot = await metalCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        // .where("date",
        //     isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    metalSnapShot.docs.forEach((map) {
      ModelMetal modelMetal = new ModelMetal(
        map.id,
        map['item'],
        map['weight'],
        map['carat'],
        map['date'],
        map['note'],
        map['type'],
        map['userId'],
      );
      metalList.add(modelMetal);
      print(map.data());
    });
    return metalList; // finally re
  }

  Future<int> insertMetal(ModelMetal metal) async {
    var result = await metalCollection
        .add(metal.toMap())
        .then((value) => print("metal Inserted"))
        .catchError((error) => print("Failed to insert metal: $error"));
    return 1;
  }

  Future<int> updateMetal(ModelMetal metal) async {
    var result = await metalCollection
        .doc(metal.metalId.toString())
        .update(metal.toMap())
        .then((value) => print("metal Updated"))
        .catchError((error) => print("Failed to update metal: $error"));
    return 1;
  }

  Future<int> deleteMetal(String metalId) async {
    int result=0;
    await metalCollection
        .doc(metalId)
        .delete()
        .then((value) => print("metal deleted ${result=1}"))
        .catchError((error) => print("Failed to delete metal: $error"));
    return result;
  }

  Future<int> getMetalCount(String userId) async {
    var metalSnapShot =
        await metalCollection.where("userId", isEqualTo: userId).get();
    int result = metalSnapShot.docs.length;
    return result;
  }

//-------------------------------------------------------------------------------------------------------
//---------------------------- All Functions for User Table are implemented below---------------------------------
// Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]

  Future<int> checkUserExist(String userId) async {
    debugPrint("checkUserExist  ------------}");
    var userSnapShot =
        await userCollection.where("userId", isEqualTo: userId).get();
    debugPrint(
        "checkUserExist 2  length------------${userSnapShot.docs.length}");
    int i = 0;
    if (userSnapShot.docs.length != 0) {
      userSnapShot.docs.forEach((doc) {
        print(doc.data());
        i++;
      });
      return 1;
    } else
      return 0; // finally return our
  }

  Future<ModelUser?> getUser(String userId) async {
    ModelUser? userModel;
    var userSnapShot = await userCollection.where("userId", isEqualTo: userId).get();
    int i = 0;
    try {
      if (userSnapShot.docs.length != 0) {
        userSnapShot.docs.forEach((map) {
          userModel = ModelUser(
              map['userId'],
              map['name'],
              map['email'],
              map['phone'],
              map['password'],
              map['registrationDate'],
              map['isPaid'],
              map['age'],
              map['paymentDate'],
              map['city'],
              map['pin'],
              map['familyId'],
              map['photoUrl']);
          // userList.add(ModelUser.fromMapObject(doc[i]));
          print(map.data());
          i++;
        });
      }
    } catch (e) {
      print("getUser error ${e}");
    }
    return userModel;

    /// finally return our
  }

  Future<List<ModelUser>> getUserList(String userId) async {
    List<ModelUser> userList = <ModelUser>[];
    var userSnapShot =
        await userCollection.where("userId", isEqualTo: userId).get();
    int i = 0;
    firebaseUser = userSnapShot.docs.length;
    debugPrint(" FirebaseHelper.firebaseUser2 ------------${firebaseUser}");
    try {
      if (userSnapShot.docs.length != 0) {
        userSnapShot.docs.forEach((doc) {
          userList.add(ModelUser.fromMapObject(doc.get(i)));
          print(doc.data());
          i++;
        });
      }
    } catch (e) {
      print(
          "-------------------------------------------get Usert error : ${e}");
    }
    return userList; // finally return our
  }

  Future<int> insertUser(ModelUser user) async {
    var result = await userCollection
        .add(user.toMap())
        .then((value) => print("user Inserted"))
        .catchError((error) => print("Failed to insert user: $error"));
    return 1;
  }

  Future<int> updateUser(ModelUser user) async {
    var result = await userCollection
        .doc(user.userId.toString())
        .update(user.toMap())
        .then((value) => print("user Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    return 1;
  }


  Future<int> deleteUser(String userId) async {
    int result=0;
    await userCollection
        .doc(userId)
        .delete()
        .then((value) => print("user deleted ${result=1}"))
        .catchError((error) => print("Failed to delete user: $error"));
    return result;
  }

  Future<int> getUserCount(String userId) async {
    var userSnapShot =
        await userCollection.where("userId", isEqualTo: userId).get();
    int result = userSnapShot.docs.length;
    return result;
  }

  //-----------------------------------------------------------------Setting Functions--------------------------------------------------------------------------
  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<ModelSetting?> getSettingList(String userId) async {
    List<ModelSetting> settingList = <ModelSetting>[];
    var settingSnapShot =
        await settingCollection.where("userId", isEqualTo: userId).get();
    settingSnapShot.docs.forEach((map) {
      settingList.add(ModelSetting(
          map.id,
          map['country'],
          map['currency'],
          map['nisab'],
          map['startDate'],
          map['endDate'],
          map['goldRate18C'],
          map['goldRate20C'],
          map['goldRate22C'],
          map['goldRate24C'],
          map['silverRate18C'],
          map['silverRate20C'],
          map['silverRate22C'],
          map['silverRate24C'],
          map['userId']));
      print(map.data());
    });
    return settingList.isNotEmpty
        ? settingList.elementAt(0)
        : null; // finally return our
  }

  Future<int> insertSetting(ModelSetting? setting) async {
    var result = await settingCollection
        .add(setting!.toMap())
        .then((value) => print("setting Inserted"))
        .catchError((error) => print("Failed to insert setting: $error"));
    return 1;
  }

  Future<int> updateSetting(ModelSetting setting) async {
    var result = await settingCollection
        .doc(setting.settingId.toString())
        .update(setting.toMap())
        .then((value) => print("setting Updated"))
        .catchError((error) => print("Failed to update setting: $error"));
    return 1;
  }

  Future<int> deleteSetting(String settingId) async {
    int result=0;
    await settingCollection
        .doc(settingId)
        .delete()
        .then((value) => print("setting deleted ${result=1}"))
        .catchError((error) => print("Failed to delete setting: $error"));
    return result;
  }

  Future<int?> getSettingCount(String settingId) async {
    var settingSnapShot =
        await settingCollection.where("settingId", isEqualTo: settingId).get();
    int result = settingSnapShot.docs.length;
    return result;
  }

//--------------------------------------------Riba Functions---------------------------------------------
  Future<List<ModelRiba>> getRibaList(
      String userId, String startDate, String endDate) async {
    List<ModelRiba> ribaList = <ModelRiba>[];
    var ribaSnapShot = await ribaCollection
        .where("userId", isEqualTo: userId)
        // .where("date", isGreaterThan: startDate, isLessThan: endDate)
        .get();
    ribaSnapShot.docs.forEach((map) {
      ModelRiba modelRiba = new ModelRiba(
          map.id,
        //then insert _name into map object with the key of name and so on
        map['bankName'] ,
        map['amount'] ,
        map['date'] ,
        map['note'] ,
        map['userId']
      );
      ribaList.add(modelRiba);
      print(map.data());
    });
    return ribaList; // finally re
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListReceived(String userId) async {
    List<ModelRiba> ribaList = <ModelRiba>[];
    var ribaSnapShot = await ribaCollection
        .where("userId", isEqualTo: userId)
        .where("amount", isGreaterThan: 0)
        .get();
    ribaSnapShot.docs.forEach((map) {
      ModelRiba modelRiba = new ModelRiba(map.id, map['bankName'],
          map['amount'], map['date'], map['note'], map['userId']);
      ribaList.add(modelRiba);
      print(map.data());
    });
    return ribaList; // finally return our
  }

  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListPaid(String userId) async {
    List<ModelRiba> ribaList = <ModelRiba>[];
    var ribaSnapShot = await ribaCollection
        .where("userId", isEqualTo: userId)
        .where("amount", isGreaterThan: 0)
        .get();
    ribaSnapShot.docs.forEach((map) {
      ModelRiba modelRiba = new ModelRiba(
      map.id, map['bankName'],
          map['amount'], map['date'], map['note'], map['userId']);
      ribaList.add(modelRiba);
      print(map.data());
    });
    return ribaList; // finally return our
  }

  Future<int> insertRiba(ModelRiba riba) async {
    var result = await ribaCollection
        .add(riba.toMap())
        .then((value) => print("riba Inserted"))
        .catchError((error) => print("Failed to insert riba: $error"));
    return 1;
  }

  Future<int> updateRiba(ModelRiba riba) async {
    var result = await ribaCollection
        .doc(riba.ribaId.toString())
        .update(riba.toMap())
        .then((value) => print("riba updated"))
        .catchError((error) => print("Failed to update riba: $error"));
    return 1;
  }

  Future<int> deleteRiba(String ribaId) async {
    int result=0;
    await ribaCollection
        .doc(ribaId)
        .delete()
        .then((value) => print("riba deleted ${result=1}"))
        .catchError((error) => print("Failed to delete riba: $error"));
    return result;
  }

  Future<int?> getRibaCount(String userId) async {
    var ribaSnapShot =
        await ribaCollection.where("userId", isEqualTo: userId).get();
    int result = ribaSnapShot.docs.length;
    return result;
  }

  //--------------------------------Functions for Loan--------------------------------------------

  Future<List<ModelLoan>> getTotalLoanList(String userId) async {
    List<ModelLoan> loanlList = <ModelLoan>[];
    var loanSnapShot =
        await loanCollection.where("userId", isEqualTo: userId).get();
    loanSnapShot.docs.forEach((map) {
      ModelLoan modelLoan = new ModelLoan(
          map.id,
          map['description'],
          map['amount'],
          map['date'],
          map['type'],
          map['addnotes'],
          map['userId']);
      loanlList.add(modelLoan);
      print(map.data());
    });
    return loanlList; // finally return our
  }

  Future<List<ModelLoan>> getLoanList(
      String table, String type, String userId) async {
    List<ModelLoan> loanList = <ModelLoan>[];
    var loanSnapShot = await loanCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        .get();
    loanSnapShot.docs.forEach((res) {
      ModelLoan modelLoan = new ModelLoan(
        res.id,
        res['description'],
        res['amount'],
        res['date'],
        res['type'],
        res['addnotes'],
        res['userId'],
      );
      loanList.add(modelLoan);
      print(res.data());
    });
    return loanList; // finally re
  }

  Future<int> updateLoan(ModelLoan loan) async {
    var result = await loanCollection
        .doc(loan.loanid.toString())
        .update(loan.toMap())
        .then((value) => print("loan Updated"))
        .catchError((error) => print("Failed to update loan: $error"));
    return 1;
  }

  Future<int> insertLoan(ModelLoan loan) async {
    var result = await loanCollection
        .add(loan.toMap())
        .then((value) => print("loan Inserted"))
        .catchError((error) => print("Failed to insert loan: $error"));
    return 1;
  }


  // Future<int> checkLoanExist(String docId) async {
  //   var userDocRef = FirebaseFirestore.instance.collection('loan').doc(docId);
  //   var doc = await userDocRef.get();
  //   if (!doc.exists) {
  //     debugPrint('No such document exista!');
  //     return 0;
  //   } else {
  //     debugPrint('Document data: ${doc.data()}');
  //     return 1;
  //   }
  // }
  Future<int> deleteLoan(String loanId) async {
    int result=0;
    await loanCollection
        .doc(loanId)
        .delete()
        .then((value) => print("loan deleted ${result=1}"))
        .catchError((error) => print("Failed to delete loan: $error"));
    return result;

  }

  Future<int?> getLoanCount(String userId) async {
    var loanSnapShot =
        await loanCollection.where("userId", isEqualTo: userId).get();
    int result = loanSnapShot.docs.length;
    return result;
  }

//------------------------------------------zakat functions----------------------------------------------------
  Future<List<ModelCash>> getCashListZakat(String table, String type,
      String startDate, String endDate, String userId) async {
    List<ModelCash> cashListZakat =
        <ModelCash>[]; //third create empty List of Gold
    var cashSnapShot = await cashCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        .where("date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    cashSnapShot.docs.forEach((map) {
      ModelCash modelCash = new ModelCash(
        map.id,
        map['title'],
        map['amount'],
        map['date'],
        map['note'],
        map['type'],
        map['userId'],
      );
      cashListZakat.add(modelCash);
      print(map.data());
    });
    return cashListZakat; // finally return our
  }

  Future<List<ModelMetal>> getMetalListZakat(String table, String type,
      String startDate, String endDate, String userId) async {
    List<ModelMetal> metalListZakat = <ModelMetal>[];
    var metalSnapShot = await metalCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        .where("date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    metalSnapShot.docs.forEach((map) {
      ModelMetal modelMetal = new ModelMetal(
        map.id,
        map['item'],
        map['weight'],
        map['carat'],
        map['date'],
        map['note'],
        map['type'],
        map['userId'],
      );
      metalListZakat.add(modelMetal);
      print(map.data());
    });
    return metalListZakat; // finally re
  }
  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelRiba>> getRibaListZakat(String userId) async {
    List<ModelRiba> ribaListZakat = <ModelRiba>[];
    var ribaSnapShot =
        await ribaCollection.where("userId", isEqualTo: userId).get();
    ribaSnapShot.docs.forEach((map) {
      ModelRiba modelRiba = new ModelRiba(map.id, map['bankName'],
          map['amount'], map['date'], map['note'], map['userId']);
      ribaListZakat.add(modelRiba);
      print(map.data());
    });
    return ribaListZakat; // finally return our
  }
  Future<List<ModelLoan>> getLoanListZakat(String table, String type,
      String startDate, String endDate, String userId) async {
    List<ModelLoan> loanListZakat = <ModelLoan>[];
    var loanSnapShot = await loanCollection
        .where('type', isEqualTo: type)
        .where("userId", isEqualTo: userId)
        .where("date", isGreaterThanOrEqualTo: startDate, isLessThanOrEqualTo: endDate)
        .get();
    loanSnapShot.docs.forEach((res) {
      ModelLoan modelLoan = new ModelLoan(
        res.id,
        res['description'],
        res['amount'],
        res['date'],
        res['type'],
        res['addnotes'],
        res['userId'],
      );
      loanListZakat.add(modelLoan);
      print(res.data());
    });
    return loanListZakat; // finally re
  }


  //---------------------------- All Functions for Zakat Paid are implemented below-----------------------------------
  // Get the 'Map List' [ List<Map> ] from the database and convert it to 'Gold List' [ List<ModelGold> ]
  Future<List<ModelZakatPaid>> getZakatPaidList(String userId) async {
    List<ModelZakatPaid> zakatPaidList = <ModelZakatPaid>[];
    var zakatPaymentsSnapShot =
        await zakatPaymentsCollection.where("userId", isEqualTo: userId).get();
    zakatPaymentsSnapShot.docs.forEach((map) {
      ModelZakatPaid modelZakatPaid = new ModelZakatPaid(
        map.id,
          map['title'],
          map['startDate'],
          map['endDate'],
          map['amount'],
          map['paymentDate'] ,
          map['note'] ,
          map['userId']
      );
      zakatPaidList.add(modelZakatPaid);
      print(map.data());
    });
    return zakatPaidList; // finally re
  }
  Future<int> updateZakatPaid(ModelZakatPaid zakat) async {
    var result = await zakatPaymentsCollection
        .doc(zakat.zakatPaymentId.toString())
        .update(zakat.toMap())
        .then((value) => print("zakatPayment Updated"))
        .catchError((error) => print("Failed to update zakatPayment: $error"));
    return 1;
  }

  Future<int> insertZakatPaid(ModelZakatPaid zakat) async {
    var result = await zakatPaymentsCollection
        .add(zakat.toMap())
        .then((value) => print("zakatPayment Inserted"))
        .catchError((error) => print("Failed to insert zakatPayment: $error"));
    return 1;
  }

  Future<int> deleteZakatPaid(String zakatPaymentId) async {
    int result=0;
    await zakatPaymentsCollection
        .doc(zakatPaymentId)
        .delete()
        .then((value) => print("zakatPayment deleted ${result=1}"))
        .catchError((error) => print("Failed to delete zakatPayment: $error"));
    return result;
  }

  Future<int> getZakatPaidCount(String userId) async {
    var zakatPaymentSnapShot =
        await zakatPaymentsCollection.where("userId", isEqualTo: userId).get();
    int result = zakatPaymentSnapShot.docs.length;
    return result;
  }
} // End of Class
