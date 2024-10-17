import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/country.dart';
import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';
import 'login_screen.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  Country? _selectedCountry;
  TextEditingController mobile = TextEditingController();

  TextEditingController mobile_verify = TextEditingController();
  TextEditingController mobile_refer = TextEditingController();
  FocusNode mobileFocus = FocusNode();
  FocusNode mobilePassFocus = FocusNode();
  FocusNode mobileVerifyFocus = FocusNode();
  FocusNode mobileReferFocus = FocusNode();
  TextEditingController email = TextEditingController();
  TextEditingController email_password = TextEditingController();
  TextEditingController email_confirm_password = TextEditingController();
  TextEditingController email_verify = TextEditingController();
  TextEditingController email_refer = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode emailPassFocus = FocusNode();
  FocusNode confirmemailPassFocus = FocusNode();
  FocusNode emailVerifyFocus = FocusNode();
  FocusNode emailreferFocus = FocusNode();
  ScrollController controller = ScrollController();
  bool countryB = false;
  bool isMobile = false;
  bool isDisplay = true;
  bool isEmail = true;
  bool emailVerify = true;
  bool emailCodeVerify = false;
  bool emailPassVerify = false;
  bool emailReferVerify = false;
  final emailformKey = GlobalKey<FormState>();
  final mobileformKey = GlobalKey<FormState>();
  final verifyformKey = GlobalKey<FormState>();
  bool check = false;

  bool getCode = true;

  String token = "";
  var snackBar;

  bool mobileVerify = true;
  bool mobileCodeVerify = false;
  bool mobilePassVerify = true;

  bool mobileReferVerify = false;
  APIUtils apiUtils = APIUtils();

  @override
  void initState() {
    initCountry();
    super.initState();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/icons/language.svg',
                  height: 20.0,
                  color: CustomTheme.of(context).cardColor,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Text(
                  AppLocalizations.of(context)!.translate("loc_eng").toString(),
                  style: CustomWidget(context: context)
                      .CustomSizedTextStyle(
                      16.0,
                      Theme.of(context).cardColor,
                      FontWeight.w400,
                      'FontRegular'),
                ),
                const SizedBox(width: 10,),
              ],
            ),
          ],
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: CustomTheme
            .of(context)
            .primaryColorDark,
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              controller: controller,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        const SizedBox(
                          height: 50.0,
                        ),
                        Text(
                            AppLocalizations.of(context)!.translate("loc_forgot_password").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                20.0,
                                Theme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular')),
                        const SizedBox(
                          height: 30.0,
                        ),

                        const SizedBox(
                          height: 20.0,
                        ),
                        !getCode
                            ? Container()
                            : isMobile
                            ? mobileWidget()
                            : emailWidget(),
                        getCode
                            ? Container()
                            : Form(
                          key: verifyformKey,
                          child: Column(children: [
                            TextFormFieldCustom(
                              onEditComplete: () {
                                mobileVerifyFocus.unfocus();
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return  AppLocalizations.of(context)!.translate("loc_pls_enter_code").toString();
                                }

                                return null;
                              },
                              radius: 5.0,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9@.]')),
                              // ],
                              error: AppLocalizations.of(context)!.translate("loc_valid_email").toString(),
                              textColor: CustomTheme.of(context)
                                  .primaryColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              textInputAction: TextInputAction.next,
                              focusNode: mobileVerifyFocus,
                              maxlines: 1,
                              text: '',
                              hintText: AppLocalizations.of(context)!.translate("loc_enter_verify_code").toString(),
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {},
                              onChanged: () {},
                              enabled: true,
                              textInputType: TextInputType.number,
                              controller: mobile_verify,
                              hintStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),

                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !_passwordVisible,
                              textInputAction: TextInputAction.done,
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                              // ],
                              hintStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              radius: 5.0,
                              focusNode: emailPassFocus,
                              controller: email_password,
                              enabled: true,
                              textColor:
                              CustomTheme.of(context).splashColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              onChanged: () {},
                              hintText: AppLocalizations.of(context)!.translate("loc_new_password").toString(),
                              textChanged: (value) {},
                              suffix: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomTheme.of(context)
                                      .splashColor
                                      .withOpacity(0.5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                                else if(value.length<8){
                                  return "Please enter Valid  Password";
                                }

                                return null;
                              },
                              maxlines: 1,
                              error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
                              text: "",
                              onEditComplete: () {
                                emailPassFocus.unfocus();
                              },
                              textInputType:
                              TextInputType.visiblePassword,

                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: !_confirmpasswordVisible,
                              textInputAction: TextInputAction.done,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_]')),
                              // ],
                              // autovalidateMode: AutovalidateMode.onUserInteraction,
                              hintStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              radius: 5.0,
                              focusNode: confirmemailPassFocus,
                              controller: email_confirm_password,
                              enabled: true,
                              textColor:
                              CustomTheme.of(context).primaryColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              onChanged: () {},
                              hintText: AppLocalizations.of(context)!.translate("loc_confirm_password").toString(),
                              textChanged: (value) {},
                              suffix: IconButton(
                                icon: Icon(
                                  _confirmpasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: CustomTheme.of(context)
                                      .primaryColor
                                      .withOpacity(0.5),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmpasswordVisible =
                                    !_confirmpasswordVisible;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Confirm Password";
                                }
                                return null;
                              },
                              maxlines: 1,
                              error: AppLocalizations.of(context)!.translate("loc_valid_pass").toString(),
                              text: "",
                              onEditComplete: () {
                                confirmemailPassFocus.unfocus();
                              },
                              textInputType:
                              TextInputType.visiblePassword,

                            ),
                            const SizedBox(
                              height: 20.0,
                            ),

                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              child:  Text(
                                AppLocalizations.of(context)!.translate("loc_note").toString().toUpperCase(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                    fontFamily: 'BALLOBHAI-REGULAR',
                                    fontSize: 12.0),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              width: MediaQuery.of(context).size.width,
                              child:  Text(
                                AppLocalizations.of(context)!.translate("loc_pass_sec").toString(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black87,
                                    fontFamily: 'BALLOBHAI-REGULAR',
                                    fontSize: 11.0),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),

                        InkWell(
                          onTap: (){
                            setState(() {

                              FocusScope.of(context).unfocus();
                              if (getCode) {
                                if (isEmail) {
                                  if(email.text.isEmpty  || !RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email.text))                         {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot", "Please Enter Email", "error");

                                  }
                                  else{
                                    loading = true;
                                    sendCodeMail();
                                  }

                                } else {
                                  if(mobile.text.isEmpty)
                                  {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot", "Please Enter Mobile Number", "error");

                                  }
                                  else {
                                    setState(() {

                                    });
                                  }
                                }
                              } else {
                                if (verifyformKey.currentState!.validate()) {
                                  if (email_password.text.toString() ==
                                      email_confirm_password.text
                                          .toString()) {
                                    if (isEmail) {
                                      setState(() {
                                        verifyMail();

                                      });
                                    } else {
                                      setState(() {

                                      });
                                    }
                                  } else {
                                    CustomWidget(context: context).showSuccessAlertDialog("Forgot Password",
                                        "Password and confirm password do not match", "error");
                                  }
                                }
                              }
                            });

                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                             color: CustomTheme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                                getCode ? AppLocalizations.of(context)!.translate("loc_send_code").toString() : AppLocalizations.of(context)!.translate("loc_verify_code").toString(),
                              style: AppTextStyles.poppinsRegular(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            AppLocalizations.of(context)!.translate("loc_cancel").toString(),
                            textAlign: TextAlign.center,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                Theme.of(context).primaryColor,
                                FontWeight.normal,
                                'FontRegular'),

                          ),
                        ),

                      ],
                    ),
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

  Widget mobileWidget() {
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 14.0, bottom: 14.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: CustomTheme.of(context)
                            .canvasColor,
                        width: 1.0),
                    color: CustomTheme.of(context)
                        .canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    ),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _onPressedShowBottomSheet,
                        child: Row(
                          children: [
                            Text(
                              countryB
                                  ? _selectedCountry!.callingCode.toString()
                                  : "+1",
                              style: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context).primaryColor,
                                  FontWeight.normal,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              width: 3.0,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 15.0,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                    ],
                  )),
              Flexible(
                child: TextFormField(
                  controller: mobile,
                  focusNode: mobileFocus,
                  maxLines: 1,
                  enabled: mobileVerify,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  style: CustomWidget(context: context).CustomTextStyle(
                      Theme.of(context).primaryColor,
                      FontWeight.w500,
                      'FontRegular'),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 12, right: 0, top: 2, bottom: 2),
                    hintText: AppLocalizations.of(context)!.translate("loc_pls_enter_mobile"),
                    hintStyle: CustomWidget(context: context).CustomTextStyle(
                        Theme.of(context).dividerColor,
                        FontWeight.w400,
                        'FontRegular'),
                    filled: true,
                    fillColor: CustomTheme.of(context)
                        .canvasColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .canvasColor,
                          width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .canvasColor,
                          width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .canvasColor,
                          width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                      borderSide: BorderSide(
                          color: CustomTheme.of(context)
                              .canvasColor,
                          width: 1.0),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
      key: mobileformKey,
    );
  }

  Widget emailWidget() {
    return Form(
      child: Column(
        children: [
          TextFormFieldCustom(
            onEditComplete: () {
              emailFocus.unfocus();
              FocusScope.of(context).requestFocus(emailPassFocus);
            },
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            radius: 5.0,
            error:  AppLocalizations.of(context)!.translate("loc_valid_email").toString(),
            textColor: CustomTheme.of(context).primaryColor,
            borderColor: CustomTheme.of(context).canvasColor,
            fillColor: CustomTheme.of(context).canvasColor,
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            maxlines: 1,
            text: '',
            hintText: AppLocalizations.of(context)!.translate("loc_email").toString(),
            // inputFormatters: [
            //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9.]')),
            // ],
            obscureText: false,
            suffix: Container(
              width: 0.0,
            ),
            textChanged: (value) {},
            onChanged: () {},
            validator: (value) {
              if (value!.isEmpty) {
                return "Please enter email";
              } else if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return "Please enter valid email";
              }

              return null;
            },
            enabled: true,
            textInputType: TextInputType.emailAddress,
            controller: email,
            hintStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).dividerColor,
                FontWeight.w400,
                'FontRegular'),
            textStyle: CustomWidget(context: context).CustomTextStyle(
                Theme.of(context).primaryColor, FontWeight.w500, 'FontRegular'),

          ),
          const SizedBox(
            height: 20.0,
          ),

        ],
      ),
      key: emailformKey,
    );
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheets(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  sendCodeMail() {
    apiUtils
        .forgotPassword(email.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          getCode = false;
          isDisplay=false;
        });
        // custombar("Forgot Password", loginData.message.toString(), true);
        CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_forgot").toString(),
            AppLocalizations.of(context)!.translate("loc_forgot_email").toString(), "success");

      } else {
        setState(() {

          loading = false;
          // custombar("Forgot Password", loginData.message.toString(), false);
          CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_forgot").toString(),
              loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }



  verifyMail() {
    apiUtils
        .doVerifyOTP(email.text.toString(),mobile_verify.text.toString(),email_password.text.toString(),email_confirm_password.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          emailVerify = true;

          email.clear();
          mobile_verify.clear();
          email_verify.clear();
          email_confirm_password.clear();

          mobileCodeVerify = true;
        });
        CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_forgot").toString(),
            AppLocalizations.of(context)!.translate("loc_change_pass").toString(), "success");

        // custombar("Forgot Password", loginData.message.toString(), true);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Login_Screen()));

      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_forgot").toString(),
              loginData.message.toString(), "error");

          // custombar("Forgot Password", loginData.message.toString(), false);
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

// verifyMobile() {
//   print(mobile_verify.text);
//   apiUtils
//       .doVerifyOTP(APIUtils.verifyMobileOtpURL,_selectedCountry!.callingCode.toString()+ mobile.text.toString(),
//       mobile_verify.text.toString(), false)
//       .then((SentOtpModel loginData) {
//     if (loginData.status.toString() == "Success") {
//       setState(() {
//         loading = false;
//         emailVerify = true;
//         emailCodeVerify = false;
//         emailPassVerify = false;
//         emailReferVerify = false;
//         email.clear();
//         email_password.clear();
//         email_verify.clear();
//         email_refer.clear();
//
//         mobileCodeVerify = true;
//       });
//       custombar("Register", loginData.message.toString(), true);
//     } else {
//       setState(() {
//         loading = false;
//         custombar("Register", loginData.message.toString(), false);
//       });
//     }
//   }).catchError((Object error) {
//     setState(() {
//       loading = false;
//     });
//   });
// }

}
