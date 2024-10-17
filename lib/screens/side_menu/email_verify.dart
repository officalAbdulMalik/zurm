import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zurumi/common/localization/app_localizations.dart';


import '../../common/custom_widget.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';

class Email_Verify extends StatefulWidget {
  final String status;
  const Email_Verify({super.key, required this.status});

  @override
  State<Email_Verify> createState() => _Email_VerifyState();
}

class _Email_VerifyState extends State<Email_Verify> {

  final emailformKey = GlobalKey<FormState>();
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  FocusNode emailFocus = FocusNode();

  TextEditingController emailController = TextEditingController();
  bool status=false;
  bool codesent=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.status == "1") {
      status = true;
    } else {
      status = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.translate("loc_email_auth").toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  17.0,
                  Theme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
            ),
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
            )),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  CustomTheme.of(context).secondaryHeaderColor,
                  CustomTheme.of(context).secondaryHeaderColor,
                  // CustomTheme.of(context).primaryColor,
                  // CustomTheme.of(context).disabledColor.withOpacity(0.4),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              CustomTheme.of(context).primaryColorDark,
                              CustomTheme.of(context).primaryColorDark.withOpacity(0.4),
                              CustomTheme.of(context).primaryColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                          color: CustomTheme.of(context).dividerColor.withOpacity(0.4),
                        ),
                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0, right: 3.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 20.0,
                            ),
                            Image.asset(
                              'assets/icons/info.png',
                              height: 20.0,
                              color: CustomTheme.of(context).primaryColorLight,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                AppLocalizations.of(context)!.translate("loc_email_auth_txt").toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    10.0,
                                    Theme.of(context).cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                softWrap: true,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Form(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFormFieldCustom(
                                onEditComplete: () {
                                  emailFocus.unfocus();
                                },
                                radius: 8.0,
                                error: AppLocalizations.of(context)!.translate("loc_enter_cod"),
                                textColor: CustomTheme.of(context).cardColor,
                                borderColor: Colors.transparent,
                                fillColor: CustomTheme.of(context).canvasColor,
                                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                    15.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                                textStyle: CustomWidget(context: context).CustomTextStyle(
                                    CustomTheme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
                                textInputAction: TextInputAction.next,
                                focusNode: emailFocus,
                                maxlines: 1,
                                text: '',
                                hintText: AppLocalizations.of(context)!.translate("loc_verify_code").toString(),
                                obscureText: false,
                                suffix: Container(
                                  width: 0.0,
                                ),
                                textChanged: (value) {},
                                onChanged: () {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Code";
                                  }
                                  return null;
                                },
                                enabled: true,
                                textInputType: TextInputType.number,
                                controller: emailController,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                           InkWell(
                             onTap: (){

                               setState(() {

                                 loading=true;
                                 accessTwoFA();
                               });
                             },
                             child:    Text(
                               AppLocalizations.of(context)!.translate("loc_snd_otp").toString(),
                               style: CustomWidget(context: context).CustomSizedTextStyle(
                                   14.0,
                                   Theme.of(context).cardColor,
                                   FontWeight.w500,
                                   'FontRegular'),
                               textAlign: TextAlign.start,
                             ),
                           ),
                              const SizedBox(
                                height: 45.0,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if(status)
                                    {
                                      disTwoFA();

                                    }
                                    else{
                                      if(codesent)
                                        {
                                          if (emailController.text.isEmpty ) {
                                            CustomWidget(context: context)
                                                .showSuccessAlertDialog(
                                                "Email Authenticator",
                                                "Enter  Code",
                                                "error");
                                          } else {
                                            loading=true;
                                            verifyOTP();



                                          }
                                        }
                                      else{
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog(
                                            "Email Authenticator",
                                            "Send a otp",
                                            "error");
                                      }
                                    }

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
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: Text(
                               status? AppLocalizations.of(context)!.translate("loc_deactive").toString() : AppLocalizations.of(context)!.translate("loc_active").toString(),
                                    style: CustomWidget(context: context).CustomSizedTextStyle(
                                        16.0,
                                        CustomTheme.of(context).primaryColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                            ],
                          ),
                        ),
                        key: emailformKey,
                      )
                    ],
                  ),
                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).primaryColor,
                  )
                      : Container()
                ],
              ),
            )),
      ),
    );
  }

  accessTwoFA() {
    apiUtils.enableTwoFA("email").then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;

          codesent=true;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "success");

        });
      } else {
        setState(() {
          loading = false;
          status=false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  disTwoFA() {
    apiUtils.disableTwoFA("email").then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;

          codesent=false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "success");
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
  verifyOTP() {
    apiUtils.veifyEmailOTP(emailController.text.toString()).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "success");
          Navigator.pop(context, true);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Security", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

}
