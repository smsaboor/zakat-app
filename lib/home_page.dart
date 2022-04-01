import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:zakat_app/helper/database_helper.dart';
import 'package:zakat_app/helper/firebase_database.dart';
import 'package:zakat_app/helper/general_helper.dart';
import 'package:zakat_app/model/model_cash.dart';
import 'package:zakat_app/model/model_loan.dart';
import 'package:zakat_app/model/model_metal.dart';
import 'package:zakat_app/model/model_riba.dart';
import 'package:zakat_app/model/model_setting.dart';
import 'package:zakat_app/model/model_user.dart';
import 'package:zakat_app/model/model_zakat_paid.dart';
import 'package:zakat_app/dto/metal_rates.dart';
import 'package:zakat_app/model/user.dart';
import 'package:zakat_app/profile.dart';
import 'package:zakat_app/screens/assets/assets.dart';
import 'package:zakat_app/screens/setting/screen_settings.dart';
import 'package:zakat_app/screens/zakat/screen_zakat.dart';
import 'package:zakat_app/login.dart';
import 'package:zakat_app/screens/riba/riba.dart';
import 'package:zakat_app/screens/loan/loan.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakat_app/services/services_setting.dart';
import 'package:zakat_app/util/country.dart';
import 'package:zakat_app/util/country_pickers.dart';
import 'package:zakat_app/util/utils/utils.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:zakat_app/cubits/auth_cubit/auth_cubit.dart';
import 'package:zakat_app/cubits/auth_cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zakat_app/services/services_user.dart';


class HomePage extends StatefulWidget {
  HomePage();
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  HomePageState();

  static const APP_STORE_URL = 'https://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftwareUpdate?id=YOUR-APP-ID&mt=8';
  static const PLAY_STORE_URL = 'https://play.google.com/store/apps/details?id=com.microanalyticals.sadaqah_manager';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String? email;
  String? finalUserName;
  String? finalUserID;

  ModelUser? user;

  String? currencyCode='IN';
  String? finalPhotoURL='https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg';


  String? startDate = DateTime.now().toString();
  String? endDate = DateTime.now().toString();
  double? nisab = 50000.0;



  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('IN');
  FirebaseHelper firebaseHelper = FirebaseHelper();
  var id = Uuid();

  var settingListFuture ;

  ModelSetting settings=ModelSetting('', '', '', 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, '');

  List<ModelCash> cashList= <ModelCash>[];
  List<ModelMetal> goldList= <ModelMetal>[];
  List<ModelMetal> silverList= <ModelMetal>[];
  List<ModelUser> userList= <ModelUser>[];
  List<ModelLoan> loanList= <ModelLoan>[];
  List<ModelRiba> ribaList= <ModelRiba>[];
  List<ModelZakatPaid> zakatPaymentList=<ModelZakatPaid>[];

  int countGA = 0;
  //---------Riba--------------
  double totalRibaBalance = 0;
  double totalRibaPaid = 0.0;
  double totalRibaAmount = 0;

  //---------Asset-------------
  double totalCashInHand = 0;
  double totalCashInBank = 0;
  double totalGold = 0;
  double totalSilver = 0;
  double totalAssetAmount = 0;

//----------Loan---------------
  double totalBorrow = 0;
  double totalLendSecure = 0;
  double totalLendInsecure = 0;
  double totalLoanAmount = 0;

//----------Zakat---------------
  double totalZakatPayable = 0;
  double totalZakatPaid = 0;
  double totalZakatBalance = 0;

  Position? _currentPosition;
  String _currentAddress=' ';


  void getFirebaseCredential() async{
    debugPrint(" getFirebaseCredential1 ------------}");
    int result = await firebaseHelper.checkUserExist(_auth.currentUser?.uid.toString() ?? '');
    debugPrint(" 1111111111111111111111111 ------------${result}");
    if(result==0){
      debugPrint("222222222222222222222222222222 ------------${result}");
      // firebaseHelper.insertUser(_auth.currentUser?.uid.toString(),_auth.currentUser?.phoneNumber.toString(),finalPhotoURL,settings);
      firebaseHelper.insertUser(ModelUser(_auth.currentUser?.uid.toString(), '', '', _auth.currentUser?.phoneNumber.toString(), '', DateTime.now().toString(), 'false', 0, '', '', 0, '', finalPhotoURL));
      // firebaseHelper.insertSetting(_auth.currentUser?.uid.toString(),settingDefault);
      firebaseHelper.insertSetting(ModelSetting('', 'IN', 'Indian Rupee', 0, '', '', 0, 0, 0, 0, 0, 0, 0, 0, _auth.currentUser?.uid.toString()));
    }
    else{
      Future<ModelUser?> userListFuture = firebaseHelper.getUser(_auth.currentUser?.uid.toString() ?? '');
      debugPrint(" 33------------${userListFuture.then((value) => print(value))}");
      userListFuture.then((user) {
        setState(() {
          this.finalUserID = user?.userId;
          this.email=user?.email;
          this.finalPhotoURL=user?.photoUrl;
          this.finalUserName=user?.name;
          debugPrint(" 33333333333333333333333------------${user?.userId}");
          debugPrint(" 33333333333333333333333------------${user?.userId}");
        });
      });
      Future<ModelSetting?> settingListFuture = firebaseHelper.getSettingList(_auth.currentUser?.uid.toString() ?? '');
      settingListFuture.then((setting){
        this.settings=setting!;
      } );
    }
  }

  @override
  void initState() {
    super.initState();
    finalUserID= _auth.currentUser?.uid.toString() ?? '';
    _getCurrentLocation();
    getFirebaseCredential();
    try {
      versionCheck(context);
    } catch (e) {
      print(e);
    }
    zakatPaymentList = <ModelZakatPaid>[];
    setState(() {
    });
  }


  _getRequests() {
    updateListViewSetting(this.finalUserID);
  }

  @override
  Widget build(BuildContext context) {
    if (settings == null) {
      _getRequests();
    }

    if (finalUserName == null) {
      finalUserName = email;
    }

    return new Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('title'.tr()),
        actions: <Widget>[
          IconButton(
            icon: CountryPickerUtils.getDefaultFlagImage(
                _selectedDialogCountry),
            onPressed: () {
              debugPrint("_selectedDialogCountry_selectedDialogCountry_selectedDialogCountry${

                  CountryPickerUtils.getDefaultFlagImage(
                      _selectedDialogCountry)
              }");
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 25.0,
              color: Colors.white,
            ),
            onPressed: () {
              //updateListViewSetting(userId);
              navigateToSettings(
                  ModelSetting('','','',0,'','',0,0,0,0,0,0,0,0,this.finalUserID), 'settings'.tr(), finalUserID);
            },
          ),
        ],
      ),
      body: getListView(),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: finalPhotoURL != null
                        ? NetworkImage(finalPhotoURL!)
                        : null,
                    radius: 25.0,
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Name: $finalUserName",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14.0),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    "Email: $email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14.0),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            ),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.account_balance),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('assets'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute(
                        builder: (_) => new UserProfile()),
                  )
                      .then((val) => {_getRequests()});
                }),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.account_balance),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('assets'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute(
                        builder: (_) => new Assets(
                          'assets'.tr(),
                          'assets'.tr(),
                          finalUserID,
                          settings,
                        )),
                  )
                      .then((val) => {_getRequests()});
                }),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.account_balance_wallet),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('loan'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute(
                        builder: (_) =>
                        new Loan('loan'.tr(), 'loan', finalUserID ?? '')),
                  )
                      .then((val) => {_getRequests()});
                }),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.cancel),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('riba'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute(
                        builder: (_) =>
                        new Riba('riba'.tr(), 'riba', finalUserID)),
                  )
                      .then((val) => {_getRequests()});
                }),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.favorite),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('zakat'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.of(context)
                      .push(
                    new MaterialPageRoute(
                        builder: (_) => new Zakat(
                            ModelZakatPaid(
                                '','', '', '', '', 0.0, '', this.finalUserID),
                            'zakat'.tr(),
                            'Zakat',
                            this.finalUserID ?? '',
                            this.settings)),
                  )
                      .then((val) => {_getRequests()});
                }),
            ListTile(
                title: Row(
                  children: <Widget>[
                    Icon(Icons.build),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text('settings'.tr()),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pop(context, true);
                  // Update the state of the ap  .then((val)=>{_getRequests()})
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (_) => new AddSetting(
                            ModelSetting('','','',0,'','',0,0,0,0,0,0,0,0,this.finalUserID),
                            'settings'.tr(),
                            finalUserID)),
                  ).then((val) {
                    setState(() {
                      _getRequests();
                    });
                  });
                }),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.share),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('share'.tr()),
                  )
                ],
              ),
              onTap: () {
                Share.share(
                    'Install and manage your Sadaqah & Zakat https://play.google.com/store/apps/details?id=com.microanalyticals.sadaqah_manager&hl=en_IN ',
                    subject: 'Manage your zakat and sadaqah efficiently!');
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(Icons.lock_open),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text('logout'.tr()),
                  )
                ],
              ),
              onTap: () async {
              },
            ),
            Container(
              child: Center(
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if(state is AuthLoggedOutState) {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context, CupertinoPageRoute(
                          builder: (context) => LoginScreen()
                      ));
                    }
                  },
                  builder: (context, state) {
                    return CupertinoButton(
                      onPressed: () {
                        BlocProvider.of<AuthCubit>(context).logOut();
                      },
                      child: Text("Log Out"),
                    );
                  },
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getListView() {
    final assetData = [
      new LinearData(
          'Cash     ',
          totalAssetAmount == 0
              ? 0
              : double.parse(((totalCashInHand / totalAssetAmount) * 100)
              .toStringAsFixed(2))),
      new LinearData(
          'Bank',
          totalAssetAmount == 0
              ? 0
              : double.parse(((totalCashInBank / totalAssetAmount) * 100)
              .toStringAsFixed(2))),
      new LinearData(
          'Gold',
          totalAssetAmount == 0
              ? 0
              : double.parse(
              ((totalGold / totalAssetAmount) * 100).toStringAsFixed(2))),
      new LinearData(
          'Silver',
          totalAssetAmount == 0
              ? 0
              : double.parse(
              ((totalSilver / totalAssetAmount) * 100).toStringAsFixed(2))),
    ];
    final goldenColor = charts.Color.fromHex(code: '#D4AF37');
    final silverColor = charts.Color.fromHex(code: '#aaa9ad');
    List<charts.Series<LinearData, String>> assetSeriesList = [
      new charts.Series<LinearData, String>(
          id: 'Assets',
          domainFn: (LinearData data, _) => data.type,
          measureFn: (LinearData data, _) => data.amount,
          colorFn: (LinearData data, _) {
            switch (data.type) {
              case 'Cash     ':
                {
                  return charts.MaterialPalette.green.shadeDefault;
                }
              case 'Bank':
                {
                  return charts.MaterialPalette.blue.shadeDefault;
                }
              case 'Gold':
                {
                  return goldenColor;
                }
              case 'Silver':
                {
                  return silverColor;
                }
              default:
                {
                  return charts.MaterialPalette.blue.shadeDefault;
                }
            }
          },
          data: assetData,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (LinearData data, _) =>
          '${data.amount.toString()} %')
    ];

    final loanData = [
      new LinearData('Borrow', totalBorrow),
      new LinearData('Lent (S)', totalLendSecure),
      new LinearData('Lent (I)', totalLendInsecure),
    ];
    List<charts.Series<LinearData, String>> loanSeriesList = [
      new charts.Series<LinearData, String>(
          id: 'Loan',
          domainFn: (LinearData data, _) => data.type,
          measureFn: (LinearData data, _) => data.amount,
          colorFn: (LinearData data, _) {
            switch (data.type) {
              case 'Borrow':
                {
                  return charts.MaterialPalette.red.makeShades(3).elementAt(1);
                }
              case 'Lent (I)':
                {
                  return charts.MaterialPalette.red.shadeDefault;
                }
              case 'Lent (S)':
                {
                  return charts.MaterialPalette.green.shadeDefault;
                }
              default:
                {
                  return charts.MaterialPalette.green.shadeDefault;
                }
            }
          },
          data: loanData,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (LinearData data, _) =>
          '${data.amount.round()} ${_selectedDialogCountry.currencySymbol}')
    ];

    final ribaData = [
      new LinearData(
          'Unpaid',
          totalRibaAmount == 0
              ? 0
              : double.parse(((totalRibaBalance / totalRibaAmount) * 100)
              .toStringAsFixed(2))),
      new LinearData(
          'Paid',
          totalRibaAmount == 0
              ? 0
              : double.parse(((totalRibaPaid.abs() / totalRibaAmount) * 100)
              .toStringAsFixed(2))),
    ];
    List<charts.Series<LinearData, String>> ribaSeriesList = [
      new charts.Series<LinearData, String>(
          id: 'Riba',
          domainFn: (LinearData data, _) => data.type,
          measureFn: (LinearData data, _) => data.amount,
          colorFn: (LinearData data, _) {
            switch (data.type) {
              case 'Unpaid':
                {
                  return charts.MaterialPalette.red.shadeDefault;
                }
              case 'Paid':
                {
                  return charts.MaterialPalette.green.shadeDefault;
                }
              default:
                {
                  return charts.MaterialPalette.blue.shadeDefault;
                }
            }
          },
          data: ribaData,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (LinearData data, _) =>
          '${data.amount.toString()} %')
    ];

    final zakatData = [
      new LinearData(
          'Unpaid',
          totalZakatPayable == 0
              ? 0
              : double.parse((((totalZakatBalance < 0 ? 0 : totalZakatBalance) /
              totalZakatPayable) *
              100)
              .toStringAsFixed(2))),
      new LinearData(
          'Paid',
          totalZakatPayable == 0
              ? 0
              : double.parse((((totalZakatPaid > totalZakatPayable
              ? totalZakatPayable
              : totalZakatPaid) /
              totalZakatPayable) *
              100)
              .toStringAsFixed(2))),
    ];
    List<charts.Series<LinearData, String>> zakatSeriesList = [
      new charts.Series<LinearData, String>(
          id: 'Zakat',
          domainFn: (LinearData data, _) => data.type,
          measureFn: (LinearData data, _) => data.amount,
          colorFn: (LinearData data, _) {
            switch (data.type) {
              case 'Unpaid':
                {
                  return charts.MaterialPalette.red.shadeDefault;
                }
              case 'Paid':
                {
                  return charts.MaterialPalette.green.shadeDefault;
                }
              default:
                {
                  return charts.MaterialPalette.blue.shadeDefault;
                }
            }
          },
          data: zakatData,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (LinearData data, _) =>
          '${data.amount.toString()} %')
    ];

    return FutureBuilder<ModelSetting>(
      future: settingListFuture, // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<ModelSetting> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          return mainScreen(
              assetSeriesList, loanSeriesList, ribaSeriesList, zakatSeriesList);
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Loading ...'),
            )
          ];
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
    );
  }

  Widget mainScreen(
      List<charts.Series<LinearData, String>> assetSeriesList,
      List<charts.Series<LinearData, String>> loanSeriesList,
      List<charts.Series<LinearData, String>> ribaSeriesList,
      List<charts.Series<LinearData, String>> zakatSeriesList) {
    return ListView(
      children: <Widget>[
        new GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(
              new MaterialPageRoute(
                  builder: (_) => new Assets(
                    'assets'.tr(),
                    'assets',
                    finalUserID,
                    settings,
                  )),
            )
                .then((val) => {_getRequests()});
          },
          child: Container(
            width: 200,
            height: 200.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: totalAssetAmount == 0
                    ? <Widget>[
                  Text(
                    'No assets data available.',
                    style: TextStyle(fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                            builder: (_) => new Assets(
                              'assets'.tr(),
                              'assets',
                              finalUserID,
                              settings,
                            )),
                      )
                          .then((val) => {_getRequests()});
                    },
                    child: new Text("Add"),
                  ),
                ]
                    : <Widget>[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'assets'.tr(),
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    width: 310.0,
                    child: charts.PieChart(
                      assetSeriesList,
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator()
                          ]),
                      behaviors: [
                        new charts.DatumLegend(
                          position: charts.BehaviorPosition.end,
                        ),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        new GestureDetector(
          onTap: () {
            // Change the color of the container beneath
            Navigator.of(context)
                .push(
              new MaterialPageRoute(
                  builder: (_) => new Loan('Loan', 'Loan', finalUserID ?? '')),
            )
                .then((val) => {_getRequests()});
          },
          child: Container(
            height: 200.0,
            width: 200.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: totalLendInsecure == 0 &&
                    totalLendSecure == 0 &&
                    totalBorrow == 0
                    ? <Widget>[
                  Text(
                    'No loan data available.',
                    style: TextStyle(fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                            builder: (_) =>
                            new Loan('Loan', 'Loan', finalUserID ?? '')),
                      )
                          .then((val) => {_getRequests()});
                    },
                    child: new Text("Add"),
                  ),
                ]
                    : <Widget>[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'Loan',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    width: 310.0,
                    child: charts.BarChart(
                      loanSeriesList,
                      vertical: false,
                      barRendererDecorator:
                      new charts.BarLabelDecorator<String>(),
                      // Hide domain axis.
                      domainAxis: new charts.OrdinalAxisSpec(
                          renderSpec: new charts.NoneRenderSpec()),
                      behaviors: [
                        new charts.DatumLegend(
                          position: charts.BehaviorPosition.end,
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        new GestureDetector(
          onTap: () {
            // Change the color of the container beneath
            Navigator.of(context)
                .push(
              new MaterialPageRoute(
                  builder: (_) => new Riba('Riba', 'riba', finalUserID)),
            )
                .then((val) => {_getRequests()});
          },
          child: Container(
            height: 200.0,
            width: 200.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: totalRibaBalance < 0
                    ? <Widget>[
                  Text(
                    'Inaccurate riba data! Please review',
                    style:
                    TextStyle(fontSize: 17.0, color: Colors.red[600]),
                    textAlign: TextAlign.center,
                  ),
                ]
                    : ribaList.length == 0
                    ? <Widget>[
                  Text(
                    'No riba data available.',
                    style: TextStyle(fontSize: 17.0),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        new MaterialPageRoute(
                            builder: (_) =>
                            new Riba('Riba', 'riba', finalUserID)),
                      )
                          .then((val) => {_getRequests()});
                    },
                    child: new Text("Add"),
                  ),
                ]
                    : <Widget>[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'Riba',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: totalRibaBalance < 0
                            ? Colors.red[600]
                            : Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    width: 310.0,
                    child: charts.PieChart(
                      ribaSeriesList,
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 60,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator()
                          ]),
                      behaviors: [
                        new charts.DatumLegend(
                          position: charts.BehaviorPosition.end,
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
        new GestureDetector(
          onTap: () {
            // Change the color of the container beneath
            Navigator.of(context)
                .push(
              new MaterialPageRoute(
                  builder: (_) => new Zakat(
                      ModelZakatPaid('', '','', '', '', 0.0, '', this.finalUserID),
                      'Zakat',
                      'Zakat',
                      this.finalUserID ?? '',
                      settings)),
            )
                .then((val) => {_getRequests()});
          },
          child: Container(
            height: 200.0,
            width: 200.0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: totalZakatPayable <= 0
                    ? <Widget>[
                  Text(
                    '${totalZakatPayable < 0 ? 'Inaccurate data. Review all sections' : 'No zakat due.'}',
                    style: TextStyle(
                        fontSize: 17.0,
                        color: totalZakatPayable < 0
                            ? Colors.red[600]
                            : Colors.black),
                  ),
                ]
                    : <Widget>[
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'Zakat',
                      style: TextStyle(
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ),
                  SizedBox(
                    height: 150.0,
                    width: 310.0,
                    child: charts.PieChart(
                      zakatSeriesList,
                      animate: true,
                      defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 60,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator()
                          ]),
                      behaviors: [
                        new charts.DatumLegend(
                          position: charts.BehaviorPosition.end,
                        )
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  void updateListViewSetting(String? userId) {
    debugPrint('5-------------------------------  ${userId}');
    settingListFuture = firebaseHelper.getSettingList(userId ?? '');
    settingListFuture?.then((settingList) {
      setState(() {
        if (settingList != null) {
          this.settings = settingList;
          this.nisab = settingList.nisab;
          this.startDate = settingList.startDate;
          this.endDate = settingList.endDate;
          _selectedDialogCountry =
              CountryPickerUtils.getCountryByIsoCode('${settingList.country}');
          currencyCode = _selectedDialogCountry.currencyCode;
          if (settingList.country.contains(new RegExp(r'[0-9]')) ||
              settingList.nisab == null) {
            _getCurrentLocation();
          }

          updateListViewCash('cash', 'cashinhand', this.finalUserID ?? '');
          updateListViewCash('cash', 'cashinbank', this.finalUserID ?? '');
          updateListViewMetal('metal', 'gold', this.finalUserID ?? '');
          updateListViewMetal('metal', 'silver', this.finalUserID ?? '');
          updateListAllLoan(this.finalUserID ?? '');
          updateListViewBorrow('loan', 'borrow', this.finalUserID ?? '');
          updateListViewLendSecure('loan', 'lendsecure', this.finalUserID ?? '');
          updateListViewLendInsecure('loan', 'lendinsecure', this.finalUserID ?? '');
          updateListAllRiba(this.finalUserID ?? '');
          updateListViewZakatPayments(this.finalUserID ?? '');
          getAllTotal();
          calculateZakat();
        } else {
          _getCurrentLocation();
        }
      });
    });
  }




  void navigateToSettings(ModelSetting setting, String title, String? userid) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddSetting(setting, title, userid);
    })).then((value) {
      setState(() {
        _getRequests();
      });
    });
  }



  void updateListViewCash(String table, String type, String userId) {
    Future<List<ModelCash>> cashListFuture = firebaseHelper.getCashList(
        userId, table, type, settings.startDate, settings.endDate);
    cashListFuture.then((cashList) {
      setState(() {
        this.cashList = cashList;
        if (type == 'cashinhand') {
          totalCashInHand = getCashTotal();
          totalAssetAmount = getAllTotal();
        } else {
          totalCashInBank = getCashTotal();
          totalAssetAmount = getAllTotal();
        }
        calculateZakat();
      });
    });
  }

  double getCashTotal() {
    double totalCash = 0.0;
    for (int i = 0; i <= cashList.length - 1; i++) {
      totalCash = totalCash + this.cashList[i].amount;
    }
    return totalCash;
  }

  // functions for metal.................................................
  void updateListViewMetal(String table, String type, String userId) {
    Future<List<ModelMetal>> metalListFuture =
    firebaseHelper.getMetalList(userId, table, type);
    metalListFuture.then((metalList) {
      setState(() {
        if (type == 'gold') {
          this.goldList = metalList;
          totalGold = getMetalTotalAmount(type);
          totalAssetAmount = getAllTotal();
        } else {
          this.silverList = metalList;
          totalSilver = getMetalTotalAmount(type);
          totalAssetAmount = getAllTotal();
        }
        calculateZakat();
      });
    });
  }

  double getMetalTotalAmount(String metal) {
    double totalWeight18CG = 0.0;
    double totalWeight20CG = 0.0;
    double totalWeight22CG = 0.0;
    double totalWeight24CG = 0.0;
    double totalWeight18CS = 0.0;
    double totalWeight20CS = 0.0;
    double totalWeight22CS = 0.0;
    double totalWeight24CS = 0.0;
    double totalAmount18CG = 0.0;
    double totalAmount20CG = 0.0;
    double totalAmount22CG = 0.0;
    double totalAmount24CG = 0.0;
    double gTotalAmountGold = 0.0;
    double totalAmount18CS = 0.0;
    double totalAmount20CS = 0.0;
    double totalAmount22CS = 0.0;
    double totalAmount24CS = 0.0;
    double gTotalAmountSilver = 0.0;
    double totalAmount = 0.0;
    if (metal == 'gold') {
      for (int i = 0; i <= goldList.length - 1; i++) {
        if (goldList[i].carat == 18) {
          totalWeight18CG = totalWeight18CG + this.goldList[i].weight;
        } else if (goldList[i].carat == 20) {
          totalWeight20CG = totalWeight20CG + this.goldList[i].weight;
        } else if (goldList[i].carat == 22) {
          totalWeight22CG = totalWeight22CG + this.goldList[i].weight;
        } else if (goldList[i].carat == 24) {
          totalWeight24CG = totalWeight24CG + this.goldList[i].weight;
        }
      }
      totalAmount18CG = totalWeight18CG * this.settings.goldRate18C;
      totalAmount20CG = totalWeight20CG * this.settings.goldRate20C;
      totalAmount22CG = totalWeight22CG * this.settings.goldRate22C;
      totalAmount24CG = totalWeight24CG * this.settings.goldRate24C;
      gTotalAmountGold =
          totalAmount18CG + totalAmount20CG + totalAmount22CG + totalAmount24CG;
      totalAmount = gTotalAmountGold;
    } else {
      for (int i = 0; i <= silverList.length - 1; i++) {
        if (silverList[i].carat == 18) {
          totalWeight18CS = totalWeight18CS + this.silverList[i].weight;
        } else if (silverList[i].carat == 20) {
          totalWeight20CS = totalWeight20CS + this.silverList[i].weight;
        } else if (silverList[i].carat == 22) {
          totalWeight22CS = totalWeight22CS + this.silverList[i].weight;
        } else if (silverList[i].carat == 24) {
          totalWeight24CS = totalWeight24CS + this.silverList[i].weight;
        }
      }
      totalAmount18CS = totalWeight18CS * this.settings.silverRate18C;
      totalAmount20CS = totalWeight20CS * this.settings.silverRate20C;
      totalAmount22CS = totalWeight22CS * this.settings.silverRate22C;
      totalAmount24CS = totalWeight24CS * this.settings.silverRate24C;
      gTotalAmountSilver =
          totalAmount18CS + totalAmount20CS + totalAmount22CS + totalAmount24CS;
      totalAmount = gTotalAmountSilver;
    }
    return totalAmount;
  }

  double getAllTotal() {
    double allTotal = 0;
    allTotal = totalCashInHand + totalCashInBank + totalGold + totalSilver;
    return allTotal;
  }

  //-------------------------------------------------------------------------------
  void updateUserListView() async {
    Future<List<ModelUser>> userListFuture = firebaseHelper.getUserList(finalUserID ?? '');
    userListFuture.then((userList) {
      setState(() {
        this.userList = userList;
      });
    });
  }

  void updateListAllLoan(String userId) async {
    Future<List<ModelLoan>> loanListFuture = firebaseHelper.getTotalLoanList(finalUserID ?? '');
    loanListFuture.then((loanList) {
      setState(() {
        this.loanList = loanList;
        totalLoanAmount = getLoanTotal();
        calculateZakat();
      });
    });
  }

  double getLoanTotal() {
    double totalAmountborrow = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      totalAmountborrow = totalAmountborrow + this.loanList[i].amount;
    }
    return totalAmountborrow;
  }

  double getLoanSecureTotal() {
    double totalAmountSecure = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      if (loanList[i].type == 'lendsecure') {
        totalAmountSecure = totalAmountSecure + this.loanList[i].amount;
      }
    }
    return totalAmountSecure;
  }

  double getLoanBorrowTotal() {
    double totalAmountSecure = 0;
    for (int i = 0; i <= loanList.length - 1; i++) {
      if (loanList[i].type == 'borrow') {
        totalAmountSecure = totalAmountSecure + this.loanList[i].amount;
      }
    }
    return totalAmountSecure;
  }

  void updateListAllRiba(String userId) async {
    Future<List<ModelRiba>> ribaListFuture = firebaseHelper.getRibaList(userId,
        '1900-01-01', '${DateFormat("yyyy-MM-dd").format(DateTime.now())}');
    ribaListFuture.then((ribaList) {
      setState(() {
        this.ribaList = ribaList;
        totalRibaAmount = getRibaReceivedTotal();
        totalRibaBalance = getRibaBalanceTotal();
        totalRibaPaid = getRibaPaidTotal();
        calculateZakat();
      });
    });
  }

  double getRibaReceivedTotal() {
    double totalAmountRiba = 0;
    for (int i = 0; i <= ribaList.length - 1; i++) {
      if (ribaList[i].amount > 0) {
        totalAmountRiba = totalAmountRiba + ribaList[i].amount;
      }
    }
    return totalAmountRiba;
  }

  double getRibaBalanceTotal() {
    double totalAmountRiba = 0;
    for (int i = 0; i <= ribaList.length - 1; i++) {
      totalAmountRiba = totalAmountRiba + ribaList[i].amount;
    }
    return totalAmountRiba;
  }

  double getRibaPaidTotal() {
    double totalAmountRiba = 0;
    for (int i = 0; i <= ribaList.length - 1; i++) {
      if (this.ribaList[i].amount < 0) {
        totalAmountRiba = totalAmountRiba + this.ribaList[i].amount;
      }
    }
    return totalAmountRiba;
  }

//-------------------------Loan Functions------------------------------------------------

  void updateListViewBorrow(String table, String type, String userId) {
    Future<List<ModelLoan>> loanListFuture =
    firebaseHelper.getLoanList(table, type, userId);
    loanListFuture.then((loanList) {
      setState(() {
        this.loanList = loanList;
        totalBorrow = getLoanTotal();
        calculateZakat();
      });
    });
  }

  void updateListViewLendSecure(String table, String type, String userId) async {
    Future<List<ModelLoan>> loanListFuture = firebaseHelper.getLoanList(table, type, userId);
    loanListFuture.then((loanList) {
      setState(() {
        this.loanList = loanList;
        totalLendSecure = getLoanTotal();
        calculateZakat();
      });
    });
  }

  // functions for loan.................................................
  void updateListViewLendInsecure(String table, String type, String userid) async {
    Future<List<ModelLoan>> cashListFuture =
    firebaseHelper.getLoanList(table, type, userid);
    cashListFuture.then((lendinsecureList) {
      setState(() {
        this.loanList = lendinsecureList;
        totalLendInsecure = getLoanTotal();
        calculateZakat();
      });
    });
  }

  void updateListViewZakatPayments(String userId) async {
    Future<List<ModelZakatPaid>> zakatPaymentListFuture = firebaseHelper.getZakatPaidList(userId);
    zakatPaymentListFuture.then((paymentList) {
      setState(() {
        this.zakatPaymentList = paymentList;
        totalZakatPaid = getZakatPaymentsTotal();
        calculateZakat();
      });
    });
  }

  double getZakatPaymentsTotal() {
    double totalZakatPayments = 0;
    for (int i = 0; i <= zakatPaymentList.length - 1; i++) {
      totalZakatPayments = totalZakatPayments + this.zakatPaymentList[i].amount;
    }
    return totalZakatPayments;
  }

  double getEligibleMetalTotal() {
    double totalWeight18CG = 0.0;
    double totalWeight20CG = 0.0;
    double totalWeight22CG = 0.0;
    double totalWeight24CG = 0.0;
    double totalWeight18CS = 0.0;
    double totalWeight20CS = 0.0;
    double totalWeight22CS = 0.0;
    double totalWeight24CS = 0.0;
    double totalAmount18CG = 0.0;
    double totalAmount20CG = 0.0;
    double totalAmount22CG = 0.0;
    double totalAmount24CG = 0.0;
    double gTotalAmountGold = 0.0;
    double totalAmount18CS = 0.0;
    double totalAmount20CS = 0.0;
    double totalAmount22CS = 0.0;
    double totalAmount24CS = 0.0;
    double gTotalAmountSilver = 0.0;
    double totalAmount = 0.0;
    DateTime zakatStartDate = DateTime.parse(settings.startDate);

    //gold
    for (int i = 0; i <= goldList.length - 1; i++) {
      ModelMetal gold = goldList[i];
      DateTime purchaseDate = DateTime.parse(gold.date);
      if (purchaseDate.isBefore(zakatStartDate)) {
        if (gold.carat == 18) {
          totalWeight18CG = totalWeight18CG + gold.weight;
        } else if (gold.carat == 20) {
          totalWeight20CG = totalWeight20CG + gold.weight;
        } else if (gold.carat == 22) {
          totalWeight22CG = totalWeight22CG + gold.weight;
        } else if (gold.carat == 24) {
          totalWeight24CG = totalWeight24CG + gold.weight;
        }
      }
    }
    totalAmount18CG = totalWeight18CG * this.settings.goldRate18C;
    totalAmount20CG = totalWeight20CG * this.settings.goldRate20C;
    totalAmount22CG = totalWeight22CG * this.settings.goldRate22C;
    totalAmount24CG = totalWeight24CG * this.settings.goldRate24C;
    gTotalAmountGold =
        totalAmount18CG + totalAmount20CG + totalAmount22CG + totalAmount24CG;
    totalAmount = gTotalAmountGold;

    //Silver
    for (int i = 0; i <= silverList.length - 1; i++) {
      ModelMetal silver = silverList[i];
      DateTime purchaseDate = DateTime.parse(silver.date);
      if (purchaseDate.isBefore(zakatStartDate)) {
        if (silver.carat == 18) {
          totalWeight18CS = totalWeight18CS + silver.weight;
        } else if (silver.carat == 20) {
          totalWeight20CS = totalWeight20CS + silver.weight;
        } else if (silver.carat == 22) {
          totalWeight22CS = totalWeight22CS + silver.weight;
        } else if (silver.carat == 24) {
          totalWeight24CS = totalWeight24CS + silver.weight;
        }
      }
    }
    totalAmount18CS = totalWeight18CS * this.settings.silverRate18C;
    totalAmount20CS = totalWeight20CS * this.settings.silverRate20C;
    totalAmount22CS = totalWeight22CS * this.settings.silverRate22C;
    totalAmount24CS = totalWeight24CS * this.settings.silverRate24C;
    gTotalAmountSilver =
        totalAmount18CS + totalAmount20CS + totalAmount22CS + totalAmount24CS;
    totalAmount = totalAmount + gTotalAmountSilver;

    return totalAmount;
  }

  void calculateZakat() {
    double totalMetalAsset = getEligibleMetalTotal();
    double totalRibaBalance = getRibaBalanceTotal();
    double assets = totalCashInHand +
        totalCashInBank +
        totalMetalAsset +
        totalLendSecure -
        totalBorrow -
        totalRibaBalance;
    if (assets >= settings.nisab) {
      totalZakatPayable = assets / 40;
    } else {
      totalZakatPayable = 0;
    }
    totalZakatBalance = totalZakatPayable - totalZakatPaid;
    debugPrint('======================');
    debugPrint('totalCashInHand: $totalCashInHand');
    debugPrint('totalCashInBank: $totalCashInBank');
    debugPrint('metal: $totalMetalAsset');
    debugPrint('loan: $totalLendSecure');
    debugPrint('borrow: $totalBorrow');
    debugPrint('riba: $totalRibaBalance');
    debugPrint('Asset: $assets');
    debugPrint('Payable: $totalZakatPayable');
    debugPrint('Paid: $totalZakatPaid');
    debugPrint('Balance $totalZakatBalance');
  }

  // void getUserAuthentication() async {
  //   String email='+919455106497';
  //   String password="12345";
  //   Future<List<ModelUser>> userListFuture = (await firebaseHelper.getUserList(finalUserID ?? '')) as Future<List<ModelUser>>;
  //   userListFuture.then((userList) {
  //     setState(() {
  //       this.userList = userList;
  //       this.countGA = userList.length;
  //       if (countGA != 0) {
  //         this.finalUserID = this.userList[0].userId!;
  //         cashList = <ModelCash>[];
  //         userList = <ModelUser>[];
  //         goldList = <ModelMetal>[];
  //         //settings = List<ModelSetting>();
  //         updateListViewSetting(this.finalUserID);
  //         updateListViewCash('cash', 'cashinhand', this.finalUserID ?? '');
  //         updateListViewCash('cash', 'cashinbank', this.finalUserID ?? '');
  //         updateListViewMetal('metal', 'gold', this.finalUserID ?? '');
  //         updateListViewMetal('metal', 'silver', this.finalUserID ?? '');
  //         updateListAllLoan(this.finalUserID ?? '');
  //         updateListAllRiba(this.finalUserID ?? '');
  //         updateListViewBorrow('loan', 'borrow', this.finalUserID ?? '');
  //         updateListViewLendSecure('loan', 'lendsecure', this.finalUserID ?? '');
  //         updateListViewLendInsecure('loan', 'lendinsecure', this.finalUserID ?? '');
  //         getAllTotal();
  //       }
  //     });
  //     if (countGA == 0) {
  //       _save();
  //     }
  //   });
  // }

  // void _save() async {
  //   setState(() {
  //     this.user?.registrationDate = '12.12.2019';
  //     this.user?.age = 00;
  //     this.user?.isPaid = 'yes';
  //     this.user?.paymentDate = '12.12.2019';
  //     this.user?.city = 'Delhi';
  //     this.user?.pin = 000000;
  //     this.user?.familyId = '';
  //   });
  //   int result;
  //   if (this.countGA != 0) {
  //     // Case 1: Update operation
  //     result = await firebaseHelper.updateUser(user!);
  //   } else {
  //     // Case 2: Insert Operation
  //     result = await firebaseHelper.insertUser(user!);
  //     //databaseHelper.getUserList();
  //   }
  // }



  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
    double.parse(info.version.trim().replaceAll(".", ""));

    //Get Latest version info from firebase config
    RemoteConfig remoteConfig = RemoteConfig.instance;

    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetchAndActivate();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of this app available. Please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return Platform.isIOS
            ? new CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: (){},
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        )
            : new AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text(btnLabel),
              onPressed: () {},
            ),
            FlatButton(
              child: Text(btnLabelCancel),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await Geolocator.getCurrentPosition()
        .then((Position position) {
      //setState(() {
      _currentPosition = position;
      //});
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
      final snackBar = SnackBar(
        content: Text('Unable to fetch location.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState?.showSnackBar(snackBar);
    });

  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition?.latitude ?? 0, _currentPosition?.longitude ?? 0);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
        _selectedDialogCountry =
            CountryPickerUtils.getCountryByIsoCode(place.isoCountryCode ?? 'IN');
        currencyCode = _selectedDialogCountry.currencyCode;
        debugPrint('User Location: $_currentAddress');
        scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text('Current Location: $_currentAddress'),
          duration: Duration(seconds: 5),
        ));
        fetchMetalRates();
      });
    } catch (e) {
      print(e);
      final snackBar = SnackBar(
        content: Text('Unable to get geo-location.'),
        duration: Duration(seconds: 5),
      );

      scaffoldKey.currentState?.showSnackBar(snackBar);
    }
  }

  void fetchMetalRates() {
    Future<MetalRates> metalRates =
    GeneralHelper.fetchMetalRates(_selectedDialogCountry.currencyCode ?? 'India Rupee');
    metalRates.then((rate) {
      setState(() {
        if (settings == null) {
          settings = new  ModelSetting('','','',0,'','',0,0,0,0,0,0,0,0,'');
          settings.userId = this.finalUserID ?? '';
        }
        settings.country = _selectedDialogCountry.isoCode ?? 'IN';
        settings.currency = _selectedDialogCountry.currencyCode ?? 'India Rupee';
        settings.startDate =
        '${DateFormat("yyyy-MM-dd").format(DateTime.now().subtract(new Duration(days: 354)))}';
        settings.endDate = '${DateFormat("yyyy-MM-dd").format(DateTime.now())}';
        settings.goldRate24C = rate.goldRate;
        settings.goldRate22C = rate.goldRate * 0.916;
        settings.goldRate20C = rate.goldRate * 0.833;
        settings.goldRate18C = rate.goldRate * 0.750;

        settings.silverRate24C = rate.silverRate;
        settings.silverRate22C = rate.silverRate * 0.916;
        settings.silverRate20C = rate.silverRate * 0.833;
        settings.silverRate18C = rate.silverRate * 0.750;

        settings.nisab = rate.goldRate * 85;
        this.nisab = settings.nisab;

        saveSettings(settings);
      });
    });
  }

  void saveSettings(ModelSetting settings) async {
    int result = await firebaseHelper.updateSetting(settings);
    setState(() {
      settingListFuture = firebaseHelper.getSettingList(finalUserID ?? '');
    });
  }
}

class LinearData {
  final String type;
  final double amount;

  LinearData(this.type, this.amount);
}
