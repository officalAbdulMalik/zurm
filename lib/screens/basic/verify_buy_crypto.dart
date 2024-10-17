import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';

class Verify_Buy_Crypto extends StatefulWidget {
  final String id;
  const Verify_Buy_Crypto({super.key, required this.id, });

  @override
  State<Verify_Buy_Crypto> createState() => _Verify_Buy_CryptoState();
}

class _Verify_Buy_CryptoState extends State<Verify_Buy_Crypto> {

  bool Status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    onLoad();
  }

  onLoad(){
    if(widget.id =="true"){
      Status= true;
    }else{
      Status = false;
    }
  }

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
            Status ? Image.asset(
              'assets/sidemenu/menu.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ) : Image.asset(
             'assets/sidemenu/market.png',
             height: 400,
             width: MediaQuery.of(context).size.width,
           ),
            Status ? Image.asset(
              'assets/sidemenu/sidemenu_1.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ) : Image.asset(
              'assets/sidemenu/depo.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ),
            Status ? Image.asset(
              'assets/sidemenu/swap_page2.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ) : Image.asset(
              'assets/sidemenu/trade_page1.png',
              height: 400,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
            ),
            Status ? Image.asset(
              'assets/sidemenu/payment.png',
              height: 400,
              width: MediaQuery.of(context).size.width,
            ): Image.asset(
              'assets/sidemenu/trade_page2.png',
              height: 400,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                   Status?  AppLocalizations.of(context)!.translate('loc_tuto_home').toString() : AppLocalizations.of(context)!.translate('loc_market_menu').toString() ,
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        20.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w700,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Text(
                      Status?  AppLocalizations.of(context)!.translate("loc_home_details").toString() : AppLocalizations.of(context)!.translate("loc_market_details").toString(),
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
                    Status? AppLocalizations.of(context)!.translate('loc_profile_menu').toString() : AppLocalizations.of(context)!.translate('loc_depo_menu').toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        20.0,
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
                      Status? AppLocalizations.of(context)!.translate("loc_crypto_deta").toString(): AppLocalizations.of(context)!.translate("loc_depo_details").toString(),
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
                    Status ? AppLocalizations.of(context)!.translate("loc_buy_menu").toString(): AppLocalizations.of(context)!.translate("loc_trade_menu").toString(),
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
                      Status ? AppLocalizations.of(context)!.translate("loc_crypto_detail").toString() : AppLocalizations.of(context)!.translate("loc_trade_detail").toString(),
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
                    Status ? AppLocalizations.of(context)!.translate("loc_buy_menu").toString(): AppLocalizations.of(context)!.translate("loc_trade_menu").toString(),
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
                      Status ? AppLocalizations.of(context)!.translate("loc_crypto_details").toString() : AppLocalizations.of(context)!.translate("loc_trade_details").toString(),
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
}
