import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';

class GoogleTFAScreen extends StatefulWidget {
  final String code;
  final String type;

  const GoogleTFAScreen({
    Key? key,
    required this.code,
    required this.type,
  }) : super(key: key);

  @override
  State<GoogleTFAScreen> createState() => _GoogleTFAScreenState();
}

class _GoogleTFAScreenState extends State<GoogleTFAScreen> {
  APIUtils apiUtils = APIUtils();
  String appName = "zurumi";

  bool codesent=false;
  // Googletfa? details;
  String qrCode = "";
  String qrImage = "";
  bool status = false;
  TextEditingController code = TextEditingController();
  GlobalKey globalKeyauth = GlobalKey(debugLabel: 'auth');
  FocusNode codeFocus = FocusNode();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    qrCode = widget.code;
    qrImage = "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
        widget.code;
    if (widget.type == "1") {
      status = true;
    } else {
      status = false;
    }

    // loading = true;
    // getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: WillPopScope(
        child: Scaffold(
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
              AppLocalizations.of(context)!.translate("loc_goo_auth").toString(),
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
                  CustomTheme.of(context).primaryColor,
                  // CustomTheme.of(context).disabledColor.withOpacity(0.4),
                ],
                tileMode: TileMode.mirror,
              ),
            ),
            child: Stack(
              children: [
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        Theme.of(context).primaryColor,
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10.0,
                              ),
                              !status
                                  ? Column(
                                      children: [
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        qrImage == ""
                                            ? Container()
                                            : Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.15,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5.0)),
                                                    color: Theme.of(context)
                                                        .focusColor,
                                                    border: Border.all(
                                                      width: 0.2,
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    )),
                                                child: Image.network(qrImage),
                                              ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            border: Border.all(width: 1.0, color: Theme.of(context).primaryColorLight,)
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  qrCode,
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w500,
                                                      'FontRegular'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text: qrCode.toString()));
                                                  CustomWidget(context: context)
                                                      .showSuccessAlertDialog(
                                                      "Google TFA",
                                                      "Secret Key Copied to Clipboard...!",
                                                      "success");
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color:
                                                  Theme.of(context).hintColor,
                                                  size: 25.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        codesent?          TextFormFieldCustom(
                                          onEditComplete: () {
                                            codeFocus.unfocus();
                                            // FocusScope.of(context).requestFocus(signupPasswordFocus);
                                          },
                                          radius: 8.0,
                                          error: AppLocalizations.of(context)!.translate("loc_enter_goo"),
                                          textColor: CustomTheme.of(context)
                                              .primaryColor,
                                          borderColor: Colors.transparent,
                                          fillColor: CustomTheme.of(context)
                                              .canvasColor,
                                          hintStyle:
                                              CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                      15.0,
                                                      CustomTheme.of(context)
                                                          .dividerColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                          textStyle:
                                              CustomWidget(context: context)
                                                  .CustomTextStyle(
                                                      CustomTheme.of(context)
                                                          .primaryColor,
                                                      FontWeight.w500,
                                                      'FontRegular'),
                                          textInputAction: TextInputAction.next,
                                          focusNode: codeFocus,
                                          maxlines: 1,
                                          text: '',
                                          hintText: AppLocalizations.of(context)!.translate("loc_goo_cod").toString(),
                                          obscureText: false,
                                          suffix: Container(
                                            width: 0.0,
                                          ),
                                          textChanged: (value) {},
                                          onChanged: () {},
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter Google Code";
                                            }
                                            return null;
                                          },
                                          enabled: true,
                                          textInputType: TextInputType.number,
                                          controller: code,
                                        ):Container(),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 60.0,
                                        ),
                                        codesent?                    TextFormFieldCustom(
                                          onEditComplete: () {
                                            codeFocus.unfocus();
                                            // FocusScope.of(context).requestFocus(signupPasswordFocus);
                                          },
                                          radius: 8.0,
                                          error: AppLocalizations.of(context)!.translate("loc_enter_goo"),
                                          textColor: CustomTheme.of(context)
                                              .primaryColor,
                                          borderColor: Colors.transparent,
                                          fillColor: CustomTheme.of(context)
                                              .canvasColor,
                                          hintStyle:
                                              CustomWidget(context: context)
                                                  .CustomSizedTextStyle(
                                                      15.0,
                                                      CustomTheme.of(context)
                                                          .dividerColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                          textStyle:
                                              CustomWidget(context: context)
                                                  .CustomTextStyle(
                                                      CustomTheme.of(context)
                                                          .primaryColor,
                                                      FontWeight.w500,
                                                      'FontRegular'),
                                          textInputAction: TextInputAction.next,
                                          focusNode: codeFocus,
                                          maxlines: 1,
                                          text: '',
                                          hintText: AppLocalizations.of(context)!.translate("loc_goo_cod").toString(),
                                          obscureText: false,
                                          suffix: Container(
                                            width: 0.0,
                                          ),
                                          textChanged: (value) {},
                                          onChanged: () {},
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please enter Google Code";
                                            }
                                            return null;
                                          },
                                          enabled: true,
                                          textInputType: TextInputType.number,
                                          controller: code,

                                        ):Container(),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                      ],
                                    ),
                              InkWell(
                                onTap: () {
                                  setState(() {

                                    if(codesent)
                                      {
                                        if(status)
                                          {
                                            disTwoFA();

                                          }
                                        else{
                                          if (code.text.isEmpty) {
                                            CustomWidget(context: context)
                                                .showSuccessAlertDialog(
                                                "Google Authenticator",
                                                "Enter Goolge Auth Code",
                                                "error");
                                          } else {
                                            loading=true;
                                            verifyOTP();

                                          }
                                        }
                                      }
                                    else{
                                     accessTwoFA();
                                    }
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 12.0, bottom: 12.0),
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                             ! codesent?    AppLocalizations.of(context)!.translate("loc_enable").toString():codesent&!status ?
                             AppLocalizations.of(context)!.translate("loc_verify_code").toString()
                                 : AppLocalizations.of(context)!.translate("loc_disable").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            17.0,
                                            CustomTheme.of(context).primaryColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_notes").toString().toUpperCase(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).primaryColorDark,
                                              FontWeight.w600,
                                              'FontRegular'),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_tfa_txt").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              13.0,
                                              Theme.of(context).dividerColor,
                                              FontWeight.normal,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pop(true);
          setState(() {
            loading = false;
          });
          return false;
        },
      ),
    );
  }

  accessTwoFA() {
    apiUtils.enableTwoFA("google").then((CommonModel loginData) {
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
          codesent=false;
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
    apiUtils.disableTwoFA("google").then((CommonModel loginData) {
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
    apiUtils.veifyEmailOTP(code.text.toString()).then((CommonModel loginData) {
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

  storeData(bool google) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("tfa", google);
  }
}
