import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/screens/basic/home.dart';

class Acc_Verify_Tutorial_Screen extends StatefulWidget {
  const Acc_Verify_Tutorial_Screen({super.key});

  @override
  State<Acc_Verify_Tutorial_Screen> createState() => _Acc_Verify_Tutorial_ScreenState();
}

class _Acc_Verify_Tutorial_ScreenState extends State<Acc_Verify_Tutorial_Screen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: OnBoardingSlider(
          finishButtonText: AppLocalizations.of(context)!.translate("loc_finish"),
          // indicatorPosition: 25.0,
          onFinish: () {
            Navigator.pop(context);
          },

          finishButtonStyle: FinishButtonStyle(
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
          // skipTextButton: InkWell(
          //   onTap: (){
          //     // storeData();
          //     // Navigator.pushReplacement(
          //     //   context,
          //     //   CupertinoPageRoute(
          //     //     builder: (context) => Welcome_Details(),
          //     //   ),
          //     // );
          //
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(left: 20.0, right: 20.0),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(25.0),
          //       color: Theme.of(context).bottomAppBarColor,
          //     ),
          //     child: Text(
          //       AppLocalizations.of(context)!.translate("loc_skip").toString(),
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Theme.of(context).focusColor,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
          trailing: Container(
            // padding: EdgeInsets.only(left: 20.0, right: 20.0),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(25.0),
            //   color: Theme.of(context).bottomAppBarColor,
            // ),
            // child: Text(
            //   AppLocalizations.of(context)!.translate("loc_finish").toString(),
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Theme.of(context).focusColor,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
          ),
          trailingFunction: () {
            // storeData();
            // Navigator.pushReplacement(
            //   context,
            //   CupertinoPageRoute(
            //     builder: (context) => Welcome_Details(),
            //   ),
            // );
          },
          controllerColor: Theme.of(context).primaryColorLight,
          totalPage: 4,
          headerBackgroundColor: Colors.white,
          pageBackgroundColor: Colors.white,
          background: [
            // Container(
            //   alignment: Alignment.center,
            //   child: Center(
            //     child:SvgPicture.network(
            //         "https://zurumi.com/images/color/xof.svg",
            //       height: MediaQuery.of(context).size.height,
            //       width: MediaQuery.of(context).size.width,
            //     ),
            //   ),
            // ),
            Image.asset(
              'assets/sidemenu/signin1.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
            Image.asset(
              'assets/sidemenu/mail_verify1.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
            Image.asset(
              'assets/sidemenu/menu.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
            Image.asset(
              'assets/sidemenu/sidemenu_2.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
          ],
          speed: 1.8,
          pageBodies: [
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('loc_reg_ema').toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        20.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text: AppLocalizations.of(context)!.translate("loc_reg_ema"),
                  //     style: CustomWidget(context: context)
                  //         .CustomSizedTextStyle(
                  //         22.0,
                  //         CustomTheme.of(context).cardColor,
                  //         FontWeight.w700,
                  //         'FontRegular'),
                  //     // children: <TextSpan>[
                  //     //   TextSpan(
                  //     //       text: AppLocalizations.of(context)!.translate("loc_wel_text"),
                  //     //       style: TextStyle(
                  //     //         color: Color(0xFF5C4392),
                  //     //         fontSize: 18.0,
                  //     //       )),
                  //     //   TextSpan(text: AppLocalizations.of(context)!.translate("loc_wel_texts"),),
                  //     // ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_tuto_reg").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          15.0,
                          CustomTheme.of(context).scaffoldBackgroundColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate('loc_reg_ematwo').toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        20.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  // RichText(
                  //   textAlign: TextAlign.center,
                  //   text: TextSpan(
                  //     text: AppLocalizations.of(context)!.translate("loc_side_trade"),
                  //     style: CustomWidget(context: context)
                  //         .CustomSizedTextStyle(
                  //         22.0,
                  //         CustomTheme.of(context).cardColor,
                  //         FontWeight.w700,
                  //         'FontRegular'),
                  //     children: const <TextSpan>[
                  //       TextSpan(
                  //           text: ' 600+',
                  //           style: TextStyle(
                  //             color: Color(0xFF5C4392),
                  //             fontSize: 18.0,
                  //           )),
                  //       TextSpan(text: ' coins'),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_tuto_verify").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          15.0,
                          CustomTheme.of(context).scaffoldBackgroundColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate("loc_tuto_home").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        22.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_home_details").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          15.0,
                          CustomTheme.of(context).scaffoldBackgroundColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ),

                  SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.translate("loc_tuto_kyc").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        21.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_tuto_kyc_det").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          15.0,
                          CustomTheme.of(context).scaffoldBackgroundColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget bottomSkip() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  storeData();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home_Screen(
                        loginStatus: false,
                      )));
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate("loc_skip").toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).scaffoldBackgroundColor,
                        FontWeight.w600,
                        'FontRegular'),
                  ),
                ),
              ),
            ),
            flex: 1,
          ),
          SizedBox(
            width: 10.0,
          ),
          Flexible(
            child: InkWell(
              onTap: () {
                setState(() {
                  storeData();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Home_Screen(
                        loginStatus: false,
                      )));
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                decoration: BoxDecoration(
                  // color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      CustomTheme.of(context).primaryColorLight,
                      CustomTheme.of(context).primaryColorDark,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  // border: Border.all(width: 1.0, color: Theme.of(context).backgroundColor,),
                  borderRadius: BorderRadius.circular(35.0),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate("loc_finish").toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).scaffoldBackgroundColor,
                        FontWeight.w600,
                        'FontRegular'),
                  ),
                ),
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }

  storeData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("welcomeZuru", "welcome");
  }

}
