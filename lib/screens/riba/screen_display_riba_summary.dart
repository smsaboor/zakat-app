import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_app/helper/firebase_database.dart';
import 'package:zakat_app/model/model_riba.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:zakat_app/helper/database_helper.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/util/country.dart';
import 'package:zakat_app/util/country_pickers.dart';
import 'package:zakat_app/util/utils/utils.dart';

class DisplayRibaSummary extends StatefulWidget {
  final appBarTitle;
  final page;
  String userId;
  DisplayRibaSummary(this.appBarTitle, this.page, this.userId);
  @override
  State<StatefulWidget> createState() {
    return DisplayRibaSummaryState(this.appBarTitle, this.page, this.userId);
  }
}

class DisplayRibaSummaryState extends State<DisplayRibaSummary> {
  String appBarTitle;
  String page;
  String userId;
  DisplayRibaSummaryState(this.appBarTitle, this.page, this.userId);
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');
  final path = getDatabasesPath();
  var cash;
  ModelSetting? settings;
  FirebaseHelper firebaseHelper = FirebaseHelper();
  var id = Uuid();

  List<ModelRiba> ribaList=[];
  int count = 0;
  double totalRibaReceived = 0;
  double totalRibaPaid = 0;
  double totalRibaBalance = 0;

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
    if (ribaList == null) {
      ribaList = <ModelRiba>[];
      updateListRibaReceived(userId);
      updateListRibaPaid(userId);
      getRibaTotal();
      updateListViewSetting(this.userId);
    }

    return Column(
      children: <Widget>[
        totalRibaBalance < 0
            ? Card(
                color: Colors.white,
                borderOnForeground: true,
                child: ListTile(
                  title: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Icon(
                        Icons.warning,
                        size: 32.0,
                        color: Colors.red[600],
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                      ),
                      Expanded(
                        child: Text(
                            'There is inconsistency in your data entries. Please review to get accurate results',
                            style: new TextStyle(
                                color: Colors.red[600], fontSize: 14.0)),
                      ),
                    ]),
                  ]),
                ),
              )
            : SizedBox(),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Icon(
                Icons.account_balance_wallet,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Received',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalRibaReceived.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol!,
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
              Icon(
                Icons.business,
                size: 32.0,
                color: Colors.grey,
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Expanded(
                child: Text('Total Payments',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalRibaPaid.abs().toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol!,
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Row(children: <Widget>[
              new Padding(
                padding: const EdgeInsets.only(left: 50.0),
              ),
              Expanded(
                child: Text('Total Payable Riba',
                    style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              ),
              new Padding(
                padding: const EdgeInsets.only(left: 10.0),
              ),
              Text(totalRibaBalance.toStringAsFixed(2),
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
              new Padding(
                padding: const EdgeInsets.only(left: 5.0),
              ),
              Text(_selectedDialogCountry.currencySymbol!,
                  style: new TextStyle(color: Colors.grey, fontSize: 18.0)),
            ]),
          ),
        ),
      ],
    );
  }

  // functions for Cash.................................................
  void updateListRibaReceived(String userId) {
      Future<List<ModelRiba>> loanListFuture =
          firebaseHelper.getRibaListReceived(userId);
      loanListFuture.then((ribaList) {
        setState(() {
          this.ribaList = ribaList;
          this.count = ribaList.length;
          totalRibaReceived = getRibaTotal();
          totalRibaBalance = totalRibaReceived + totalRibaPaid;
        });
      });
  }

  double getRibaTotal() {
    double totalAmountRiba = 0;
    for (int i = 0; i <= ribaList.length - 1; i++) {
      totalAmountRiba = totalAmountRiba + this.ribaList[i].amount;
    }
    return totalAmountRiba;
  }

  void updateListRibaPaid(String userId) {
      Future<List<ModelRiba>> ribaListFuture =
          firebaseHelper.getRibaListPaid(userId);
      ribaListFuture.then((ribaList) {
        setState(() {
          this.ribaList = ribaList;
          this.count = ribaList.length;
          this.totalRibaPaid = getRibaTotal();
          totalRibaBalance = totalRibaReceived + totalRibaPaid;
        });
      });
  }

  void updateListViewSetting(String finaluserid) {
      Future<ModelSetting?> settingListFuture =
          firebaseHelper.getSettingList(finaluserid);
      settingListFuture.then((settingList) {
        setState(() {
          this.settings = settingList;
          _selectedDialogCountry =
              CountryPickerUtils.getCountryByIsoCode('${settingList!.country}');
        });
      });
  }
}
