import 'dart:math';

import 'package:bambara_flutter/bambara_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';

class Payment_Method_Screen extends StatefulWidget {
  const Payment_Method_Screen({super.key});

  @override
  State<Payment_Method_Screen> createState() => _Payment_Method_ScreenState();
}

class _Payment_Method_ScreenState extends State<Payment_Method_Screen> {


  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  bool loading = false;
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;

  }

  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: CustomTheme.of(context).primaryColor,
        appBar: AppBar(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          elevation: 0.0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Icon(
                Icons.arrow_back,
                size: 25.0,
                color:  CustomTheme.of(context).shadowColor,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("loc_pay_method").toString(),
            style: TextStyle(
              fontFamily: 'FontSpecial',
              color: CustomTheme.of(context).cardColor,
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                CustomTheme.of(context).secondaryHeaderColor,
                CustomTheme.of(context).primaryColor,
                CustomTheme.of(context).disabledColor,
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Stack(
            children: [
              listUI(),
              loading
                  ? CustomWidget(context: context).loadingIndicator(
                CustomTheme.of(context).primaryColor,
              )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget listUI(){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 60,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: CupertinoButton(
                  color: const Color(0xFF0066FF),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_opn_bambara").toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await BambaraView(
                      data: BambaraData(
                        amount: 200,
                        provider: 'bank-card',
                        reference: getRandomString(30),
                        phone: "786339816",
                        email: "bass@gmail.com",
                        name: "Bassirou",
                        publicKey: "pk_IuR83FabBsxW2P6mHPJywyGljga9QcFg",
                      ),
                      onClosed: () => print("CLOSED"),
                      onError: (data) => print(data),
                      onSuccess: (data) => print(data),
                      onRedirect: (data) => print(data),
                      onProcessing: (data) => print(data),
                      closeOnComplete: false,
                    ).show(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
