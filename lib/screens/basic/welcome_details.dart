import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurumi/common/custom_button.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_langugage_provider.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/screens/basic/login_screen.dart';
import 'package:zurumi/screens/basic/register_success.dart';
import 'package:zurumi/screens/basic/sign_uo_screen.dart';

class Welcome_Details extends StatefulWidget {
  const Welcome_Details({super.key});

  @override
  State<Welcome_Details> createState() => _Welcome_DetailsState();
}

class _Welcome_DetailsState extends State<Welcome_Details> {
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  String language = "";
  late AppLanguageProvider appLanguage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String m = preferences.getString('language_code').toString();
    if (m == "fr") {
      language = "1";
    } else {
      language = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              CustomTheme.of(context).primaryColorDark, // For iOS: (dark icons)
          statusBarIconBrightness:
              Brightness.light, // For Android: (dark icons)
        ),
        elevation: 0.0,
        backgroundColor: CustomTheme.of(context).primaryColorDark,
        actions: [
          PopupMenuButton<int>(
            key: _key,
            color: CustomTheme.of(context).primaryColorDark,
            itemBuilder: (context) => [
              // PopupMenuItem 1
              PopupMenuItem(
                value: 1,
                // row with 2 children
                child: Row(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!
                          .translate("loc_english")
                          .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              language == "0"
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).focusColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ],
                ),
              ),
              // PopupMenuItem 2
              PopupMenuItem(
                value: 2,
                // row with two children
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate("loc_french")
                          .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              16.0,
                              language == "1"
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).focusColor,
                              FontWeight.w400,
                              'FontRegular'),
                    ),
                  ],
                ),
              ),
            ],
            elevation: 2,
            onSelected: (value) {
              if (value == 1) {
                language = "0";
                appLanguage.changeLanguage(const Locale("en"));
              } else if (value == 2) {
                language = "1";
                appLanguage.changeLanguage(const Locale("fr"));
              }
              getData();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Icon(
                Icons.language,
                size: 25.0,
                color: CustomTheme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: CustomTheme.of(context).primaryColorDark,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset("assets/images/logo.png",
                  height: 200.0, width: 200.0, fit: BoxFit.contain),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_app_name_details")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    22.0,
                    CustomTheme.of(context).focusColor,
                    FontWeight.w600,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_app_name")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    32.0,
                    CustomTheme.of(context).focusColor,
                    FontWeight.w600,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate("loc_crt_portfolio")
                      .toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      CustomTheme.of(context).focusColor,
                      FontWeight.w400,
                      'FontRegular'),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(
                height: 50.0,
              ),

              ButtonCustom(
                text: AppLocalizations.of(context)!
                    .translate("loc_create_acc")
                    .toString(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const SignUpScreen();
                    },
                  ));
                },
              ),

              // ),

              const SizedBox(
                height: 15.0,
              ),

              GestureDetector(
                onTap: () {
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Login_Screen(),
                      ),
                    );
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.1),
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate("loc_sign_in")
                        .toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        16.0,
                        CustomTheme.of(context).focusColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
