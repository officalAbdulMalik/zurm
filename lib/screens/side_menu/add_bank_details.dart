import 'package:flutter/material.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';

import '../../../common/custom_widget.dart';

import '../../../common/textformfield_custom.dart';
import '../../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';

class AddBankScreen extends StatefulWidget {
  const AddBankScreen({Key? key}) : super(key: key);

  @override
  State<AddBankScreen> createState() => _AddBankScreenState();
}

class _AddBankScreenState extends State<AddBankScreen> {
  final List<String> trasnType = [];
  final List<String> accType = [];
  final List<String> nationalType = [];
  bool loading = false;
  String selectedtrasnType = "";
  String selectedaccType = "";
  String selectednationalType = "";

  TextEditingController accnumContoller = TextEditingController();
  TextEditingController routnumContoller = TextEditingController();
  TextEditingController wireroutnumContoller = TextEditingController();
  TextEditingController bankNameContoller = TextEditingController();
  TextEditingController ifscnumContoller = TextEditingController();
  TextEditingController wireInsContoller = TextEditingController();

  FocusNode accnumFocus = FocusNode();
  FocusNode routnumFocus = FocusNode();
  FocusNode wireroutnumFocus = FocusNode();
  FocusNode bankNameFocus = FocusNode();
  FocusNode ifscnumFocus = FocusNode();
  FocusNode wireInsFocus = FocusNode();
  APIUtils apiUtils = APIUtils();
  final emailformKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    trasnType
        .add(AppLocalizations.of(context)!.translate("loc_indu").toString());
    trasnType
        .add(AppLocalizations.of(context)!.translate("loc_corp").toString());
    accType
        .add(AppLocalizations.of(context)!.translate("loc_current").toString());
    accType
        .add(AppLocalizations.of(context)!.translate("loc_savings").toString());

    nationalType
        .add(AppLocalizations.of(context)!.translate("loc_false").toString());
    nationalType
        .add(AppLocalizations.of(context)!.translate("loc_ture").toString());
    selectedtrasnType = trasnType.first;
    selectedaccType = accType.first;
    selectednationalType = nationalType.first;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Theme.of(context).secondaryHeaderColor,
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
            title: Text(
              AppLocalizations.of(context)!.translate("loc_link_bank_acc").toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
                  Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
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
                    CustomTheme.of(context).secondaryHeaderColor,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Form(
                              key: emailformKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("loc_acc_num").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormFieldCustom(
                                    onEditComplete: () {
                                      accnumFocus.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(routnumFocus);
                                    },
                                    radius: 5.0,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                                    // ],
                                    error: AppLocalizations.of(context)!
                                        .translate("loc_enter_acc_no"),
                                    textColor:
                                        CustomTheme.of(context).cardColor,
                                    borderColor:
                                        CustomTheme.of(context).canvasColor,
                                    fillColor:
                                        CustomTheme.of(context).canvasColor,
                                    textInputAction: TextInputAction.next,
                                    focusNode: accnumFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: AppLocalizations.of(context)!
                                        .translate("loc_acc_no").toString(),
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Account Number";
                                      }

                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.number,
                                    controller: accnumContoller,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).dividerColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("loc_bnk_name").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormFieldCustom(
                                    onEditComplete: () {
                                      bankNameFocus.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(ifscnumFocus);
                                    },
                                    radius: 5.0,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                                    // ],
                                    error: AppLocalizations.of(context)!
                                        .translate("loc_enter_bnk_name"),
                                    textColor:
                                        CustomTheme.of(context).cardColor,
                                    borderColor:
                                        CustomTheme.of(context).canvasColor,
                                    fillColor:
                                        CustomTheme.of(context).canvasColor,
                                    textInputAction: TextInputAction.next,
                                    focusNode: bankNameFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: AppLocalizations.of(context)!
                                        .translate("loc_bank_name").toString(),
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Bank Name";
                                      }

                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.text,
                                    controller: bankNameContoller,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).dividerColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("loc_ifsc_cod").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  TextFormFieldCustom(
                                    onEditComplete: () {
                                      ifscnumFocus.unfocus();
                                      // FocusScope.of(context).requestFocus(emailPassFocus);
                                    },
                                    radius: 5.0,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
                                    // ],
                                    error: AppLocalizations.of(context)!
                                        .translate("loc_enter_ifsc_cod"),
                                    textColor:
                                        CustomTheme.of(context).cardColor,
                                    borderColor:
                                        CustomTheme.of(context).canvasColor,
                                    fillColor:
                                        CustomTheme.of(context).canvasColor,
                                    textInputAction: TextInputAction.next,
                                    focusNode: ifscnumFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: AppLocalizations.of(context)!
                                        .translate("loc_ifsc_code").toString(),
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter Ifsc Code";
                                      }

                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.text,
                                    controller: ifscnumContoller,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).dividerColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .translate("loc_bnk_acc_type").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomTextStyle(
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    height: 40.0,
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 0.0,
                                        bottom: 0.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                    ),
                                    child: Center(
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: CustomTheme.of(context)
                                              .shadowColor,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            items: accType
                                                .map((value) =>
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        value,
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                Theme.of(
                                                                        context)
                                                                    .cardColor,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                      ),
                                                      value: value,
                                                    ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedaccType =
                                                    value.toString();
                                              });
                                            },
                                            isExpanded: true,
                                            value: selectedaccType,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                              color: CustomTheme.of(context)
                                                  .cardColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const SizedBox(
                                    height: 40.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (emailformKey.currentState!
                                            .validate()) {
                                          loading = true;
                                          addBank();
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 12.0, bottom: 12.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            CustomTheme.of(context)
                                                .primaryColorLight,
                                            CustomTheme.of(context)
                                                .primaryColorDark,
                                          ],
                                          tileMode: TileMode.mirror,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("loc_submit").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                17.0,
                                                CustomTheme.of(context)
                                                    .primaryColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                          CustomTheme.of(context).primaryColor,
                        )
                      : Container()
                ],
              )),
        ));
  }

  addBank() {
    apiUtils
        .addbankDetails(
      accnumContoller.text.toString(),
      bankNameContoller.text.toString(),
      ifscnumContoller.text.toString(),
      selectedaccType.toString(),
    )
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "success");
          Navigator.pop(context);
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
