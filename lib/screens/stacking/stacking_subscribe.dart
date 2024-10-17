import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/common/text_field_custom_prefix.dart';
import 'package:zurumi/common/textformfield_custom.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/deposit_details_model.dart';
import 'package:zurumi/data/crypt_model/stake_list_model.dart';
import 'package:zurumi/screens/stacking/staking.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class Stacking_Subscribe_Screen extends StatefulWidget {
  final StakeList stack;

  const Stacking_Subscribe_Screen({Key? key,
    required this.stack,
  })
      : super(key: key);

  @override
  State<Stacking_Subscribe_Screen> createState() =>
      _Stacking_Subscribe_ScreenState();
}

class _Stacking_Subscribe_ScreenState extends State<Stacking_Subscribe_Screen> {
  bool loading = false;
  FocusNode amtFocus = FocusNode();
  bool check = false;

  String balance = "0.0";
  StakeList? stack;
  TextEditingController amtController = TextEditingController();
  APIUtils apiUtils = APIUtils();
  List<String> durationTime = [
    "daily",
    "monthly",
  ];
  String selectedTime = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stack = widget.stack;
    selectedTime = durationTime.first;

    loading = true;
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
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
              color: CustomTheme.of(context).secondaryHeaderColor,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_duration").toString()+"("+ AppLocalizations.of(context)!.translate("loc_days").toString() +")",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).cardColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => const Stacking_Subscribe_Screen(),
                                  //     ));
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  padding:
                                      EdgeInsets.only(top: 7.0, bottom: 7.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context).primaryColorDark,
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Text(
                                    stack!.durationTitle.toString(),
                                    // "12 Months",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).primaryColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            height: 45.0,
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: CustomTheme.of(context).canvasColor,
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: CustomTheme.of(context).canvasColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  items: durationTime
                                      .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          14.0,
                                          CustomTheme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                  ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTime = value.toString();
                                      print(selectedTime);

                                    });
                                  },
                                  isExpanded: false,
                                  value: selectedTime,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: CustomTheme.of(context).cardColor,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.translate("loc_sub_amt").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).cardColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 3,
                                  child: TextFormFieldCustom(
                                    onEditComplete: () {
                                      amtFocus.unfocus();
                                    },
                                    radius: 5.0,
                                    error: AppLocalizations.of(context)!.translate("loc_ent_amt"),
                                    textColor: CustomTheme.of(context).cardColor,
                                    borderColor: Colors.transparent,
                                    fillColor: Colors.transparent,
                                    hintStyle: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            15.0,
                                            CustomTheme.of(context)
                                                .dividerColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                    textStyle: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            15.0,
                                            CustomTheme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                    textInputAction: TextInputAction.next,
                                    focusNode: amtFocus,
                                    maxlines: 1,
                                    text: '',
                                    hintText: AppLocalizations.of(context)!.translate("loc_amount").toString(),
                                    obscureText: false,
                                    suffix: Container(
                                      width: 0.0,
                                    ),
                                    textChanged: (value) {},
                                    onChanged: () {},
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter amount";
                                      }
                                      return null;
                                    },
                                    enabled: true,
                                    textInputType: TextInputType.emailAddress,
                                    controller: amtController,

                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Flexible(
                                    child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {

                                          amtController.text=balance.toString();
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.translate("loc_max").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context).hoverColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Container(
                                      height: 25.0,
                                      width: 2.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Theme.of(context).shadowColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      stack!.depositCoin.toString(),
                                      // "Zurumi",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              13.0,
                                              Theme.of(context).disabledColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                balance + " " +
                                    stack!.depositCoin.toString(),
                          // "Zurumi",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).cardColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate("loc_avle").toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).shadowColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.translate("loc_amount")} ${AppLocalizations.of(context)!.translate("loc_lmt")}",
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).cardColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${AppLocalizations.of(context)!.translate("loc_minm")} : ",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).shadowColor,
                                        FontWeight.w400,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "${stack!.minAmt} ${stack!.depositCoin}",
                                    // "Zurumi",
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        14.0,
                                        Theme.of(context).cardColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black)
                              // color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("loc_sumy").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          24.0,
                                          Theme.of(context).primaryColorLight,
                                          FontWeight.w400,
                                          'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_real_apr").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).primaryColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Text(
                                        //   stack!.rewardInterest.toString() +
                                        //   // "15" +
                                        //       " %",
                                        //   style: CustomWidget(context: context)
                                        //       .CustomSizedTextStyle(
                                        //           14.0,
                                        //           Theme.of(context)
                                        //               .indicatorColor,
                                        //           FontWeight.w400,
                                        //           'FontRegular'),
                                        //   textAlign: TextAlign.center,
                                        // ),
                                        const SizedBox(
                                          width: 8.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(3.0)),
                                          child: SvgPicture.asset(
                                            "assets/icons/stack.svg",
                                            height: 22.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.translate("loc_stk_txt").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).primaryColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_dly_reward").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      "--",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).primaryColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 20.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Flexible(
                                        child: Text(
                                          AppLocalizations.of(context)!.translate("loc_stk_txts").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                      textAlign: TextAlign.start,
                                    ))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 23.0,
                                      width: 23.0,
                                      child: Checkbox(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        value: check,
                                        activeColor:
                                            Theme.of(context).primaryColor,
                                        checkColor: Theme.of(context).cardColor,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            check = value!;
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(
                                          text: AppLocalizations.of(context)!.translate("loc_i_agre"),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .primaryColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: AppLocalizations.of(context)!.translate("loc_agreemt").toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .primaryColorLight,
                                                        FontWeight.w500,
                                                        'FontRegular')),
                                          ],
                                        ),
                                      ),
                                    ),

                                    //Checkbox
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          InkWell(
                            onTap: () {
                              if (amtController.text.isEmpty) {
                                CustomWidget(context: context)
                                    .showSuccessAlertDialog( AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                    AppLocalizations.of(context)!.translate("loc_enter_amt").toString(), "error");
                              } else {
                                double amt =
                                double.parse(amtController.text.toString());
                                double min = double.parse(stack!.minAmt.toString());
                                double max = double.parse(stack!.maxAmt.toString());

                                if (check) {
                                  if (amt > double.parse(balance)) {
                                    CustomWidget(context: context)
                                        .showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                        AppLocalizations.of(context)!.translate("loc_amt_txt").toString(), "error");
                                  } else if (amt < min || amt > max) {
                                    CustomWidget(context: context)
                                        .showSuccessAlertDialog(
                                        AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                        AppLocalizations.of(context)!.translate("loc_ent_min_max").toString(),
                                            "error");
                                  }
                                  // else if (amt % 100 != 0) {
                                  //   CustomWidget(context: context)
                                  //       .showSuccessAlertDialog(
                                  //       AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                  //       AppLocalizations.of(context)!.translate("loc_amt_txt").toString(),
                                  //           "error");
                                  // }
                                  else {
                                    setState(() {
                                      loading=true;
                                      doSubscribe();
                                    });
                                  }
                                } else {
                                  CustomWidget(context: context)
                                      .showSuccessAlertDialog(
                                      AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                      AppLocalizations.of(context)!.translate("loc_agree_condi").toString(),
                                          "error");
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomTheme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate("loc_confirm").toString(),
                                style:AppTextStyles.poppinsBold(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                          CustomTheme.of(context).primaryColor)
                      : Container()
                ],
              )),
        ));
  }

  getDetails() {
    apiUtils
        .getDepositDetails(stack!.depositCoin.toString())
        .then((DepositDetailsModel loginData) {
      setState(() {
        loading = false;

        if (loginData.success!) {
          loading = false;
          balance = loginData.result!.balance.toString();
        } else {
          loading = false;
          //   CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "error");
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  doSubscribe() {
    apiUtils
        .doStaking(stack!.depositCoin.toString(),stack!.id.toString(), amtController.text.toString(), stack!.durationTitle.toString(),selectedTime.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          getDetails();
          amtController.clear();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Staking_Screen(),),);
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_sub_staking").toString(), loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_sub_staking").toString(), loginData.message.toString(), "error");
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
