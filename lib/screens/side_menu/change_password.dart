import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/text_field_custom_prefix.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';


class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  FocusNode currentpassWordNode = FocusNode();
  FocusNode passWordNode = FocusNode();
  FocusNode confirm_passWordNode = FocusNode();

  bool _currentpasswordVisible = false;


  bool _passwordVisible = false;
  bool _confirmpasswordVisible = false;
  String _confirmpassword = "";
  String _currentpassword = "";
  String _password = "";
  final formKey = GlobalKey<FormState>();
  APIUtils apiUtils = APIUtils();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("loc_change_password").toString(),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
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
                color:  CustomTheme.of(context).shadowColor,
              ),
            ),
          )),
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                CustomTheme.of(context).secondaryHeaderColor,
                CustomTheme.of(context).secondaryHeaderColor,
                // CustomTheme.of(context).primaryColor,
                // CustomTheme.of(context).primaryColor,
                // CustomTheme.of(context).disabledColor.withOpacity(0.4),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child:  Column(
                  children: [

                    Container(
                      width:MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topLeft,
                         end: Alignment.bottomRight,
                         colors: <Color>[
                           CustomTheme.of(context).disabledColor.withOpacity(0.4),
                           CustomTheme.of(context).primaryColor,
                         ],
                         tileMode: TileMode.mirror,
                       ),
                     ),
                      child: Row(
                        children: [
                          const SizedBox(width: 20.0,),
                          SvgPicture.asset('assets/images/info.svg',height: 24.0,color: Theme.of(context).primaryColor,),
                          const SizedBox(width: 10.0,),
                          Flexible(child:  Text(
                            AppLocalizations.of(context)!.translate("loc_changep_info").toString(),

                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                12.0,
                                Theme.of(context).primaryColor,
                                FontWeight.w500,
                                'FontRegular'),
                            textAlign: TextAlign.start,
                            softWrap: true,
                          ),)
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child:  Form(
                          key: formKey,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormCustom(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_currentpasswordVisible,
                                textInputAction: TextInputAction.done,
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0, CustomTheme.of(context).dividerColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                radius: 8.0,
                                focusNode: currentpassWordNode,
                                controller: currentpasswordController,
                                enabled: true,
                                fillColor:   CustomTheme.of(context).canvasColor,
                                onChanged: () {},
                                hintText: AppLocalizations.of(context)!.translate("loc_old_pass").toString(),
                                textChanged: (value) {},
                                prefix: Icon(Icons.lock, color: CustomTheme.of(context).dividerColor,size: 20.0,),

                                suffix: IconButton(
                                  icon: Icon(
                                    _currentpasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: CustomTheme.of(context).dividerColor,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _currentpasswordVisible = !_currentpasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Old Password";
                                  }
                                  else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                      .hasMatch(value)) {
                                    return "Please enter valid Password";
                                  }
                                  else if(value.toString().length<8){
                                    return "Please enter Valid Old Password";
                                  }

                                  return null;
                                },
                                textStyle:CustomWidget(context: context)
                                    .CustomTextStyle(
                                    CustomTheme.of(context).cardColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                borderColor:  CustomTheme.of(context).canvasColor,
                                maxlines: 1,
                                error: AppLocalizations.of(context)!.translate("loc_valid_pass").toString(),
                                text: "",
                                onEditComplete: () {
                                  currentpassWordNode.unfocus();
                                  FocusScope.of(context).requestFocus(passWordNode);
                                },
                                textColor: CustomTheme.of(context).cardColor,
                                textInputType: TextInputType.visiblePassword,
                              ),

                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormCustom(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_passwordVisible,
                                textInputAction: TextInputAction.done,

                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0, CustomTheme.of(context).dividerColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                radius: 8.0,
                                focusNode: passWordNode,
                                controller: passwordController,
                                enabled: true,
                                fillColor:   CustomTheme.of(context).canvasColor,
                                onChanged: () {},

                                hintText:
                                AppLocalizations.of(context)!.translate("loc_current_pass").toString(),
                                textChanged: (value) {},
                                prefix: Icon(Icons.lock, color: CustomTheme.of(context).dividerColor,size: 20.0,),
                                suffix: IconButton(
                                  icon: Icon(
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: CustomTheme.of(context).dividerColor,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter New Password";
                                  }
                                  else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                      .hasMatch(value)) {
                                    return "Please enter valid New Password";
                                  }
                                  else if(value.length<8){
                                    return "Please enter minimum 8 character Password";
                                  }


                                  return null;
                                },
                                textStyle:CustomWidget(context: context)
                                    .CustomTextStyle(
                                    CustomTheme.of(context).cardColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                borderColor:  CustomTheme.of(context).canvasColor,
                                maxlines: 1,
                                error: AppLocalizations.of(context)!.translate("loc_valid_pass").toString(),
                                text: "",
                                onEditComplete: () {
                                  passWordNode.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(confirm_passWordNode);
                                },
                                textColor: CustomTheme.of(context).cardColor,
                                textInputType: TextInputType.visiblePassword,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormCustom(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                obscureText: !_confirmpasswordVisible,
                                textInputAction: TextInputAction.done,
                                hintStyle: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                    14.0, CustomTheme.of(context).dividerColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                radius: 8.0,
                                focusNode: confirm_passWordNode,
                                controller: confirmpasswordController,
                                enabled: true,
                                fillColor:   CustomTheme.of(context).canvasColor,
                                onChanged: () {},
                                hintText: AppLocalizations.of(context)!.translate("loc_new_pass").toString(),
                                textChanged: (value) {},
                                prefix: Icon(Icons.lock, color: CustomTheme.of(context).dividerColor,size: 20.0,),
                                suffix: IconButton(
                                  icon: Icon(
                                    _confirmpasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color:   CustomTheme.of(context).dividerColor,
                                    size: 20.0,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmpasswordVisible = !_confirmpasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter Confirm Password";
                                  }
                                  else if (!RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$")
                                      .hasMatch(value)) {
                                    return "Please enter valid Password";
                                  }
                                  else if(value.length<8){
                                    return "Please enter minimum 8 character Password";
                                  }
                                  return null;
                                },
                                textStyle:CustomWidget(context: context)
                                    .CustomTextStyle(
                                    CustomTheme.of(context).cardColor,
                                    FontWeight.normal,
                                    'FontRegular'),
                                borderColor:  CustomTheme.of(context).canvasColor,
                                maxlines: 1,
                                error: AppLocalizations.of(context)!.translate("loc_valid_pass").toString(),
                                text: "",
                                onEditComplete: () {
                                  currentpassWordNode.unfocus();
                                },
                                textColor:  CustomTheme.of(context).cardColor,
                                textInputType: TextInputType.visiblePassword,
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                width: MediaQuery.of(context).size.width,
                                child:  Text(
                                    AppLocalizations.of(context)!.translate("loc_notes").toString().toUpperCase(),
                                  textAlign: TextAlign.start,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).primaryColorDark,
                                      FontWeight.w600,
                                      'FontRegular'),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                width: MediaQuery.of(context).size.width,
                                child:  Text(
                                  AppLocalizations.of(context)!.translate("loc_change_pass_txt").toString(),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.visible,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      13.0,
                                      Theme.of(context)
                                          .cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),

                              // InkWell(
                              //   onTap: () {
                              //     setState(() {
                              //       FocusScope.of(context).unfocus();
                              //       if (formKey.currentState!.validate()) {
                              //         setState(() {
                              //
                              //           if(passwordController.text.toString()==confirmpasswordController.text.toString())
                              //           {
                              //             print("Mano");
                              //
                              //             loading=true;
                              //             // verifyMail();
                              //
                              //           }
                              //           else
                              //           {
                              //             // CustomWidget(context: context).custombar("Change Password", "New Password and Confirm Password Mismatched", false);
                              //             print("Mano");
                              //           }
                              //
                              //         });
                              //       }
                              //
                              //     });
                              //   },
                              //   child: Container(
                              //       decoration: BoxDecoration(
                              //         color:  CustomTheme.of(context).shadowColor,
                              //         borderRadius:
                              //         BorderRadius.all(Radius.circular(5.0)),
                              //       ),
                              //       padding:
                              //       const EdgeInsets.only(top: 13.0, bottom: 13.0),
                              //       child: Center(
                              //         child: Text(
                              //           AppLocalizations.of(context)!.translate("loc_submit"),
                              //           style:  CustomWidget(context: context)
                              //               .CustomTextStyle(
                              //               CustomTheme.of(context).splashColor,
                              //               FontWeight.w500,
                              //               'FontRegular'),
                              //         ),
                              //       )),
                              // ),

                              InkWell(
                                onTap: (){
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    if (formKey.currentState!.validate()) {
                                      setState(() {

                                        if(passwordController.text.toString()==confirmpasswordController.text.toString())
                                        {
                                          loading=true;
                                          verifyMail();

                                        }
                                        else
                                        {
                                          CustomWidget(context: context).showSuccessAlertDialog("Change Password", "New Password and Confirm Password Mismatched", "error");

                                        }

                                      });
                                    }
                                  });

                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: CustomTheme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("loc_submit").toString(),
                                    style: AppTextStyles.poppinsRegular(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                    ),

                  ],
                ),
              ),

              loading
                  ? CustomWidget(context: context)
                  .loadingIndicator(CustomTheme.of(context).primaryColor)
                  : Container()
            ],
          )),
    ));
  }

  verifyMail() {
    apiUtils
        .doChangePassword(currentpasswordController.text.toString(),passwordController.text.toString(),confirmpasswordController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          currentpasswordController.clear();
          passwordController.clear();
          confirmpasswordController.clear();

        });
        CustomWidget(context: context).showSuccessAlertDialog("Change Password", loginData.message.toString(), "success");
        Navigator.pop(context);

      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Change Password", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

}
