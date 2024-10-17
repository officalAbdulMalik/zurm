import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/screens/basic/home.dart';
import 'package:zurumi/screens/basic/login_screen.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class Register_Success_Screen extends StatefulWidget {
  const Register_Success_Screen({Key? key}) : super(key: key);

  @override
  State<Register_Success_Screen> createState() => _Register_Success_ScreenState();
}

class _Register_Success_ScreenState extends State<Register_Success_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              CustomTheme.of(context).primaryColor,
              CustomTheme.of(context).primaryColor,
              CustomTheme.of(context).disabledColor,
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0, top: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20.0,
              ),
              Image.asset("assets/images/signup_5.png",),
              const SizedBox(
                height: 10.0,
              ),
              Padding(padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Text(
                AppLocalizations.of(context)!.translate("loc_your_acc").toString(),
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    22.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                textAlign: TextAlign.center,
              ),),
              const SizedBox(
                height: 50.0,
              ),
              InkWell(
                onTap: (){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Login_Screen(
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        CustomTheme.of(context).primaryColorDark,
                        CustomTheme.of(context).primaryColorLight,
                      ],
                      tileMode: TileMode.mirror,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate("loc_get_start").toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        17.0,
                        CustomTheme.of(context).focusColor,
                        FontWeight.w400,
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
