import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_rsa3/simple_rsa3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/otp_fields/otp_field_custom.dart';
import 'package:zurumi/common/otp_fields/style.dart';
import 'package:zurumi/data/crypt_model/buycrypto_balance_model.dart';
import 'package:zurumi/data/crypt_model/buycrypto_list_model.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';

import 'package:zurumi/data/crypt_model/instant_buy_submit_model.dart';
import 'package:zurumi/data/crypt_model/swap_balance_model.dart';

import '../../common/custom_widget.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';

class Swap extends StatefulWidget {
  const Swap({super.key});

  @override
  State<Swap> createState() => _SwapState();
}

class _SwapState extends State<Swap> {
  bool loading = false;
  FocusNode spendFocus = FocusNode();
  FocusNode recieveFocus = FocusNode();
  // FocusNode idFocus = FocusNode();
  // FocusNode otpFocus = FocusNode();
  // FocusNode msdnFocus = FocusNode();
  // TextEditingController msdnController = TextEditingController();
  // TextEditingController idController = TextEditingController();
//  TextEditingController otpController = TextEditingController();
  TextEditingController spendController = TextEditingController();
  TextEditingController recieveController = TextEditingController();

  List<Cointwo> coinOnelist = [];
  List<SwapBalanceList> coinTwolist = [];

  String fee = "0.00";
  String percentage = "0";
  String coinTwo = "";
  String coinOne = "";
  APIUtils apiUtils = APIUtils();
  bool swap = false;

  String coinOneBalance = "0.00";
  String coinTwoBalance = "0.00";
  Cointwo? selectedCoinOne;
  SwapBalanceList? selectedCoinTwo;
  List<String> accountTypelist = ["Wallet"];
  String accounttype = "";
  bool qrImage = false;
  Uint8List? qrImageDetails;
  int _remainingTime = 300; //initial time in seconds
  late Timer _timer;
  String livePrice = "0.0";
  String referenceID = "";

  var pinValue;
  String token = "";
  bool loadingQR = false;

  String otp = "";
  String expiry = '0';

  String maxlink = "";
  String omlink = "";

  MethodChannel _channel = MethodChannel('juanito21.com/simple_rsa');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    swap = true;
    accounttype = accountTypelist.first;
    getSwaList();
  }

  _getRequests() async {
    setState(() {
      loading = true;
      getSwaList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
            elevation: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: CustomTheme.of(context).shadowColor,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.translate("loc_swap").toString(),
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
            color: CustomTheme.of(context).secondaryHeaderColor,
            child: Stack(
              children: [
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        CustomTheme.of(context).primaryColor,
                      )
                    : swapUI(),
              ],
            ),
          ),
        ));
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime = _remainingTime - 1;
        } else {
          Navigator.pop(context);

          _timer.cancel();
        }
      });
    });
  }

  Widget swapUI() {
    return Container(
        padding:
            EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0, bottom: 0.0),
        child: SingleChildScrollView(
            child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Container(
                //   padding: EdgeInsets.all(5.0),
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       begin: Alignment.centerLeft,
                //       end: Alignment.centerRight,
                //       colors: <Color>[
                //         CustomTheme.of(context).bottomAppBarColor,
                //         CustomTheme.of(context).backgroundColor,
                //       ],
                //       tileMode: TileMode.mirror,
                //     ),
                //     borderRadius: BorderRadius.circular(25.0),
                //   ),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       Flexible(child: InkWell(
                //         onTap: (){
                //           setState(() {
                //             swap= true;
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                //           alignment: Alignment.center,
                //           width: MediaQuery.of(context).size.width,
                //           decoration: swap ? BoxDecoration(
                //             borderRadius: BorderRadius.circular(25.0),
                //             color: CustomTheme.of(context).primaryColor,
                //           ) : BoxDecoration(),
                //           child: Text(
                //             AppLocalizations.of(context)!.translate("loc_sell_trade_txt5"),
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 13.0,
                //                 swap ? CustomTheme.of(context).cardColor : CustomTheme.of(context).focusColor,
                //                 FontWeight.w500,
                //                 'FontRegular'),
                //           ),
                //         ),
                //       )),
                //       Flexible(child:  InkWell(
                //         onTap: (){
                //           setState(() {
                //             swap= false;
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                //           alignment: Alignment.center,
                //           width: MediaQuery.of(context).size.width,
                //           decoration: swap? BoxDecoration():BoxDecoration(
                //             borderRadius: BorderRadius.circular(25.0),
                //             color: CustomTheme.of(context).primaryColor,
                //           ) ,
                //           child: Text(
                //             AppLocalizations.of(context)!.translate("loc_sell_trade_txt6"),
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 13.0,
                //                 swap ? CustomTheme.of(context).focusColor : CustomTheme.of(context).cardColor,
                //                 FontWeight.w500,
                //                 'FontRegular'),
                //           ),
                //         ),
                //       ),)
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 15.0,
                // ),
                Text(
                  AppLocalizations.of(context)!
                      .translate("loc_send")
                      .toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 4,
                      child: TextFormFieldCustom(
                        onEditComplete: () {
                          spendFocus.unfocus();
                          FocusScope.of(context).requestFocus(recieveFocus);
                        },
                        radius: 8.0,
                        error: "Enter Spend amount",
                        textColor: CustomTheme.of(context).cardColor,
                        borderColor: Colors.transparent,
                        fillColor: CustomTheme.of(context).canvasColor,
                        hintStyle: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                15.0,
                                CustomTheme.of(context).dividerColor,
                                FontWeight.w400,
                                'FontRegular'),
                        textStyle: CustomWidget(context: context)
                            .CustomTextStyle(CustomTheme.of(context).cardColor,
                                FontWeight.w500, 'FontRegular'),
                        textInputAction: TextInputAction.next,
                        focusNode: spendFocus,
                        maxlines: 1,
                        text: '',
                        hintText: "0.00",
                        obscureText: false,
                        suffix: Container(
                          width: 0.0,
                        ),
                        textChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              fee = "0.000";
                              recieveController.clear();
                            } else {
                              String rec = (double.parse(value) /
                                      double.parse(livePrice))
                                  .toStringAsFixed(8);
                              recieveController.text = rec;
                              fee = (double.parse(rec) *
                                      double.parse(selectedCoinTwo!
                                          .commissionPercentage
                                          .toString()) /
                                      100)
                                  .toStringAsFixed(8);
                            }
                          });
                        },
                        onChanged: () {},
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter Spend amount";
                          }
                          return null;
                        },
                        enabled: true,
                        textInputType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        controller: spendController,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: CustomTheme.of(context).canvasColor,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(8.0),
                          color: CustomTheme.of(context).canvasColor,
                        ),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor:
                                CustomTheme.of(context).secondaryHeaderColor,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                              items: coinOnelist
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value.cointwo.toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (dynamic value) async {
                                setState(() {
                                  loading = true;
                                  selectedCoinOne = value!;
                                  coinOne = selectedCoinOne!.cointwo.toString();
                                  print(coinOne);
                                  spendController.clear();
                                  //idController.clear();
                                  recieveController.clear();
                                  //  msdnController.clear();

                                  if (coinOne == "XOF") {
                                    print("Manop");
                                    accountTypelist = [];
                                    qrImage = true;

                                    accountTypelist.add(
                                        AppLocalizations.of(context)!
                                            .translate("loc_orange_pay")
                                            .toString());
                                    accounttype = accountTypelist.first;
                                  } else {
                                    accountTypelist.clear();
                                    accountTypelist = [];
                                    qrImage = false;

                                    accountTypelist.add(
                                        AppLocalizations.of(context)!
                                            .translate("loc_wallet")
                                            .toString());
                                    accounttype = accountTypelist.first;
                                  }
                                  getSwapBalanceList();
                                });
                              },
                              hint: Text(
                                AppLocalizations.of(context)!
                                    .translate("loc_select_coin")
                                    .toString(),
                                style: CustomWidget(context: context)
                                    .CustomSizedTextStyle(
                                        10.0,
                                        Theme.of(context).dividerColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                              ),
                              isExpanded: true,
                              value: selectedCoinOne,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       if(swap){
                //         swap= false;
                //       }
                //       else{
                //         swap= true;
                //       }
                //     });
                //   },
                //   child: Align(
                //     child: RotationTransition(
                //         turns: AlwaysStoppedAnimation(90 / 360),
                //         child: Container(
                //           padding: EdgeInsets.all(5.0),
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Theme.of(context).highlightColor,
                //           ),
                //           child: SvgPicture.asset(
                //             "assets/icons/arrow.svg",
                //             height: 25.0,
                //           ),
                //         )),
                //   ),
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                Text(
                  AppLocalizations.of(context)!
                      .translate("loc_receive")
                      .toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                swap
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 4,
                            child: TextFormFieldCustom(
                              onEditComplete: () {
                                recieveFocus.unfocus();
                              },
                              radius: 8.0,
                              error: "Enter Recieve amount",
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: Colors.transparent,
                              fillColor: CustomTheme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      15.0,
                                      CustomTheme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              textInputAction: TextInputAction.done,
                              focusNode: recieveFocus,
                              maxlines: 1,
                              text: '',
                              hintText: "0.00",
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    fee = "0.000";
                                    spendController.clear();
                                  } else {
                                    String rec = (double.parse(value) *
                                            double.parse(livePrice))
                                        .toStringAsFixed(8);
                                    spendController.text = rec;
                                    fee = (double.parse(rec) *
                                            double.parse(selectedCoinTwo!
                                                .commissionPercentage
                                                .toString()) /
                                            100)
                                        .toStringAsFixed(8);
                                  }
                                });
                              },
                              onChanged: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Recieve amount";
                                }
                                return null;
                              },
                              enabled: true,
                              textInputType: TextInputType.numberWithOptions(
                                decimal: true,
                                signed: true,
                              ),
                              controller: recieveController,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CustomTheme.of(context).canvasColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                                color: CustomTheme.of(context).canvasColor,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: CustomTheme.of(context)
                                      .secondaryHeaderColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.7,
                                    items: coinTwolist
                                        .map((value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value.cointwo.toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (dynamic value) async {
                                      setState(() {
                                        selectedCoinTwo = value;
                                        coinTwo =
                                            selectedCoinTwo!.cointwo.toString();
                                        coinTwoBalance =
                                            selectedCoinTwo!.balance.toString();
                                        getSwapBalance();
                                      });
                                    },
                                    hint: Text(
                                      AppLocalizations.of(context)!
                                          .translate("loc_select_coin")
                                          .toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context).dividerColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                    ),
                                    isExpanded: true,
                                    value: selectedCoinTwo,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 4,
                            child: TextFormFieldCustom(
                              onEditComplete: () {
                                spendFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(recieveFocus);
                              },
                              radius: 8.0,
                              error: "Enter Spend amount",
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: Colors.transparent,
                              fillColor: CustomTheme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      15.0,
                                      CustomTheme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              textInputAction: TextInputAction.next,
                              focusNode: spendFocus,
                              maxlines: 1,
                              text: '',
                              hintText: "0.00",
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    fee = "0.000";
                                    recieveController.clear();
                                  } else {
                                    String rec = (double.parse(value) *
                                            double.parse(selectedCoinTwo!
                                                .liveprice
                                                .toString()))
                                        .toStringAsFixed(8);
                                    recieveController.text = rec;
                                    fee = (double.parse(rec) *
                                            double.parse(selectedCoinTwo!
                                                .commissionPercentage
                                                .toString()) /
                                            100)
                                        .toStringAsFixed(8);
                                  }
                                });
                              },
                              onChanged: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Spend amount";
                                }
                                return null;
                              },
                              enabled: true,
                              textInputType: TextInputType.number,
                              controller: spendController,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: CustomTheme.of(context).canvasColor,
                                    width: 1.0),
                                borderRadius: BorderRadius.circular(8.0),
                                color: CustomTheme.of(context).canvasColor,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: CustomTheme.of(context)
                                      .secondaryHeaderColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.7,
                                    items: coinTwolist
                                        .map((value) => DropdownMenuItem(
                                              child: Text(
                                                value.cointwo.toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                              value: value,
                                            ))
                                        .toList(),
                                    onChanged: (dynamic value) async {
                                      setState(() {
                                        selectedCoinTwo = value;
                                        coinTwo =
                                            selectedCoinTwo!.cointwo.toString();
                                        coinTwoBalance =
                                            selectedCoinTwo!.balance.toString();
                                      });
                                    },
                                    hint: Text(
                                      AppLocalizations.of(context)!
                                          .translate("loc_select_coin")
                                          .toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              10.0,
                                              Theme.of(context).dividerColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                    ),
                                    isExpanded: true,
                                    value: selectedCoinTwo,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: CustomTheme.of(context).canvasColor, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                    color: CustomTheme.of(context).canvasColor,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: CustomTheme.of(context).canvasColor,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        items: accountTypelist
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(
                                    value.toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ))
                            .toList(),
                        onChanged: (dynamic value) async {
                          setState(() {
                            //loading =true;
                            accounttype = value;
                          });
                        },
                        hint: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_select_coin")
                              .toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  10.0,
                                  Theme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                        isExpanded: true,
                        value: accounttype,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: qrImage ? 25.0 : 0.0,
                ),

                // qrImage?   Text(
                //   "MSISDN Number",
                //   style: CustomWidget(context: context).CustomSizedTextStyle(
                //       14.0,
                //       Theme.of(context).cardColor,
                //       FontWeight.w500,
                //       'FontRegular'),
                // ):Container(),
                // SizedBox(
                //   height: qrImage ? 5.0 : 0.0,
                // ),
                // qrImage
                //     ? TextFormFieldCustom(
                //   onEditComplete: () {
                //     msdnFocus.unfocus();
                //
                //   },
                //   radius: 8.0,
                //   error: "Enter MSISDN",
                //   textColor: CustomTheme.of(context).cardColor,
                //   borderColor: Colors.transparent,
                //   fillColor: CustomTheme.of(context).canvasColor,
                //   hintStyle: CustomWidget(context: context)
                //       .CustomSizedTextStyle(
                //       15.0,
                //       CustomTheme.of(context).dividerColor,
                //       FontWeight.w400,
                //       'FontRegular'),
                //   textStyle: CustomWidget(context: context)
                //       .CustomTextStyle(CustomTheme.of(context).cardColor,
                //       FontWeight.w500, 'FontRegular'),
                //   textInputAction: TextInputAction.next,
                //   focusNode: msdnFocus,
                //   maxlines: 1,
                //   text: '',
                //   hintText: "MSISDN Number",
                //   obscureText: false,
                //   suffix: Container(
                //     width: 0.0,
                //   ),
                //   textChanged: (value) {},
                //   onChanged: () {},
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter ID";
                //     }
                //     return null;
                //   },
                //   enabled: true,
                //   textInputType: TextInputType.number,
                //   controller: msdnController,
                // )
                //     : Container(),
                // SizedBox(
                //   height: qrImage ? 15.0 : 0.0,
                // ),
                // qrImage?   Text(
                //   "Pincode Number",
                //   style: CustomWidget(context: context).CustomSizedTextStyle(
                //       14.0,
                //       Theme.of(context).cardColor,
                //       FontWeight.w500,
                //       'FontRegular'),
                // ):Container(),
                // SizedBox(
                //   height: qrImage ? 5.0 : 0.0,
                // ),
                // qrImage
                //     ? TextFormFieldCustom(
                //         onEditComplete: () {
                //           idFocus.unfocus();
                //
                //         },
                //         radius: 8.0,
                //         error: "Enter Pincode",
                //         textColor: CustomTheme.of(context).cardColor,
                //         borderColor: Colors.transparent,
                //         fillColor: CustomTheme.of(context).canvasColor,
                //         hintStyle: CustomWidget(context: context)
                //             .CustomSizedTextStyle(
                //                 15.0,
                //                 CustomTheme.of(context).dividerColor,
                //                 FontWeight.w400,
                //                 'FontRegular'),
                //         textStyle: CustomWidget(context: context)
                //             .CustomTextStyle(CustomTheme.of(context).cardColor,
                //                 FontWeight.w500, 'FontRegular'),
                //         textInputAction: TextInputAction.next,
                //         focusNode: idFocus,
                //         maxlines: 1,
                //         text: '',
                //         hintText: "Pincode",
                //         obscureText: false,
                //         suffix: Container(
                //           width: 0.0,
                //         ),
                //         textChanged: (value) {},
                //         onChanged: () {},
                //         validator: (value) {
                //           if (value!.isEmpty) {
                //             return "Please enter ID";
                //           }
                //           return null;
                //         },
                //         enabled: true,
                //         textInputType: TextInputType.number,
                //         controller: idController,
                //       )
                //     : Container(),

                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate("loc_fee_percent")
                          .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    Text(
                      percentage == "null" || percentage == null
                          ? "0%"
                          : percentage + "%",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate("loc_swap_fee")
                          .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    Text(
                      fee + " " + coinTwo,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$coinOne ${AppLocalizations.of(context)!.translate("loc_bala")}",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    Text(
                      coinOneBalance,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      coinTwo +
                          " " +
                          AppLocalizations.of(context)!
                              .translate("loc_bala")
                              .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    Text(
                      coinTwoBalance,
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25.0,
                ),

                SizedBox(
                  height: qrImage ? 5.0 : 0.0,
                ),

                SizedBox(
                  height: qrImage ? 10.0 : 0.0,
                ),
                !qrImage
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            if (spendController.text.isNotEmpty &&
                                recieveController.text.isNotEmpty) {
                              if (coinOne == "XOF") {
                                verify();
                                loadingQR = true;
                                //    if(msdnController.text.isNotEmpty && idController.text.isNotEmpty)
                                //      {
                                //
                                // ///     getToken();
                                //
                                //      }else{
                                //
                                //    CustomWidget(context: context).showSuccessAlertDialog(
                                //        "Swap", "Please fill the details", "error");
                                //
                                //
                                //    }
                              } else {
                                loadingQR = true;
                                verify();
                              }
                            } else {
                              CustomWidget(context: context)
                                  .showSuccessAlertDialog(
                                      "Swap",
                                      AppLocalizations.of(context)!
                                          .translate('fill_all_details')
                                          .toString(),
                                      "error");
                            }
                          });
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 12.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: CustomTheme.of(context).primaryColor,
                          ),
                          child: Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_con")
                                  .toString()
                                  .toUpperCase(),
                              style: AppTextStyles.poppinsRegular(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16)),
                        ),
                      )
                    : Container(),

                qrImage
                    ? Text(
                        AppLocalizations.of(context)!
                            .translate("loc_pay_with")
                            .toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                                14.0,
                                Theme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                      )
                    : Container(),
                SizedBox(
                  height: qrImage ? 10.0 : 0.0,
                ),
                qrImage
                    ? Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  qrImage = false;
                                  spendController.clear();
                                  recieveController.clear();
                                  _launchInBrowser(Uri.parse(omlink));
                                });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/icons/orange.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Flexible(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  qrImage = false;
                                  spendController.clear();
                                  recieveController.clear();
                                  _launchInBrowser(Uri.parse(maxlink));
                                });
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage("assets/icons/maxit.png"),
                                      fit: BoxFit.fill,
                                    ),
                                  )),
                            ),
                          )
                        ],
                      )
                    : Container()
              ],
            ),
            loadingQR
                ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).primaryColor,
                  )
                : Container()
          ],
        )));
  }

  _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  viewDetails(BuildContext contexts, String textData, bool type) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  margin: EdgeInsets.only(top: 5.0),
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(
                    right: 5.0,
                    left: 0.0,
                  ),
                  decoration: BoxDecoration(
                      color: CustomTheme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        topLeft: Radius.circular(30.0),
                      )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        textData,
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context).splashColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      // Center(
                                      //   child: Text(
                                      //         " Expire In " +
                                      //         _remainingTime.toString() +
                                      //         " Seconds",
                                      //     style: CustomWidget(context: context)
                                      //         .CustomSizedTextStyle(
                                      //         12.0,
                                      //         Theme.of(context).focusColor,
                                      //         FontWeight.w500,
                                      //         'FontRegular'),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 35.0,
                                  ),
                                  OTPTextField(
                                    length: 6,
                                    width: MediaQuery.of(context).size.width,
                                    fieldWidth: 45,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).primaryColor,
                                            FontWeight.w600,
                                            'FontRegular'),
                                    textFieldAlignment:
                                        MainAxisAlignment.spaceAround,
                                    fieldStyle: FieldStyle.underline,
                                    onCompleted: (pin) {
                                      setState(() {
                                        pinValue = pin;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 45.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        if (pinValue.isEmpty ||
                                            pinValue.length < 6) {
                                          CustomWidget(context: context)
                                              .showSuccessAlertDialog("Login",
                                                  "Please enter OTP", "error");
                                        } else {
                                          ssetState(() {
                                            Navigator.pop(context);
                                            loadingQR = true;
                                            //doPayment();
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 10.0),
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   width: 1.0,
                                          //   color: Theme.of(context).cardColor,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              CustomTheme.of(context)
                                                  .disabledColor,
                                              CustomTheme.of(context)
                                                  .primaryColorDark,
                                            ],
                                            tileMode: TileMode.mirror,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_verify")
                                                .toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        16.0,
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  // Align(
                                  //   alignment: Alignment.center,
                                  //   child: InkWell(
                                  //     onTap: (){
                                  //       ssetState(() {
                                  //         loading=true;
                                  //         resndOTP();
                                  //       });
                                  //
                                  //
                                  //     },
                                  //     child: Text(
                                  //       "Resend OTP",
                                  //       style: CustomWidget(context: context)
                                  //           .CustomSizedTextStyle(
                                  //           14.0,
                                  //           Theme.of(context).shadowColor,
                                  //           FontWeight.w800,
                                  //           'FontRegular'),
                                  //     ),
                                  //   ),
                                  // ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                );
              }),
            ));
  }

  getToken() {
    apiUtils.getAuthToke().then((dynamic loginData) {
      setState(() {
        token = loginData["access_token"];

        getPublicKeys();
      });
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getPublicKeys() {
    apiUtils.getPublicKey(token).then((dynamic loginData) {
      setState(() {
        String key = loginData["key"];

        // getEncryptData(key);
      });
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getSwaList() {
    apiUtils.getBuyCryptoList().then((BuyCryptoListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinOnelist = loginData.cointwo!;
          coinOnelist = coinOnelist.reversed.toList();
          selectedCoinOne = coinOnelist.first;
          coinOne = selectedCoinOne!.cointwo.toString();
          if (coinOne == "XOF") {
            accountTypelist = [];

            accountTypelist.add(AppLocalizations.of(context)!
                .translate("loc_orange_pay")
                .toString());
            accounttype = accountTypelist.first;
          }
          getSwapBalanceList();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  updatePayement(String trans, String status) {
    apiUtils.updatePaymentDetails(trans, status).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;

          getSwaList();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getSwapBalanceList() {
    apiUtils
        .getSwapBalanceList(selectedCoinOne!.cointwo.toString())
        .then((SwapBalanceListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinTwolist = [];
          coinTwolist = loginData.result!;
          selectedCoinTwo = coinTwolist.first;



          coinOneBalance = loginData.balance.toString();
          percentage = selectedCoinTwo!.commissionPercentage.toString();
          coinTwo = selectedCoinTwo!.cointwo.toString();
          coinTwoBalance = selectedCoinTwo!.balance.toString();
          getSwapBalance();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  verify() {
    debugPrint("Here 1 ${selectedCoinOne!.cointwo.toString()}");
    debugPrint("Here 2 ${selectedCoinTwo!.cointwo.toString()}");

    apiUtils
        .getSwapSubmit(
      selectedCoinOne!.cointwo.toString(),
      selectedCoinTwo!.cointwo.toString(),
      recieveController.text.toString(),
      spendController.text.toString(),
    )
        .then((InstantSubmitModel loginData) {
      if (loginData.success!) {
        setState(() {
          if (selectedCoinOne!.cointwo.toString() == "XOF") {
            qrImage = true;

            loading = false;
            loadingQR = false;
            omlink = loginData.result!.oMlink!;
            maxlink = loginData.result!.maxiTlink!;

            //   referenceID=loginData.result!.transId.toString();
          } else {
            recieveController.clear();
            fee = "0.00";
            spendController.clear();
            qrImage = false;
            loading = false;
            loadingQR = false;
            getSwapBalance();
            CustomWidget(context: context).showSuccessAlertDialog(
                "Zurumi", loginData.message.toString(), "success");
          }
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {

      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  getSwapBalance() {
    apiUtils
        .buyCryptoDetails(selectedCoinOne!.cointwo.toString(),
            selectedCoinTwo!.cointwo.toString(), "10", "10")
        .then((GetBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          livePrice = loginData.result!.liveprice.toString();
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  Future<String> encryptString(String txt, String publicKey) async {
    try {
      publicKey = publicKey
          .replaceAll("-----BEGIN PUBLIC KEY-----", "")
          .replaceAll("-----END PUBLIC KEY-----", "");
      final String result = await _channel
          .invokeMethod('encrypt', {"txt": txt, "publicKey": publicKey});
      return result;
    } on PlatformException catch (e) {
      throw "Failed to get string encoded: '${e.message}'.";
    }
  }
}
