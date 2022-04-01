
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zakat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:zakat_app/cubits/auth_cubit/auth_state.dart';
import 'package:zakat_app/verify_phone_number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zakat_app/home_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return new ListView(
      children: <Widget>[
        Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0x22ff3a5a), Color(0x22fe494d)])),
              ),
            ),
            ClipPath(
              child: Container(
                child: Column(),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0x44ff3a5a), Color(0x44fe494d)])),
              ),
            ),
            ClipPath(
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Sadaqah Manager",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 30),
                    ),
                  ],
                ),
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Color(0xfffc4305), Color(0xEF5604FF)])),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 110,
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  color: Color(0xffff5d5f)),
              child: FlatButton.icon(
                  icon: Icon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Sign in with your Google account",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: (){
                  }),
            )),
        SizedBox(
          height: 60,
        ),
        TextField(
          controller: phoneController,
          cursorColor: Colors.deepOrange,
          keyboardType: TextInputType.number,
          maxLength: 10,
          decoration: InputDecoration(
              hintText: "Phone Number",
              counterText: "",
              suffixText:"Phone",
              suffixStyle: const TextStyle(color: Colors.red,fontSize: 14.0),
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.phone_android,
                  color: Colors.red,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
        SizedBox(
          height: 20,
        ),
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if(state is AuthCodeSentState) {
              Navigator.push(context, CupertinoPageRoute(
                  builder: (context) => VerifyPhoneNumberScreen()
              ));
            }
          },
          builder: (context, state) {
            if(state is AuthLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return SizedBox(
              width: 300,
              child: CupertinoButton(
                onPressed: () {
                  String phoneNumber = "+91" + phoneController.text;
                  BlocProvider.of<AuthCubit>(context).sendOTP(phoneNumber);
                },
                color: Colors.deepOrange,
                child: Text("Sign In"),
              ),
            );

          },
        ),
      ],
    );
  }
}