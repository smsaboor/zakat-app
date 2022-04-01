/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zakat_app/model/model_cash.dart';
import 'package:zakat_app/model/model_metal.dart';
import 'package:zakat_app/model/model_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zakat_app/model/model_cash.dart';
import 'package:zakat_app/model/model_metal.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/model/model_user.dart';
import 'package:intl/src/intl/date_format.dart';

class ServicesUsers{
  ServicesUsers();
  static var firebaseUser;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ModelSetting? setting;

  Future<void> addUser(String? uid, String? phone, String? finalPhotoURL,settings) async {
    await _firestore.collection('user').doc(uid).set({
      'name': ' ',
      'email': ' ',
      'phone': phone,
      'password': '12345',
      'age': '0',
      'city': ' ',
      'pin': ' ',
      'registrationDate': DateTime.now().toString(),
      'isPaid': false,
      'paymentDate': '',
      'photoUrl': finalPhotoURL,
      'familyId': ''
    }).then((documentReference) {
      print('Saboor check uid');
    }).catchError((e) {
      print('saboor check addUser exception: ' + e);
    });
  }

  void getUser(String? uid) async {
    print('getUser------------------------------- ${uid}');
    firebaseUser = await _firestore.collection('user').doc(uid).get().then((documentReference) {
      print('Saboor check documentReference.id ' + documentReference.id);
    }).catchError((e) {
      print('saboor check getUser exception: ' + e);
    });
  }
  // Future<void> addUser() async {
  //   print('addUser------------------------------- }');
  //   var id = Uuid();
  //   String categoryId = id.v1();
  //   _firestore.collection('news').doc(categoryId).set({'category': 'saboor'});
  // }
  Future<void> editUser(uid,phone,finalPhotoURL) async {
    await _firestore.collection("user").doc(uid).update({
      'name': ' ',
      'email': ' ',
      'phone': phone,
      'password': false,
      'age': false,
      'city': ' ',
      'pin': ' ',
      'registrationDate': DateTime.now().toString(),
      'isPaid': false,
      'paymentDate': '',
      'photoUrl': finalPhotoURL,
      'familyId': ''
    }).then((documentReference) {
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> deleteUser(uid) async {
    _firestore.collection("user").doc(uid).delete();
  }


  // Future<void> getUserData(uid) async {
  //   final ModelUser usr= ModelUser();
  //   var user = await FirebaseFirestore.instance
  //       .collection('user')
  //       .doc(uid)
  //       .get();
  //     if (user.data != null) {
  //       usr.toMap(user.data().);
  //     }
  // }

  // deleteFromFirestore(val) async {
  //   final String key =
  //   val['url'].toString().replaceAll('/', '').replaceAll('.', '');
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(await getMyUID())
  //       .update({key: FieldValue.delete()});
  // }

  // Future<List<ModelCash>> getCashData(String uid) async {
  //   final ModelCash nm = ModelCash();
  //   List<ModelCash> list = <ModelCash>[];
  //   var cash = await FirebaseFirestore.instance
  //       .collection("user")
  //       .doc(uid)
  //       .get();
  //   if (cash.data != null) {
  //     for (int i = 0; i < cash.data()?.length; i++)
  //       list.add(ModelCash.fromMapObject(cash.data().values.toList()[i]));
  //   }
  //   nm.articles = list;
  //   return nm;
  // }

}*/
