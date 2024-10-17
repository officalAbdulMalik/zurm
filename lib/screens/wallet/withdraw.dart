import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/data/crypt_model/deposit_details_model.dart';
import '../../../common/custom_button.dart';
import '../../../common/custom_widget.dart';

import '../../../common/theme/custom_theme.dart';
import '../../common/otp_fields/otp_field_custom.dart';
import '../../common/otp_fields/style.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/bank_model.dart';
import '../../data/crypt_model/common_model.dart';
import '../../data/crypt_model/user_wallet_balance_model.dart';
import '../../data/crypt_model/withdraw_model.dart';
import '../side_menu/add_bank_details.dart';

class WithDraw extends StatefulWidget {
  final String id;

  final List<UserWalletResult> coinList;

  const WithDraw({Key? key, required this.id, required this.coinList})
      : super(key: key);

  @override
  State<WithDraw> createState() => _WithDrawState();
}

class _WithDrawState extends State<WithDraw> {
  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchCoinList = [];
  UserWalletResult? selectedCoin;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  TextEditingController searchController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  ScanResult? scanResult;
  var _autoEnableFlash = false;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _aspectTolerance = 0.00;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  ScrollController controller = ScrollController();
  ScrollController _scroll = ScrollController();
  var pinValue;
  String axn_id = "";
  String withdrawAmount = "0.00";
  List<NetworkAddress> networkAddress = [];
  String fee = "";

  int indexVal = 0;
  List<BankList> bankList = [];
  BankList? selectedBank;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.id);
    coinList = widget.coinList;
    searchCoinList = widget.coinList;

    if (widget.id == "0") {
      selectedCoin = coinList.first;
    } else {
      for (int m = 0; m < coinList.length; m++) {
        if (coinList[m].name.toString() == widget.id) {
          selectedCoin = coinList[m];
        }
      }
    }

    getDetails();
  }

  _getRequests() async {
    setState(() {
      loading = true;
      getBankList();
    });
  }

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
                setState(() {
                  Navigator.pop(context);
                });
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
              AppLocalizations.of(context)!.translate("loc_withdraw").toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
                  Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
            ),
          ),
          body: Container(
            // margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
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
            child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 6.0, bottom: 10.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: <Color>[
                            CustomTheme.of(context).primaryColorLight,
                            CustomTheme.of(context).primaryColorDark,
                          ],
                          tileMode: TileMode.mirror,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: kElevationToShadow[3],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          selectedCoin!.name.toString().toUpperCase() ==
                                  "ZURUMI"
                              ? Image.asset(
                                  "assets/images/logo.png",
                                  height: 35.0,
                                )
                              : SvgPicture.network(
                                  selectedCoin!.image.toString(),
                                  height: 40.0,
                                  width: 40.0,
                                ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            selectedCoin!.name.toString().toUpperCase(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            AppLocalizations.of(context)!.translate("loc_avle").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.5),
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          Text(
                            selectedCoin!.balance.toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  showSheeet(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding:
                                      EdgeInsets.fromLTRB(12.0, 15.0, 12, 15.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: CustomTheme.of(context).canvasColor,
                                  ),
                                  child: Theme(
                                      data: Theme.of(context).copyWith(
                                        canvasColor:
                                            CustomTheme.of(context).cardColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            selectedCoin!.symbol
                                                .toString()
                                                .toUpperCase(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        Theme.of(context)
                                                            .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          ),
                                          Row(
                                            children: [
                                              // Text(
                                              //   selectedCoin!.asset!.type.toString(),
                                              //   style: CustomWidget(context: context)
                                              //       .CustomSizedTextStyle(
                                              //       14.0,
                                              //       Theme.of(context)
                                              //           .hintColor
                                              //           .withOpacity(0.5),
                                              //       FontWeight.w400,
                                              //       'FontRegular'),
                                              // ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                size: 15.0,
                                                color:  Theme.of(context)
                                                    .cardColor,
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // selectedCoin!.type.toString()!="coin"||  selectedCoin!.type.toString()!="token"?   bankList.length>0?  Container(
                              //   height: 45.0,
                              //   padding: const EdgeInsets.only(
                              //       left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(5.0),
                              //     color:  CustomTheme.of(context)
                              //         .shadowColor
                              //         .withOpacity(0.2),
                              //   ),
                              //   child: Center(
                              //     child: Theme(
                              //       data: Theme.of(context).copyWith(
                              //         canvasColor:
                              //         CustomTheme.of(context).cardColor,
                              //       ),
                              //       child: DropdownButtonHideUnderline(
                              //         child: DropdownButton(
                              //           items: bankList
                              //               .map((value) => DropdownMenuItem(
                              //             child: Text(
                              //               value.bankName.toString(),
                              //               style: CustomWidget(
                              //                   context: context)
                              //                   .CustomSizedTextStyle(
                              //                   12.0,
                              //                   Theme.of(context)
                              //                       .splashColor,
                              //                   FontWeight.w500,
                              //                   'FontRegular'),
                              //             ),
                              //             value: value,
                              //           ))
                              //               .toList(),
                              //           onChanged: (value) {
                              //             setState(() {
                              //               selectedBank = value;
                              //             });
                              //           },
                              //           isExpanded: true,
                              //           value: selectedBank,
                              //           icon: Icon(
                              //             Icons.keyboard_arrow_down,
                              //             color:
                              //             CustomTheme.of(context).splashColor,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ): Padding(
                              //   padding: EdgeInsets.only(top:0.0, bottom: 0.0, ),
                              //   child: InkWell(
                              //     onTap: () {
                              //       Navigator.of(context)
                              //           .push(
                              //         MaterialPageRoute(builder: (_) => AddBankScreen()),
                              //       )
                              //           .then((val) => val ? _getRequests() : null);
                              //     },
                              //     child: Container(
                              //       height: 45.0,
                              //       decoration: BoxDecoration(
                              //           color: CustomTheme.of(context)
                              //               .canvasColor,
                              //           borderRadius: BorderRadius.circular(5.0)),
                              //       padding: EdgeInsets.only(left: 10.0,right: 10.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //
                              //           Text(
                              //             "Link A Bank Account",
                              //             style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
                              //                 Theme.of(context).splashColor, FontWeight.w500, 'FontRegular'),
                              //           ),
                              //
                              //           Icon(
                              //             Icons.add,
                              //             size: 20.0,
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ):Container(),
                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              // selectedCoin!.type.toString()!="coin"||  selectedCoin!.type.toString()!="token"?
                              // Container():

                              networkAddress.length > 0
                                  ? Container(
                                      height: 35.0,
                                      child: ListView.builder(
                                        itemCount: networkAddress.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    indexVal = index;
                                                    amountController.clear();
                                                    fee = "0.00";
                                                    withdrawAmount = "0.00";

                                                    if (networkAddress[0]
                                                            .withdrawtype
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "percentage") {
                                                      fee = (double.parse(networkAddress[
                                                                      indexVal]
                                                                  .withdrawcommission
                                                                  .toString()) /
                                                              100)
                                                          .toString();
                                                    } else {
                                                      fee = networkAddress[
                                                              indexVal]
                                                          .withdrawcommission
                                                          .toString();
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            15.0,
                                                            0.0,
                                                            15.0,
                                                            0.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      // gradient: indexVal==index? LinearGradient(
                                                      //   begin: Alignment.bottomLeft,
                                                      //   end: Alignment.topRight,
                                                      //   colors: <Color>[
                                                      //     CustomTheme.of(context).backgroundColor,
                                                      //     CustomTheme.of(context).bottomAppBarColor,
                                                      //   ],
                                                      //   tileMode: TileMode.mirror,
                                                      // ) :  LinearGradient(
                                                      //   begin: Alignment.bottomLeft,
                                                      //   end: Alignment.topRight,
                                                      //   colors: <Color>[
                                                      //     CustomTheme.of(context).disabledColor,
                                                      //     CustomTheme.of(context).bottomAppBarColor.withOpacity(0.3),
                                                      //   ],
                                                      //   tileMode: TileMode.mirror,
                                                      // ),
                                                      color: indexVal == index
                                                          ? CustomTheme.of(
                                                                  context)
                                                              .primaryColorDark
                                                          : CustomTheme.of(
                                                                  context)
                                                              .focusColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        networkAddress[index]
                                                            .name
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                14.0,
                                                                indexVal == index? Theme.of(
                                                                        context)
                                                                    .focusColor:Theme.of(
                                                                    context)
                                                                    .cardColor,
                                                                FontWeight.w400,
                                                                'FontRegular'),
                                                      ),
                                                    )),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)!.translate("loc_input_add"),
                                          hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: CustomTheme.of(context)
                                                .dividerColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        controller: addressController,
                                        style: TextStyle(
                                          color:  Theme.of(context)
                                              .cardColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _scan();
                                      },
                                      child: Icon(
                                        Icons.qr_code_scanner,
                                        color: CustomTheme.of(context)
                                            .dividerColor,
                                        size: 25.0,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).canvasColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: AppLocalizations.of(context)!.translate("loc_with_vol"),
                                          hintStyle: TextStyle(
                                            fontSize: 12.0,
                                            color: CustomTheme.of(context)
                                                .dividerColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            withdrawAmount = "0";

                                            if (val.isNotEmpty) {
                                              if (networkAddress.length > 0) {
                                                if (networkAddress[0]
                                                        .withdrawtype
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "percentage") {
                                                  String fees = (double.parse(
                                                              networkAddress[
                                                                      indexVal]
                                                                  .withdrawcommission
                                                                  .toString()) /
                                                          100)
                                                      .toString();
                                                  fee = (double.parse(val) *
                                                          double.parse(fees))
                                                      .toStringAsFixed(8);

                                                  if(double.parse(val)>double.parse(fee))
                                                    {
                                                      withdrawAmount =
                                                          (double.parse(val) -
                                                              double.parse(fee))
                                                              .toStringAsFixed(8);
                                                    }


                                                  print(withdrawAmount);
                                                } else {
                                                  fee = networkAddress[indexVal]
                                                      .withdrawcommission
                                                      .toString();

                                                  if(double.parse(val)>double.parse(fee))
                                                  {
                                                    withdrawAmount = (double
                                                        .parse(val) -
                                                        double.parse(
                                                            networkAddress[
                                                            indexVal]
                                                                .withdrawcommission
                                                                .toString()))
                                                        .toStringAsFixed(1);
                                                  }

                                                  print(withdrawAmount);
                                                }
                                              }
                                              // if (double.parse(selectedCoin!.fee
                                              //         .toString()) <=
                                              //     double.parse(val))
                                              //   withdrawAmount = (double.parse(
                                              //               val) -
                                              //           double.parse(
                                              //               selectedCoin!.fee
                                              //                   .toString()))
                                              //       .toStringAsFixed(1);
                                            }
                                          });
                                        },
                                        controller: amountController,
                                        textInputAction: TextInputAction.done,
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: true),
                                        style: TextStyle(
                                          color:  Theme.of(context)
                                              .cardColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 5, 0),
                                          child: Text(
                                            selectedCoin!.symbol
                                                .toString()
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        10.0,
                                                        Theme.of(context)
                                                            .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate("loc_recie").toString()+" : " + withdrawAmount,
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w400,
                                            'FontRegular'),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.translate("loc_fee").toString()+" : " + fee,
                                    textAlign: TextAlign.center,
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              selectedCoin!.type.toString() == "fiat"
                                  ? TextFormField(
                                      // controller: email,
                                      // focusNode: emailFocus,
                                      maxLines: 1,
                                      // enabled: emailVerify,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.emailAddress,
                                      style: CustomWidget(context: context)
                                          .CustomTextStyle(
                                              Theme.of(context).cardColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 12,
                                            right: 0,
                                            top: 2,
                                            bottom: 2),
                                        hintText:
                                        AppLocalizations.of(context)!.translate("loc_cash_with"),
                                        hintStyle: CustomWidget(
                                                context: context)
                                            .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).dividerColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                        filled: true,
                                        fillColor:
                                            CustomTheme.of(context).canvasColor,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .canvasColor,
                                              width: 1.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .canvasColor,
                                              width: 0.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .cardColor,
                                              width: 1.0),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: CustomTheme.of(context)
                                                  .cardColor,
                                              width: 1.0),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10.0,
                              ),
                              // Text(
                              //   "H2cryptO’s API allows users to make market inquiries, trade automatically and perform various other tasks. You may find out more here",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              // Text(
                              //   "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              // SizedBox(
                              //   height: 10.0,
                              // ),
                              // Text(
                              //   "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
                              //   style: CustomWidget(context: context)
                              //       .CustomSizedTextStyle(
                              //       12.0,
                              //       Theme.of(context)
                              //           .splashColor
                              //           .withOpacity(0.5),
                              //       FontWeight.w400,
                              //       'FontRegular'),
                              // ),
                              SizedBox(
                                height: 55.0,
                              ),
                              // ButtonCustom(
                              //     text:
                              //     AppLocalizations.of(context)!.translate("loc_confirm"),
                              //     iconEnable: false,
                              //     radius: 5.0,
                              //     icon: "",
                              //     textStyle: CustomWidget(context: context)
                              //         .CustomSizedTextStyle(
                              //         13.0,
                              //         Theme.of(context).splashColor,
                              //         FontWeight.w500,
                              //         'FontRegular'),
                              //     iconColor: CustomTheme.of(context).shadowColor,
                              //     shadowColor: CustomTheme.of(context).shadowColor,
                              //     splashColor: CustomTheme.of(context).shadowColor,
                              //     onPressed: () {
                              //       setState(() {
                              //
                              //
                              //         if(addressController.text.isEmpty)
                              //         {
                              //
                              //           CustomWidget(context: context).showSuccessAlertDialog("Zurumi", "Enter Withdraw Address", "error");
                              //
                              //         }
                              //         else if(amountController.text.isEmpty)
                              //         {
                              //           CustomWidget(context: context).showSuccessAlertDialog("Zurumi", "Enter  Withdraw amount", "error");
                              //
                              //
                              //         }
                              //         else
                              //         {
                              //
                              //           loading=true;
                              //
                              //
                              //
                              //           print("Mano");
                              //           coinWithdraw();
                              //
                              //         }
                              //
                              //
                              //       });
                              //     },
                              //     paddng: 1.0),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (double.parse(withdrawAmount) > 0) {
                                      if (addressController.text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog(
                                                "Zurumi",
                                                "Enter Withdraw Address",
                                                "error");
                                      } else if (amountController
                                          .text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog(
                                                "Zurumi",
                                                "Enter  Withdraw amount",
                                                "error");
                                      } else {
                                        if (double.parse(selectedCoin!.balance
                                                .toString()) <
                                            double.parse(amountController.text
                                                .toString())) {
                                          CustomWidget(context: context)
                                              .showSuccessAlertDialog(
                                              "Zurumi",
                                              "Balance was too low",
                                              "error");

                                        } else {
                                          loading = true;

                                          coinWithdraw();
                                        }
                                      }
                                    } else {
                                      CustomWidget(context: context)
                                          .showSuccessAlertDialog(
                                              "Zurumi",
                                              "Enter  Withdraw amount",
                                              "error");
                                    }
                                  });
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 12.0, bottom: 12.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                   color: CustomTheme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15.0),

                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("loc_confirm").toString(),
                                    style:AppTextStyles.poppinsRegular(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        )),
                    loading
                        ? CustomWidget(context: context).loadingIndicator(
                            CustomTheme.of(context).primaryColor,
                          )
                        : Container(),
                  ],
                )),
          ),
        ));
  }

  showSheeet(BuildContext contexts) {
    return showModalBottomSheet(
        context: contexts,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).primaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: EdgeInsets.only(left: 20.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              style: TextStyle(
                                color:  Theme.of(context)
                                    .cardColor,
                              ),
                              controller: searchController,
                              focusNode: searchFocus,
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setStates(() {
                                  coinList = [];

                                  for (int m = 0;
                                      m < searchCoinList.length;
                                      m++) {
                                    if (searchCoinList[m]
                                            .symbol
                                            .toString()
                                            .toLowerCase()
                                            .contains(value
                                                .toString()
                                                .toLowerCase()) ||
                                        searchCoinList[m]
                                            .symbol
                                            .toString()
                                            .toLowerCase()
                                            .contains(value
                                                .toString()
                                                .toLowerCase())) {
                                      coinList.add(searchCoinList[m]);
                                    }
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: AppLocalizations.of(context)!.translate("loc_search"),
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme.of(context).dividerColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                                filled: true,
                                fillColor: CustomTheme.of(context).canvasColor,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Align(
                              child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              setStates(() {
                                searchController.clear();
                                coinList.addAll(searchCoinList);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(6.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).canvasColor,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 20.0,
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          )),
                        ),
                        const SizedBox(
                          width: 10.0,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: ListView.builder(
                          controller: controller,
                          itemCount: coinList.length,
                          itemBuilder: ((BuildContext context, int index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      print(selectedCoin!.type.toString());
                                      selectedCoin = coinList[index];
                                      indexVal = 0;
                                      getDetails();

                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    padding:
                                        EdgeInsets.only(top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1.0,
                                          color: CustomTheme.of(context)
                                              .primaryColorLight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20.0,
                                        ),
                                        Container(
                                          height: 25.0,
                                          width: 25.0,
                                          child: coinList[index]
                                                      .symbol
                                                      .toString()
                                                      .toUpperCase() ==
                                                  "SET"
                                              ? Image.asset(
                                                  "assets/images/logo.png",
                                                  height: 25.0,
                                                )
                                              : SvgPicture.network(
                                                  coinList[index]
                                                      .image
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          coinList[index]
                                              .symbol
                                              .toString()
                                              .toUpperCase(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  Theme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                // Container(
                                //   height: 1.0,
                                //   width: MediaQuery
                                //       .of(context)
                                //       .size
                                //       .width,
                                //   color:
                                //   CustomTheme
                                //       .of(context)
                                //       .backgroundColor,
                                // ),
                                // const SizedBox(
                                //   height: 5.0,
                                // ),
                              ],
                            );
                          })),
                    )),
                  ],
                ),
              );
            },
          );
        });
  }

  // showssSheeet(BuildContext contexts) {
  //   return showModalBottomSheet(
  //       context: contexts,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setStates) {
  //             return Container(
  //               height: MediaQuery.of(context).size.height * 0.9,
  //               width: MediaQuery.of(context).size.width,
  //               color: Theme.of(context).primaryColor,
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 20.0,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.only(top: 10.0),
  //                         child: Container(
  //                           height: 45.0,
  //                           padding: EdgeInsets.only(left: 20.0),
  //                           width: MediaQuery.of(context).size.width * 0.8,
  //                           child: TextField(
  //                             controller: searchController,
  //                             focusNode: searchFocus,
  //                             enabled: true,
  //                             onEditingComplete: () {
  //                               setState(() {
  //                                 searchFocus.unfocus();
  //                               });
  //                             },
  //                             onChanged: (value) {
  //                               setState(() {
  //                                 coinList = [];
  //
  //                                 for (int m = 0;
  //                                     m < searchCoinList.length;
  //                                     m++) {
  //                                   if (searchCoinList[m]
  //                                           .symbol
  //                                           .toString()
  //                                           .toLowerCase()
  //                                           .contains(value
  //                                               .toString()
  //                                               .toLowerCase()) ||
  //                                       searchCoinList[m]
  //                                           .symbol
  //                                           .toString()
  //                                           .toLowerCase()
  //                                           .contains(value
  //                                               .toString()
  //                                               .toLowerCase())) {
  //                                     coinList.add(searchCoinList[m]);
  //                                   }
  //                                 }
  //                               });
  //                             },
  //                             decoration: InputDecoration(
  //                               contentPadding: const EdgeInsets.only(
  //                                   left: 12, right: 0, top: 8, bottom: 8),
  //                               hintText: "Search",
  //                               hintStyle: TextStyle(
  //                                   fontFamily: "FontRegular",
  //                                   color: Theme.of(context).hintColor,
  //                                   fontSize: 14.0,
  //                                   fontWeight: FontWeight.w400),
  //                               filled: true,
  //                               fillColor: CustomTheme.of(context)
  //                                   .backgroundColor
  //                                   .withOpacity(0.5),
  //                               border: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               disabledBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               enabledBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               focusedBorder: OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5.0)),
  //                                 borderSide: BorderSide(
  //                                     color: CustomTheme.of(context)
  //                                         .splashColor
  //                                         .withOpacity(0.5),
  //                                     width: 1.0),
  //                               ),
  //                               errorBorder: const OutlineInputBorder(
  //                                 borderRadius:
  //                                     BorderRadius.all(Radius.circular(5)),
  //                                 borderSide:
  //                                     BorderSide(color: Colors.red, width: 0.0),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Align(
  //                             child: InkWell(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             setState(() {
  //                               searchController.clear();
  //                               coinList.addAll(searchCoinList);
  //                             });
  //                           },
  //                           child: Icon(
  //                             Icons.close,
  //                             size: 20.0,
  //                             color: Theme.of(context).hintColor,
  //                           ),
  //                         )),
  //                       ),
  //                       const SizedBox(
  //                         width: 10.0,
  //                       )
  //                     ],
  //                   ),
  //                   const SizedBox(
  //                     height: 15.0,
  //                   ),
  //                   Expanded(
  //                       child: Padding(
  //                     padding: EdgeInsets.only(top: 15.0),
  //                     child: ListView.builder(
  //                         controller: controller,
  //                         itemCount: coinList.length,
  //                         itemBuilder: ((BuildContext context, int index) {
  //                           return Column(
  //                             children: [
  //                               InkWell(
  //                                 onTap: () {
  //                                   setState(() {
  //                                     selectedCoin = coinList[index];
  //                                     indexVal = 0;
  //
  //                                     print(selectedCoin!.type);
  //                                     Navigator.pop(context);
  //                                   });
  //                                 },
  //                                 child: Row(
  //                                   children: [
  //                                     const SizedBox(
  //                                       width: 20.0,
  //                                     ),
  //                                     Container(
  //                                       height: 25.0,
  //                                       width: 25.0,
  //                                       child: SvgPicture.network(
  //                                         coinList[index].image.toString(),
  //                                         fit: BoxFit.cover,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 10.0,
  //                                     ),
  //                                     Text(
  //                                       coinList[index]
  //                                           .symbol
  //                                           .toString()
  //                                           .toUpperCase(),
  //                                       style: CustomWidget(context: context)
  //                                           .CustomSizedTextStyle(
  //                                               16.0,
  //                                               Theme.of(context).splashColor,
  //                                               FontWeight.w500,
  //                                               'FontRegular'),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                               const SizedBox(
  //                                 height: 5.0,
  //                               ),
  //                               Container(
  //                                 height: 1.0,
  //                                 width: MediaQuery.of(context).size.width,
  //                                 color:
  //                                     CustomTheme.of(context).backgroundColor,
  //                               ),
  //                               const SizedBox(
  //                                 height: 5.0,
  //                               ),
  //                             ],
  //                           );
  //                         })),
  //                   )),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }
  viewDetails(BuildContext contexts) {
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
                                  Text(
                                    AppLocalizations.of(context)!.translate("loc_withdraw").toString()+" "+AppLocalizations.of(context)!.translate("loc_otp").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                            16.0,
                                            Theme.of(context).splashColor,
                                            FontWeight.w600,
                                            'FontRegular'),
                                    textAlign: TextAlign.start,
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
                                              .showSuccessAlertDialog(
                                                  "Withdraw",
                                                  "Please enter OTP",
                                                  "error");
                                        } else {
                                          ssetState(() {
                                            loading = true;
                                            Navigator.pop(context);
                                            confirmWithdraw();
                                          });
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 10.0, 0.0, 10.0),
                                        decoration: BoxDecoration(
                                          // border: Border.all(
                                          //   width: 1.0,
                                          //   color: Theme.of(context).cardColor,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                          color: CustomTheme.of(context)
                                              .shadowColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.translate("loc_verify").toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        16.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w800,
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

  getDetails() {
    print(selectedCoin!.symbol.toString());
    apiUtils
        .getDepositDetails(selectedCoin!.symbol.toString())
        .then((DepositDetailsModel loginData) {
      setState(() {
        loading = false;

        networkAddress = [];
        if (loginData.network!.length > 0) {
          networkAddress = loginData.network!;

          if (networkAddress[0].withdrawtype.toString().toLowerCase() ==
              "percentage") {
            fee = (double.parse(networkAddress[indexVal]
                        .withdrawcommission
                        .toString()) /
                    100)
                .toString();
          } else {
            fee = networkAddress[indexVal].withdrawcommission.toString();
          }
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': _cancelController.text,
            'flash_on': _flashOnController.text,
            'flash_off': _flashOffController.text,
          },
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {


        var str = result.rawContent.toString();
        print(str);
        if(str.contains(":")){
          var parts = str.split(':');
          addressController.text=parts[1].trim().toString();
        }else{
          addressController.text=str.toString();
        }

      });
    } on PlatformException catch (e) {
      setState(() {
        print("Mano");
        scanResult = ScanResult(
          type: ResultType.Error,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  getBankList() {
    apiUtils.getBankDetails().then((BankListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          bankList = loginData.result!;
          selectedBank = bankList.first;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  coinWithdraw() {
    apiUtils
        .coinWithdrawDetails(
            selectedCoin!.symbol.toString(),
            addressController.text.toString(),
            amountController.text.toString(),
            networkAddress.length > 0
                ? networkAddress[indexVal].type.toString()
                : "coin")
        .then((WithdrawModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "success");

          viewDetails(context);
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

  confirmWithdraw() {
    setState(() {
      loading = true;
    });
    apiUtils
        .confirmWithdrawOTP(
            selectedCoin!.symbol.toString(),
            addressController.text.toString(),
            amountController.text.toString(),
            pinValue.toString(),
            networkAddress.length > 0
                ? networkAddress[indexVal].type.toString()
                : "coin")
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "success");

          amountController.clear();
          addressController.clear();
          getCoinList();
          searchCoinList.clear();
          coinList.clear();
          coinList = [];
          searchCoinList = [];
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

  resndOTP() {
    setState(() {
      loading = true;
    });
    apiUtils.resendWithdrawOTP(axn_id).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Zurumi", loginData.message.toString(), "success");
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

  getCoinList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
          searchCoinList = loginData.result!;
          selectedCoin = coinList.first;

          getDetails();
          coinList..sort((a, b) => b.balance!.compareTo(a.balance!));
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}
