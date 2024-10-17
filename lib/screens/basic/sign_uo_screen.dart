import 'package:flutter/material.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/textformfield_custom.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/screens/basic/login_screen.dart';
import 'package:zurumi/screens/basic/register_success.dart';

class SignUpScreen extends StatefulWidget {
   const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  FocusNode emailFocus = FocusNode();

  FocusNode signupEmailFocus = FocusNode();

  FocusNode fnameFocus = FocusNode();

  FocusNode refCodeFocus = FocusNode();

  FocusNode lnameFocus = FocusNode();

  FocusNode passFocus = FocusNode();

  FocusNode signupPasswordFocus = FocusNode();

  FocusNode conPassFocus = FocusNode();

  bool passVisible = true;
  bool conpassVisible = false;
  bool loading = false;

   TextEditingController emailController = TextEditingController();

   TextEditingController signupEmailController = TextEditingController();

   TextEditingController fnameController = TextEditingController();

   TextEditingController lnameController = TextEditingController();

   TextEditingController passwordController = TextEditingController();

   TextEditingController signupPasswordController = TextEditingController();

   TextEditingController mobileController = TextEditingController();

   TextEditingController conPasswordController = TextEditingController();

   TextEditingController refCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!
              .translate("loc_sign_up")
              .toString(),
          style:AppTextStyles.poppinsRegular(
            fontWeight: FontWeight.w500,
            fontSize: 16
          )
        ),
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20.0,
              ),

              Text(
                AppLocalizations.of(context)!
                    .translate("loc_first_name")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                onEditComplete: () {

                },
                radius: 8.0,
                error: AppLocalizations.of(context)!
                    .translate("loc_name_hint")
                    .toString(),
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                textInputAction: TextInputAction.next,
                focusNode: fnameFocus,
                maxlines: 1,
                text: '',
                hintText: AppLocalizations.of(context)!
                    .translate("loc_name_hnt")
                    .toString(),
                obscureText: false,
                suffix: Container(
                  width: 0.0,
                ),
                textChanged: (value) {},
                onChanged: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter First Name";
                  }
                  return null;
                },
                enabled: true,
                textInputType: TextInputType.name,
                controller: fnameController,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_last_name")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                onEditComplete: () {
                  lnameFocus.unfocus();
                  FocusScope.of(context).requestFocus(emailFocus);
                },
                radius: 8.0,
                error: AppLocalizations.of(context)!
                    .translate("loc_lname_hint")
                    .toString(),
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
                textInputAction: TextInputAction.next,
                focusNode: emailFocus,
                maxlines: 1,
                text: '',
                hintText: AppLocalizations.of(context)!
                    .translate("loc_lname_hnt")
                    .toString(),
                obscureText: false,
                suffix: Container(
                  width: 0.0,
                ),
                textChanged: (value) {},
                onChanged: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Last Name";
                  }
                  return null;
                },
                enabled: true,
                textInputType: TextInputType.name,
                controller: lnameController,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate("loc_email")
                        .toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        13.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),

                  // GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       if(email ==true) {
                  //         email = false;
                  //         emailController.clear();
                  //       }
                  //       else {
                  //         email = true;
                  //         mobileController.clear();
                  //       }
                  //     });
                  //   },
                  //   child: GradientText(
                  //     email? "Sign in with mobile": "Sign in with Email"  ,
                  //     style: CustomWidget(context: context)
                  //         .CustomSizedTextStyle(
                  //         13.0,
                  //         CustomTheme.of(context).cardColor,
                  //         FontWeight.w500,
                  //         'FontRegular'),
                  //     colors: [
                  //       CustomTheme.of(context).backgroundColor,
                  //       CustomTheme.of(context).bottomAppBarColor,
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                onEditComplete: () {
                  signupEmailFocus.unfocus();
                  FocusScope.of(context).requestFocus(signupPasswordFocus);
                },
                radius: 8.0,
                error: AppLocalizations.of(context)!
                    .translate("loc_email_enter"),
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor:
                CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                textInputAction: TextInputAction.next,
                focusNode: signupEmailFocus,
                maxlines: 1,
                text: '',
                hintText: AppLocalizations.of(context)!
                    .translate("loc_email_hint")
                    .toString(),
                obscureText: false,
                suffix: Container(
                  width: 0.0,
                ),
                textChanged: (value) {},
                onChanged: () {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Email";
                  } else if (!RegExp(
                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Please enter valid Email";
                  }
                  return null;
                },
                enabled: true,
                textInputType: TextInputType.emailAddress,
                controller: signupEmailController,
              ),
              //     : Container(
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     color: CustomTheme.of(context).canvasColor,
              //     borderRadius: BorderRadius.circular(8.0),
              //   ),
              //   padding: EdgeInsets.only(left: 1.0, right: 3.0, top: 1.0),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Container(
              //         padding: const EdgeInsets.only(
              //             left: 7.0, right: 10.0, top: 14.0, bottom: 14.0),
              //         decoration: BoxDecoration(
              //           color: CustomTheme.of(context).canvasColor,
              //           borderRadius: BorderRadius.only(
              //             topLeft: Radius.circular(5.0),
              //             bottomLeft: Radius.circular(5.0),
              //           ),
              //         ),
              //         child: Row(
              //           children: [
              //             InkWell(
              //               onTap: _onPressedShowBottomSheet,
              //               child: Row(
              //                 children: [
              //                   countryB
              //                       ? Image.asset(
              //                     _selectedCountry!.flag.toString(),
              //                     package:
              //                     "country_calling_code_picker",
              //                     height: 20.0,
              //                     width: 25.0,
              //                   )
              //                       : Container(
              //                     width: 0.0,
              //                   ),
              //                   const SizedBox(
              //                     width: 5.0,
              //                   ),
              //                   Text(
              //                     countryB
              //                         ? _selectedCountry!.callingCode
              //                         .toString()
              //                         : "+1",
              //                     style: TextStyle(
              //                         color: CustomTheme.of(context)
              //                             .dividerColor,
              //                         fontFamily: 'UberMove',
              //                         fontSize: 16.0),
              //                   ),
              //                   const SizedBox(
              //                     width: 3.0,
              //                   ),
              //                   const Icon(
              //                     Icons.keyboard_arrow_down_outlined,
              //                     size: 15.0,
              //                     color: Colors.white,
              //                   )
              //                 ],
              //               ),
              //             ),
              //             const SizedBox(
              //               width: 10.0,
              //             ),
              //             Container(
              //               height: 20.0,
              //               width: 1.0,
              //               color: CustomTheme.of(context).dividerColor,
              //             )
              //           ],
              //         ),
              //       ),
              //       Container(
              //         child: Flexible(
              //           flex: 1,
              //           child: TextFormField(
              //             onEditingComplete: () {
              //               mobileFocus.unfocus();
              //             },
              //             controller: mobileController,
              //             maxLength: 15,
              //             focusNode: mobileFocus,
              //             enabled: true,
              //             textInputAction: TextInputAction.next,
              //             keyboardType: TextInputType.number,
              //             style: CustomWidget(context: context)
              //                 .CustomSizedTextStyle(
              //                 16.0,
              //                 CustomTheme.of(context).primaryColor,
              //                 FontWeight.w400,
              //                 'FontRegular'),
              //             decoration: InputDecoration(
              //               counterText: ""
              //                   "",
              //               contentPadding: const EdgeInsets.only(
              //                   left: 12, right: 0, top: 2, bottom: 2),
              //               hintText: "456 321 7896",
              //               hintStyle: TextStyle(
              //                   color: CustomTheme.of(context).dividerColor,
              //                   fontFamily: 'UberMoveLight',
              //                   fontSize: 16.0),
              //               border: InputBorder.none,
              //               fillColor: CustomTheme.of(context)
              //                   .canvasColor
              //                   .withOpacity(0.2),
              //               enabledBorder: InputBorder.none,
              //               focusedBorder: InputBorder.none,
              //               errorBorder: InputBorder.none,
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_password")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                obscureText: passVisible,
                textInputAction: TextInputAction.next,
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                radius: 8.0,
                focusNode: signupPasswordFocus,
                suffix: IconButton(
                  icon: Icon(
                    passVisible ? Icons.visibility : Icons.visibility_off,
                    color: CustomTheme.of(context).dividerColor,
                  ),
                  onPressed: () {
                    setState(() {
                      passVisible = !passVisible;
                    });
                  },
                ),
                controller: signupPasswordController,
                enabled: true,
                onChanged: () {},
                hintText: AppLocalizations.of(context)!
                    .translate("loc_pass_hint")
                    .toString(),
                textChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Password";
                  }

                  return null;
                },
                maxlines: 1,
                error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
                text: "",
                onEditComplete: () {
                  signupPasswordFocus.unfocus();
                },
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_conf_password")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                obscureText: !conpassVisible,
                textInputAction: TextInputAction.next,
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                radius: 8.0,
                focusNode: conPassFocus,
                suffix: IconButton(
                  icon: Icon(
                    conpassVisible ? Icons.visibility : Icons.visibility_off,
                    color: CustomTheme.of(context).dividerColor,
                  ),
                  onPressed: () {
                    setState(() {
                      conpassVisible = !conpassVisible;
                    });
                  },
                ),
                controller: conPasswordController,
                enabled: true,
                onChanged: () {},
                hintText: AppLocalizations.of(context)!
                    .translate("loc_pass_hint")
                    .toString(),
                textChanged: (value) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Confirm Password";
                  }

                  return null;
                },
                maxlines: 1,
                error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
                text: "",
                onEditComplete: () {
                  conPassFocus.unfocus();
                },
                textInputType: TextInputType.visiblePassword,
              ),
              const SizedBox(
                height: 8.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                AppLocalizations.of(context)!
                    .translate("loc_referral")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormFieldCustom(
                obscureText: false,
                textInputAction: TextInputAction.next,
                textColor: CustomTheme.of(context).cardColor,
                borderColor: Colors.transparent,
                fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    15.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w400,
                    'FontRegular'),
                textStyle: CustomWidget(context: context).CustomTextStyle(
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                radius: 8.0,
                focusNode: refCodeFocus,
                suffix: IconButton(
                  icon: Icon(
                    Icons.paste_outlined,
                    color: CustomTheme.of(context).dividerColor,
                  ),
                  onPressed: () {
                    setState(() {});
                  },
                ),
                controller: refCodeController,
                enabled: true,
                onChanged: () {},
                hintText: AppLocalizations.of(context)!
                    .translate("loc_ref_code")
                    .toString(),
                textChanged: (value) {},
                validator: (value) {
                  return null;
                },
                maxlines: 1,
                error:
                AppLocalizations.of(context)!.translate("loc_valid_ref_code"),
                text: "",
                onEditComplete: () {
                  refCodeFocus.unfocus();
                },
                textInputType: TextInputType.number,
              ),
              const SizedBox(
                height: 8.0,
              ),
              // GradientText(
              //   AppLocalizations.of(context)!.translate("loc_forgot_password"),
              //   style: CustomWidget(context: context)
              //       .CustomSizedTextStyle(
              //       13.0,
              //       CustomTheme.of(context).cardColor,
              //       FontWeight.w500,
              //       'FontRegular'),
              //   colors: [
              //     CustomTheme.of(context).backgroundColor,
              //     CustomTheme.of(context).bottomAppBarColor,
              //   ],
              // ),
              const SizedBox(
                height: 30.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (formKey.currentState!.validate()) {
                           loading = true;
                          registerMail();
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: <Color>[
                            CustomTheme.of(context).primaryColor,
                            CustomTheme.of(context).primaryColor,
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_sign_up")
                            .toString(),
                        style: AppTextStyles.poppinsRegular(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const Login_Screen();
                      },));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("alirdy_have_account")??"",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              13.0,
                              CustomTheme.of(context).dividerColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                        const SizedBox(width: 10,),
                        Text(
                          AppLocalizations.of(context)!.translate("loc_login")??"",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              13.0,
                              CustomTheme.of(context).dividerColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Flexible(child: InkWell(
                  //       onTap: (){
                  //
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           color: CustomTheme.of(context).canvasColor,
                  //         ),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SvgPicture.asset("assets/images/fb.svg",height: 22.0,),
                  //             const SizedBox(
                  //               width: 5.0,
                  //             ),
                  //             Text(
                  //               AppLocalizations.of(context)!.translate("loc_fb"),
                  //               style: CustomWidget(context: context)
                  //                   .CustomSizedTextStyle(
                  //                   13.0,
                  //                   CustomTheme.of(context).focusColor,
                  //                   FontWeight.w500,
                  //                   'FontRegular'),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     )),
                  //     const SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     Flexible(child:  InkWell(
                  //       onTap: (){
                  //
                  //       },
                  //       child: Container(
                  //         padding: EdgeInsets.only(top: 11.0,bottom: 11.0),
                  //         alignment: Alignment.center,
                  //         width: MediaQuery.of(context).size.width,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //           color: CustomTheme.of(context).canvasColor,
                  //         ),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             SvgPicture.asset("assets/images/google.svg",height: 22.0,),
                  //             const SizedBox(
                  //               width: 5.0,
                  //             ),
                  //             Text(
                  //               AppLocalizations.of(context)!.translate("loc_google"),
                  //               style: CustomWidget(context: context)
                  //                   .CustomSizedTextStyle(
                  //                   13.0,
                  //                   CustomTheme.of(context).focusColor,
                  //                   FontWeight.w500,
                  //                   'FontRegular'),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ),)
                  //   ],
                  // ),
                  const SizedBox(
                    height: 45.0,
                  ),
                  // Container(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       SvgPicture.asset("assets/images/finger_print.svg",height: 40.0,),
                  //       const SizedBox(
                  //         height: 20.0,
                  //       ),
                  //       Text(
                  //         "Use fingerprint instead?",
                  //         style: CustomWidget(context: context)
                  //             .CustomSizedTextStyle(
                  //             13.0,
                  //             CustomTheme.of(context).cardColor,
                  //             FontWeight.w500,
                  //             'FontRegular'),
                  //       )
                  //     ],
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  registerMail() {
    APIUtils()
        .doVerifyRegister(
        fnameController.text.toString(),
        lnameController.text.toString(),
        signupEmailController.text.toString(),
        signupPasswordController.text.toString(),
        conPasswordController.text.toString(),
        refCodeController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          // signin = false;
          fnameController.clear();
          lnameController.clear();
          signupEmailController.clear();
          signupPasswordController.clear();
          conPasswordController.clear();
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_reg").toString(),
              AppLocalizations.of(context)!.translate("loc_reg_msg").toString(),
              "success");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Register_Success_Screen(),
            ),
          );
        });
      } else {
        setState(() {
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_reg").toString(),
              AppLocalizations.of(context)!
                  .translate("loc_regis_msg")
                  .toString(),
              "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }
}
