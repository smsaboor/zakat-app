import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zakat_app/cubits/auth_cubit/auth_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zakat_app/model/model_user.dart';
import 'package:zakat_app/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/util/country_pickers.dart';

class AuthCubit extends Cubit<AuthState> {


  ModelUser? user;
  DataHelper? databaseHelper= DataHelper();
  static String? emailOrPhone;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super( AuthInitialState() ) {
    User? currentUser = _auth.currentUser;
    if(currentUser != null) {
      emit( AuthLoggedInState(currentUser,currentUser.phoneNumber) );
    }
    else {
      emit( AuthLoggedOutState() );
    }
  }

  String? _verificationId;

  void sendOTP(String phoneNumber) async {
    emit( AuthLoadingState() );
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        _verificationId = verificationId;
        emit( AuthCodeSentState() );
      },
      verificationCompleted: (phoneAuthCredential) {
        signInWithPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit( AuthErrorState(error.message.toString()) );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    emit( AuthLoadingState() );
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: _verificationId!, smsCode: otp);
    signInWithPhone(credential);
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      if(userCredential.user != null) {
        emit( AuthLoggedInState(userCredential.user!,userCredential.user!.phoneNumber) );
      }
    } on FirebaseAuthException catch(ex) {
      emit( AuthErrorState(ex.message.toString()) );
    }
  }

  void logOut() async {
    await _auth.signOut();
    emit( AuthLoggedOutState() );
  }

// Future<ModelUser?> saveUser(UserCredential userDetails) async {
//    Future<ModelUser?>? userListFuture = (await databaseHelper?.getUserByEmailOrPhone(userDetails.user!.phoneNumber.toString(),false, 'cubit saveuser1')) as Future<ModelUser?>?;
//    userListFuture?.then((user) async {
//      if (user != null) {
//        debugPrint('111111111111111111111111111111111 % user != null');
//        ModelUser newUser = ModelUser(userDetails.user!.phoneNumber.toString(), userDetails.user!.phoneNumber.toString(),
//          '+919455106497',
//          "12345", DateTime.now().toString(), 'false', 0, '', '', 0, 0,
//          userDetails.user?.photoURL ?? 'https://upload.wikimedia.org/wikipedia/commons/archive/3/3a/20090210002958%21Cat03.jpg',);
//        var result = await databaseHelper?.updateUser(newUser);
//        debugPrint('111111111111111111111111111111111 % updateUser = ${result}');
//      } else {
//        ModelUser newUser = ModelUser(userDetails.user!.phoneNumber.toString(), userDetails.user!.phoneNumber.toString(),
//          userDetails.user!.phoneNumber.toString(),
//            "12345", DateTime.now().toString(), 'false', 0, '', '', 0, 0,
//          userDetails.user?.photoURL ?? 'https://upload.wikimedia.org/wikipedia/commons/archive/3/3a/20090210002958%21Cat03.jpg',);
//        var result = await databaseHelper?.insertUser(newUser);
//        debugPrint('111111111111111111111111111111111 % insertUser = ${result}');
//        Future<ModelUser?>? userFuture = (await databaseHelper?.getUserByEmailOrPhone(userDetails.user!.phoneNumber.toString(),false,"cubit saveuser2")) as Future<ModelUser?>?;
//        userFuture?.then((user) async {
//          ModelSetting? setting;
//          setting?.userId = user?.userId ?? 0;
//          setting?.country = CountryPickerUtils.getCountryByIsoCode('IN').isoCode ?? '';
//          setting?.currency = CountryPickerUtils.getCountryByIsoCode('IN').currencyCode ?? '';
//          setting?.startDate = '${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(new Duration(days: 354)))}';
//          setting?.endDate = '${DateFormat("yyyy-MM-dd").format(DateTime.now())}';
//          setting?.goldRate18C=0.0;setting?.goldRate20C=0.0;setting?.goldRate22C=0.0;setting?.goldRate24C=0.0;
//          setting?.silverRate18C=0.0;setting?.silverRate20C=0.0;setting?.silverRate22C=0.0;setting?.silverRate24C=0.0;
//          setting?.nisab=0.0;
//          int result = await databaseHelper?.insertSetting(setting!) ?? 0;
//          debugPrint("Inert Setting aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa result ${result}");
//        });
//      }
//    });
//  }
}
