// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:zakat_app/model/model_cash.dart';
// import 'package:zakat_app/model/model_metal.dart';
// import 'package:zakat_app/model/model_setting.dart';
// import 'package:zakat_app/model/model_user.dart';
// import 'package:intl/src/intl/date_format.dart';
//
// class ServicesSetting{
//   ServicesSetting();
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   ModelSetting? settings;
//
//   Future<void> addSetting(String? uid,ModelSetting setting) async {
//     await _firestore.collection('setting').doc(uid).set({
//       'country': setting.country.toString(),
//       'currency': setting.currency.toString(),
//       'nisab': setting.nisab,
//       'startDate': setting.startDate,
//       'endDate': setting.endDate,
//       'goldRate18C': setting.goldRate18C,
//       'goldRate20C': setting.goldRate20C,
//       'goldRate22C': setting.goldRate22C,
//       'goldRate24C': setting.goldRate24C,
//       'silverRate18C': setting.silverRate18C,
//       'silverRate20C': setting.silverRate20C,
//       'silverRate22C': setting.silverRate22C,
//       'silverRate24C': setting.silverRate24C,
//       'userId': uid,
//     }).then((documentReference) {
//       print('Saboor check uid');
//     }).catchError((e) {
//       print('saboor check addUser exception: ' + e);
//     });
//   }
//
//   Future<String?> getSetting(String? uid) async {
//     var setting = await _firestore.collection('setting').doc(uid).get().then((documentReference) {
//       print('Saboor check getSetting documentReference.id ' + documentReference.id);
//       print('Saboor check getSetting var setting ' + documentReference.data().toString());
//     }).catchError((e) {
//       print('saboor check getUser exception: ' + e);
//     });
//   }
//
//   Future<void> editUser(uid,phone,finalPhotoURL) async {
//     await _firestore.collection("user").doc(uid).update({
//       'name': ' ',
//       'email': ' ',
//       'phone': phone,
//       'password': false,
//       'age': false,
//       'city': ' ',
//       'pin': ' ',
//       'registrationDate': DateTime.now().toString(),
//       'isPaid': false,
//       'paymentDate': '',
//       'photoUrl': finalPhotoURL,
//       'familyId': ''
//     }).then((documentReference) {
//     }).catchError((e) {
//       print(e);
//     });
//   }
//
//
//   Future<void> deleteUser(uid) async {
//     _firestore.collection("user").doc(uid).delete();
//   }
//
//
// // Future<void> getUserData(uid) async {
// //   final ModelUser usr= ModelUser();
// //   var user = await FirebaseFirestore.instance
// //       .collection('user')
// //       .doc(uid)
// //       .get();
// //     if (user.data != null) {
// //       usr.toMap(user.data().);
// //     }
// // }
//
// // deleteFromFirestore(val) async {
// //   final String key =
// //   val['url'].toString().replaceAll('/', '').replaceAll('.', '');
// //   FirebaseFirestore.instance
// //       .collection('users')
// //       .doc(await getMyUID())
// //       .update({key: FieldValue.delete()});
// // }
//
// // Future<List<ModelCash>> getCashData(String uid) async {
// //   final ModelCash nm = ModelCash();
// //   List<ModelCash> list = <ModelCash>[];
// //   var cash = await FirebaseFirestore.instance
// //       .collection("user")
// //       .doc(uid)
// //       .get();
// //   if (cash.data != null) {
// //     for (int i = 0; i < cash.data()?.length; i++)
// //       list.add(ModelCash.fromMapObject(cash.data().values.toList()[i]));
// //   }
// //   nm.articles = list;
// //   return nm;
// // }
//
// }