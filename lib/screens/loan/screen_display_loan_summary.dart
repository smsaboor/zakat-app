import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_app/helper/firebase_database.dart';
import 'package:zakat_app/model/model_loan.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:zakat_app/helper/database_helper.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/util/country.dart';
import 'package:zakat_app/util/utils/utils.dart';
import 'package:zakat_app/util/country_pickers.dart';

class DisplayLoanSummary extends StatefulWidget {
  final appBarTitle;
  final page;
  String userId;
  DisplayLoanSummary(this.appBarTitle, this.page, this.userId);
  @override
  State<StatefulWidget> createState() {
    return DisplayLoanSummaryState(this.appBarTitle, this.page, this.userId);
  }
}

class DisplayLoanSummaryState extends State<DisplayLoanSummary> {
  ModelSetting? settings;
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');
  String appBarTitle;
  String page;
  var cash;
  String userId;
  final path = getDatabasesPath();
  DisplayLoanSummaryState(this.appBarTitle, this.page, this.userId);

  FirebaseHelper firebaseHelper = FirebaseHelper();
  var id = Uuid();

  List<ModelLoan> loanList=[];
  int totalborrow = 0;
  int totallendsecure = 0;
  int totallendinsecure = 0;
  int AllTotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loanList.isEmpty) {
      loanList = <ModelLoan>[];
      updateListViewBorrow('loan', 'borrow', userId);
      updateListViewLendSecure('loan', 'lendsecure', userId);
      updateListViewLendInsecure('loan', 'lendinsecure', userId);
      getAllTotal();
      updateListViewSetting(this.userId);
    }

    return Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),

              Expanded(
                child: Text('Total Debt Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalborrow.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${_selectedDialogCountry.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Expanded(
                child: Text('Total  LENT\n(SECURE) Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totallendsecure.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${_selectedDialogCountry.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Expanded(
                child: Text('Total  LENT\n(INSECURE) Balance',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totallendinsecure.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              Text(' ${_selectedDialogCountry.currencySymbol}',
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
      ],
    );
  }

  // functions for Cash.................................................
  void updateListViewBorrow(String table, String type, String userId) {
      Future<List<ModelLoan>> loanListFuture =
          firebaseHelper.getLoanList(table, type, userId);
      loanListFuture.then((LoanList) {
        if (this.mounted) {
          setState(() {
            this.loanList = LoanList;
            totalborrow = getloanTotal();
          });
        }
      });
  }

  int getloanTotal() {
    double totalAmountborrow = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      totalAmountborrow = totalAmountborrow + this.loanList[i].amount;
    }
    return totalAmountborrow.round();
  }

  void updateListViewLendSecure(String table, String type, String userId) {
      Future<List<ModelLoan>> loanListFuture =
          firebaseHelper.getLoanList(table, type, userId);
      loanListFuture.then((loanList) {
        if (this.mounted) {
          setState(() {
            this.loanList = loanList;
            totallendsecure = getloanTotal();
          });
        }
      });
  }

  // functions for metal.................................................
  void updateListViewLendInsecure(String table, String type, String userid) {
      Future<List<ModelLoan>> cashListFuture =
          firebaseHelper.getLoanList(table, type, userid);
      cashListFuture.then((lendinsecureList) {
        if (this.mounted) {
          setState(() {
            this.loanList = lendinsecureList;
            totallendinsecure = getloanTotal();
            this.AllTotal = getAllTotal();
          });
        }
      });

  }

  int getAllTotal() {
    int allTotal = 0;
    allTotal = totalborrow + totallendsecure + totallendinsecure;
    return allTotal;
  }

  void updateListViewSetting(String finaluserid) {
      Future<ModelSetting?> settingListFuture =
          firebaseHelper.getSettingList(finaluserid);
      settingListFuture.then((settingList) {
        if (this.mounted) {
          setState(() {
            this.settings = settingList;
            _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode(
                '${settingList!.country}');
          });
        }
      });
  }
}
