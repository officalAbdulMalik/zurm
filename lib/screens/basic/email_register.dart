import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/screens/basic/register_success.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/otp_fields/otp_field_custom.dart';
import '../../common/otp_fields/style.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';

class EmailRegister_Screen extends StatefulWidget {
  const EmailRegister_Screen({Key? key}) : super(key: key);

  @override
  State<EmailRegister_Screen> createState() => _EmailRegister_ScreenState();
}

class _EmailRegister_ScreenState extends State<EmailRegister_Screen> {

  bool otp= false;

  FocusNode emailFocus = FocusNode();
  FocusNode codeFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  String _Otp="";

  APIUtils  apiUtils=APIUtils();
  bool loading=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    otp = true;
  }
  @override
  Widget build(BuildContext context) {
    return  MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).focusColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: CustomTheme.of(context).focusColor, // For iOS: (dark icons)
          statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
        ),
        elevation: 0.0,
        // toolbarHeight: 0.0,
        leading: Padding(
            padding: EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
            child: InkWell(
              onTap: () {
                // Navigator.push(context,MaterialPageRoute(builder:(context)=> Home_Screen()));
                Navigator.pop(context);
              },
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: CustomTheme.of(context).dialogBackgroundColor.withOpacity(0.4),
                  size: 22.0,
                ),
              ),
            )),
        title: Text(
          AppLocalizations.of(context)!.translate("loc_sign_up").toString() ,
          style: CustomWidget(context: context)
              .CustomSizedTextStyle(
              18.0,
              CustomTheme.of(context).shadowColor,
              FontWeight.w600,
              'FontRegular'),
        ),
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
          child:  Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    otp? AppLocalizations.of(context)!.translate("loc_reg_email").toString() : AppLocalizations.of(context)!.translate("loc_enter_code").toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        26.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w600,
                        'FontRegular'),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    otp? AppLocalizations.of(context)!.translate("loc_reg_txt").toString() : AppLocalizations.of(context)!.translate("loc_reg_txt_code").toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        12.0,
                        CustomTheme.of(context).shadowColor,
                        FontWeight.w400,
                        'FontRegular'),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  GradientText(
                    otp? "":AppLocalizations.of(context)!.translate("loc_reg_test_email").toString(),
                    style: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                        13.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                    colors: [
                      CustomTheme.of(context).primaryColorDark,
                      CustomTheme.of(context).primaryColorLight,
                    ],
                  ),

                  Container(
                    margin: otp? EdgeInsets.only(top: MediaQuery.of(context).size.height *0.08): EdgeInsets.only(top: MediaQuery.of(context).size.height *0.03),
                    child: SingleChildScrollView(
                      child: otp? Email(): Otp(),
                    ),
                  )

                ],
              )
            ],
          ),
        ),
      ),
    ));
  }


  Widget Email(){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.translate("loc_email").toString(),
            style: CustomWidget(context: context).CustomSizedTextStyle(
                13.0,
                CustomTheme.of(context).cardColor,
                FontWeight.w500,
                'FontRegular'),
          ),
          const SizedBox(height: 8.0,),
          TextFormFieldCustom(
            onEditComplete: () {
              emailFocus.unfocus();
              // FocusScope.of(context).requestFocus(passwordFocus);
            },
            radius: 8.0,
            error: AppLocalizations.of(context)!.translate("loc_email_enter").toString(),
            textColor: CustomTheme.of(context).primaryColor,
            borderColor: Colors.transparent,
            fillColor: CustomTheme.of(context).canvasColor,
            hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                15.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
            textStyle: CustomWidget(context: context).CustomTextStyle(
                CustomTheme.of(context).primaryColor, FontWeight.w500, 'FontRegular'),
            textInputAction: TextInputAction.next,
            focusNode: emailFocus,
            maxlines: 1,
            text: '',
            hintText: AppLocalizations.of(context)!.translate("loc_email_hint").toString(),
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
            controller: emailController,
            // errorStyle: TextStyle(
            //     color: Colors.red
            // ),
          ),
          const SizedBox(
            height: 40.0,
          ),
          InkWell(
            onTap: (){
              if(otp == true){
                setState(() {
                  otp = false;
                });
              }else{
                setState(() {
                  otp = true;
                });
              }

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
                AppLocalizations.of(context)!.translate("loc_sent_otp").toString(),
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    17.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget Otp(){
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OTPTextField(
            controller: otpController,
            length: 4,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 50,
            style: TextStyle(
              color: CustomTheme.of(context).primaryColor,
              fontSize: 20,
              fontFamily: 'UberMove',
              fontWeight: FontWeight.w600,
            ),
            textFieldAlignment: MainAxisAlignment.center,
            spaceBetween: 50.0,
            fieldStyle: FieldStyle.box,
            onChanged: (val){

            },
            onCompleted: (pin) {
              setState(() {
                print("Completed: " + pin.toString());
                _Otp=pin.toString();
              });
            },
            outlineBorderRadius: 8.0,
          ),
          SizedBox(height: 20.0,),
          GestureDetector(
            onTap: (){

            },
            child: Text(
              AppLocalizations.of(context)!.translate("loc_resend_code").toString(),
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  14.0,
                  CustomTheme.of(context).shadowColor,
                  FontWeight.w400,
                  'FontRegular'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5.0,),
          GestureDetector(
            onTap: (){

            },
            child: GradientText(
              AppLocalizations.of(context)!.translate("loc_resend_link").toString(),
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  14.0,
                  CustomTheme.of(context).cardColor,
                  FontWeight.w400,
                  'FontRegular'),
              colors: [
                CustomTheme.of(context).primaryColorDark,
                CustomTheme.of(context).primaryColorLight,
              ],
            ),
          ),

          const SizedBox(
            height: 40.0,
          ),
          InkWell(
            onTap: (){
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Register_Success_Screen(),
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
                AppLocalizations.of(context)!.translate("loc_conti").toString(),
                style: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    17.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),



        ],
      ),
    );
  }


}
