import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/onboard/flutter_onboarding_slider.dart';
import 'package:zurumi/screens/basic/home.dart';
import 'package:zurumi/screens/basic/welcome_details.dart';

import '../../common/theme/custom_theme.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: OnBoardingSlider(
          finishButtonText: AppLocalizations.of(context)!.translate("loc_reg"),
          indicatorPosition: 25.0,
          onFinish: () {
            storeData();
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const Welcome_Details(),
              ),
            );
          },

          finishButtonStyle: FinishButtonStyle(
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
          skipTextButton: InkWell(
            onTap: (){
              storeData();
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => Welcome_Details(),
                ),
              );

            },
            child: Container(
              // padding: EdgeInsets.only(left: 20.0, right: 20.0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(25.0),
              //   color: Theme.of(context).primaryColorLight,
              // ),
              child: Text(
                AppLocalizations.of(context)!.translate("loc_skip").toString(),
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF009FD4),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          trailing: Text(
            AppLocalizations.of(context)!.translate("loc_finish").toString(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailingFunction: () {
            storeData();
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => const Welcome_Details(),
              ),
            );
          },
          controllerColor: const Color(0xFF009FD4),
          totalPage: 4,
          headerBackgroundColor: Theme.of(context).primaryColorDark,
          pageBackgroundColor: Theme.of(context).primaryColorDark,
          background: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
              width: MediaQuery.of(context).size.width,
              child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Image.asset(
                  'assets/images/signup_1.png',
                  height: 200,
                  // width: 200,
                ),),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
              width: MediaQuery.of(context).size.width,
              child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Image.asset(
                  'assets/images/signup_2.png',
                  height: 200,
                  // width: 200,
                ),),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
              width: MediaQuery.of(context).size.width,
              child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Image.asset(
                  'assets/images/signup_3.png',
                  height: 200,
                  // width: 200,
                ),),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15),
              width: MediaQuery.of(context).size.width,
              child:  Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Image.asset(
                  'assets/images/signup_4.png',
                  height: 200,
                ),),
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.translate("loc_wel_txt"),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              22.0,
                              CustomTheme.of(context).focusColor,
                              FontWeight.w700,
                              'FontRegular'),
                      // children: <TextSpan>[
                        // TextSpan(
                        //     text: AppLocalizations.of(context)!.translate("loc_wel_text"),
                        //     style: TextStyle(
                        //       color: Color(0xFF009FD4),
                        //       fontSize: 18.0,
                        //     )),
                      //   TextSpan(text: AppLocalizations.of(context)!.translate("loc_wel_texts"),),
                      // ],
                    ),
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_wel_textes").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              CustomTheme.of(context).focusColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // bottomSkip(),
                  const SizedBox(
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: AppLocalizations.of(context)!.translate("loc_trade"),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              22.0,
                              CustomTheme.of(context).focusColor,
                              FontWeight.w700,
                              'FontRegular'),
                      // children: const <TextSpan>[
                      //   TextSpan(
                      //       text: ' 600+',
                      //       style: TextStyle(
                      //         color: Color(0xFF009FD4),
                      //         fontSize: 18.0,
                      //       )),
                      //   TextSpan(text: ' coins'),
                      // ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      AppLocalizations.of(context)!.translate("loc_wel_coins").toString(),
                      textAlign: TextAlign.center,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          14.0,
                          CustomTheme.of(context).focusColor,
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  const SizedBox(
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
                    AppLocalizations.of(context)!.translate("loc_wel_te").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        22.0,
                        CustomTheme.of(context).focusColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.translate("loc_wel_support"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                14.0,
                                CustomTheme.of(context).focusColor,
                                FontWeight.w400,
                                'FontRegular'),
                        // children: <TextSpan>[
                        //   TextSpan(
                        //       text: AppLocalizations.of(context)!.translate("loc_wel_cards"),
                        //       style: const TextStyle(
                        //         color: Color(0xFF009FD4),
                        //         fontWeight: FontWeight.w400,
                        //         fontSize: 14.0,
                        //       )),
                        //   TextSpan(text: ' and more'),
                        // ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  const SizedBox(
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
                    AppLocalizations.of(context)!.translate("loc_wel_reffer").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                       21.0,
                        CustomTheme.of(context).focusColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.translate("loc_wel_winup"),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                14.0,
                                CustomTheme.of(context).focusColor,
                                FontWeight.w400,
                                'FontRegular'),
                        // children: <TextSpan>[
                        //   TextSpan(
                        //       text: AppLocalizations.of(context)!.translate("loc_wel_usdt"),
                        //       style: const TextStyle(
                        //         color: Color(0xFF009FD4),
                        //         fontWeight: FontWeight.w600,
                        //         fontSize: 15.0,
                        //       )),
                        //   TextSpan(text: ' rewards'),
                        // ],
                      ),
                    ),
                  ),

                 const SizedBox(
                    height: 50,
                  ),
                  // bottomSkip(),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  storeData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("welcomeZuru", "welcome");
    preferences.setString("old", "welcome");
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
                // padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                // decoration: BoxDecoration(
                //   border: Border.all(
                //     width: 1.0,
                //     color: Theme.of(context).primaryColorDark,
                //   ),
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
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
                // padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                // decoration: BoxDecoration(
                //   // color: Theme.of(context).primaryColor,
                //   gradient: LinearGradient(
                //     begin: Alignment.centerLeft,
                //     end: Alignment.centerRight,
                //     colors: <Color>[
                //       CustomTheme.of(context).primaryColorLight,
                //       CustomTheme.of(context).primaryColorDark,
                //     ],
                //     tileMode: TileMode.mirror,
                //   ),
                //   // border: Border.all(width: 1.0, color: Theme.of(context).backgroundColor,),
                //   borderRadius: BorderRadius.circular(10.0),
                // ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate("loc_next").toString(),
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


}
