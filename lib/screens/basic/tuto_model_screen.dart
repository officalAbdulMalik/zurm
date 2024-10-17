import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/screens/basic/verify_acc_tutorial_screen.dart';
import 'package:zurumi/screens/basic/verify_buy_crypto.dart';

class Tutorial_Model_Screen extends StatefulWidget {
  const Tutorial_Model_Screen({super.key});

  @override
  State<Tutorial_Model_Screen> createState() => _Tutorial_Model_ScreenState();
}

class _Tutorial_Model_ScreenState extends State<Tutorial_Model_Screen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
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
                color: CustomTheme.of(context).shadowColor,
              ),
            ),
          ),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("loc_tuto").toString(),
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
          color: CustomTheme.of(context).secondaryHeaderColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Center(
                  //   child:  Image.asset(
                  //     'assets/sidemenu/acc_verfy.png',
                  //     height: 250,
                  //     width: MediaQuery.of(context).size.width,
                  //   ),
                  // ),
                  // const  SizedBox(height: 10,),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       Navigator.push(context, MaterialPageRoute(builder: (context) => Acc_Verify_Tutorial_Screen(),));
                  //     });
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  //     alignment: Alignment.center,
                  //     decoration: BoxDecoration(
                  //       gradient: LinearGradient(
                  //         begin: Alignment.centerLeft,
                  //         end: Alignment.centerRight,
                  //         colors: <Color>[
                  //           CustomTheme.of(context).bottomAppBarColor,
                  //           CustomTheme.of(context).backgroundColor,
                  //         ],
                  //         tileMode: TileMode.mirror,
                  //       ),
                  //       borderRadius: BorderRadius.circular(30.0),
                  //     ),
                  //     child: Text(
                  //       AppLocalizations.of(context)!
                  //           .translate("loc_veri")
                  //           .toString(),
                  //       style: CustomWidget(context: context).CustomSizedTextStyle(
                  //           16.0,
                  //           CustomTheme.of(context).focusColor,
                  //           FontWeight.w500,
                  //           'FontRegular'),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 35.0,),
                  Center(
                    child:  Image.asset(
                      'assets/sidemenu/buy_verify.png',
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const  SizedBox(height: 10,),

                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Verify_Buy_Crypto(id: "true"),));
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            CustomTheme.of(context).primaryColorLight,
                            CustomTheme.of(context).primaryColorDark,
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_how_buy")
                            .toString(),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            16.0,
                            CustomTheme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 35.0,),
                  Center(
                    child:  Image.asset(
                      'assets/sidemenu/trade_verify.png',
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const  SizedBox(height: 10,),

                  InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Verify_Buy_Crypto(id: "false"),));
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            CustomTheme.of(context).primaryColorLight,
                            CustomTheme.of(context).primaryColorDark,
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate("loc_how_trade").toString(),
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            16.0,
                            CustomTheme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                    ),
                  ),
                  const  SizedBox(height: 20,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
