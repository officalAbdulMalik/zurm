import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/textformfield_custom.dart';
import 'package:zurumi/data/admin_bank-details_model.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/orange_pay_details.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';


import '../../../common/theme/custom_theme.dart';
import '../../common/custom_widget.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/deposit_details_model.dart';

class DepositScreen extends StatefulWidget {
  final String id;

  final List<UserWalletResult> coinList;

  const DepositScreen({Key? key, required this.id, required this.coinList})
      : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositAddressState();
}

class _DepositAddressState extends State<DepositScreen> {
  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchCoinList = [];
  String accounttype = "";
  List<String> accountTypelist = ["Wire Payment"];
  UserWalletResult? selectedCoin;
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  ScrollController controller = ScrollController();

  int indexVal = 0;
  String address = "";
  String type = "";

  String profileImage = "1";
  bool? selectImg = false;
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  String bank_name = "";
  String bank_address = "";
  String beneficiary_name = "";
  String beneficiary_address = "";
  String bank_routing_number = "";
  String bank_routing_swift = "";
  String bank_account_number = "";
  String sfox_ref_id = "";
  TextEditingController searchController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  List<NetworkAddress> networkAddress = [];
  bool bayment = false;
  bool orange = false;
  bool qrImage = false;
  Uint8List? qrImageDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    accounttype = accountTypelist.first;

    coinList = widget.coinList;
    searchCoinList = widget.coinList;
    for (int m = 0; m < coinList.length; m++) {
      if (coinList[m].name.toString() == widget.id) {
        selectedCoin = coinList[m];
      }
    }
    type = selectedCoin!.type.toString();

    getDetails();
    // getFiatDetails();
  }

  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          // backgroundColor: CustomTheme.of(context).primaryColor,
          appBar: AppBar(
            // backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
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
              AppLocalizations.of(context)!.translate("loc_deposit_address").toString(),
              style: TextStyle(
                fontFamily: 'FontSpecial',
                color: CustomTheme.of(context).cardColor,
                fontWeight: FontWeight.w500,
                fontSize: 17.0,
              ),
            ),
          ),
          body: Container(
              margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: <Color>[
                //     CustomTheme.of(context).secondaryHeaderColor,
                //     CustomTheme.of(context).primaryColor,
                //   ],
                //   tileMode: TileMode.mirror,
                // ),
              ),
              child: loading
                  ? CustomWidget(context: context).loadingIndicator(
                      CustomTheme.of(context).primaryColor,
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                showSheeet(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 10.0, 12, 10.0),
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
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).cardColor,
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
                                              color:
                                                  Theme.of(context).cardColor,
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            type.toString().toLowerCase() == "fiat"
                                ? fiatDeposit()
                                : cryptoDeposit()
                          ],
                        ),
                      ),
                    )),
        ));
  }

  Widget cryptoDeposit() {
    return Column(
      children: [
        // Center(
        //   child: Container(
        //     padding: EdgeInsets.all(1),
        //     decoration: BoxDecoration(
        //         boxShadow: kElevationToShadow[2],
        //         borderRadius: BorderRadius.circular(5),
        //         color: Colors.white),
        //     child: Image.network(
        //       "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
        //           address.toString(),
        //       height: 155.0,
        //       width: 150.0,
        //     ),
        //   ),
        // ),
        Center(
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            child:QrImageView(
              data:  "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
                  address.toString(),
              version: QrVersions.auto,
              size: 155.0,
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Center(
            child: InkWell(
          onTap: () async {
            // try {
            //   var imageId = await ImageDownloader.downloadImage(
            //       "https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl=" +
            //           address.toString());
            //   if (imageId == null) {
            //     return;
            //   }
            //   var path =
            //       await ImageDownloader.findPath(imageId);
            // } on PlatformException catch (error) {
            //   print(error);
            // }
          },
          child: Container(
            padding: EdgeInsets.all(4.0),
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[2],
              color: CustomTheme.of(context).canvasColor,
              borderRadius: BorderRadius.all(
                Radius.circular(3.0),
              ),
            ),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.translate("loc_save_qr").toString(),
                textAlign: TextAlign.center,
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).dialogBackgroundColor,
                    FontWeight.w400,
                    'FontRegular'),
              ),
            ),
          ),
        )),
        const SizedBox(
          height: 30.0,
        ),

        networkAddress.length > 0
            ? Container(
                height: 35.0,
                child: ListView.builder(
                  itemCount: networkAddress.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              indexVal = index;
                              address =
                                  networkAddress[index].address.toString();
                            });
                          },
                          child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                gradient: indexVal == index
                                    ? LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          CustomTheme.of(context)
                                              .primaryColorLight,
                                          CustomTheme.of(context)
                                              .primaryColorDark,
                                        ],
                                        tileMode: TileMode.mirror,
                                      )
                                    : LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          CustomTheme.of(context).focusColor,
                                          CustomTheme.of(context)
                                              .focusColor,
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                // color: indexVal==index?CustomTheme.of(context)
                                //     .backgroundColor:CustomTheme.of(context)
                                //     .disabledColor.withOpacity(0.4),
                              ),
                              child: Center(
                                child: Text(
                                  networkAddress[index]
                                      .name
                                      .toString()
                                      .toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                    indexVal == index? Theme.of(context).primaryColor:Theme.of(context).cardColor,
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
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              border: Border.all(
                width: 1.0,
                color: Theme.of(context).disabledColor,
              )),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(address == "" ? "Address not generated" : address,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).cardColor,
                        FontWeight.w400,
                        'FontRegular')),
              ),
              SizedBox(
                width: 20.0,
              ),
              InkWell(
                onTap: () {
                  if (address == "") {
                  } else {
                    Clipboard.setData(ClipboardData(text: address));
                    CustomWidget(context: context).showSuccessAlertDialog(
                        "Deposit", "Address was Copied", "success");
                  }
                },
                child: Icon(
                  Icons.copy,
                  color: Theme.of(context).cardColor,
                  size: 22.0,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        // Column(
        //   children: [
        //     Text(
        //       "H2cryptO’s API allows users to make market inquiries, trade automatically and perform various other tasks. You may find out more here ",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .hintColor
        //               .withOpacity(0.5),
        //           FontWeight.w400,
        //           'FontRegular'),
        //       textAlign: TextAlign.justify,
        //     ),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //     Text(
        //       "Each user may create up to 5 groups of API keys. The platform currently supports most mainstream currencies. For a full list of supported currencies, click here.",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .hintColor
        //               .withOpacity(0.5),
        //           FontWeight.w400,
        //           'FontRegular'),
        //       textAlign: TextAlign.justify,
        //     ),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //     Text(
        //       "Please keep your API key confidential to protect your account. For security reasons, we recommend you link your IP address with your API key. To link your API Key with multiple addresses, you may separate each of them with a comma such as 192.168.1.1, 192.168.1.2, 192.168.1.3. Each API key can be linked with up to 4 IP addresses.",
        //       style: CustomWidget(context: context).CustomSizedTextStyle(
        //           12.0,
        //           Theme
        //               .of(context)
        //               .hintColor
        //               .withOpacity(0.5),
        //           FontWeight.w400,
        //           'FontRegular'),
        //       textAlign: TextAlign.justify,
        //     ),
        //     SizedBox(
        //       height: 10.0,
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }

  Widget fiatDeposit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                          child: Text(
                            value.toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    14.0,
                                    Theme.of(context).cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                          ),
                          value: value,
                        ))
                    .toList(),
                onChanged: (dynamic value) async {
                  setState(() {
                    //loading =true;
                    accounttype = value;


                    amountController.clear();
                    if (accounttype == "Orange Payment") {
                      orange = true;
                    } else {
                      orange = false;
                    }
                  });
                },
                hint: Text(
                  AppLocalizations.of(context)!.translate("loc_select_coin").toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
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
        const SizedBox(
          height: 10.0,
        ),
        Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: CustomTheme.of(context).shadowColor.withOpacity(0.2),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("loc_benifiy_name").toString()+":",
                          style: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).hintColor.withOpacity(0.6),
                              FontWeight.w400,
                              'FontRegular'),
                        ),
                        Text(beneficiary_name,
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                    12.0,
                                    Theme.of(context).cardColor,
                                    FontWeight.w500,
                                    'FontRegular')),
                      ],
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: beneficiary_name));
                        CustomWidget(context: context).showSuccessAlertDialog(
                            "Deposit",
                            "Beneficiary Name was Copied",
                            "success");
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme.of(context).shadowColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Beneficiary Addres:",
                //           style: CustomWidget(context: context)
                //               .CustomTextStyle(
                //               Theme
                //                   .of(context)
                //                   .hintColor
                //                   .withOpacity(0.6),
                //               FontWeight.w500,
                //               'FontRegular'),),
                //         Text(beneficiary_address,
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 12.0,
                //                 Theme
                //                     .of(context)
                //                     .shadowColor,
                //                 FontWeight.w400,
                //                 'FontRegular')),
                //       ],
                //     ),),
                //     SizedBox(
                //       width: 30.0,
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Clipboard.setData(
                //             ClipboardData(text: beneficiary_address));
                //         CustomWidget(context: context).showSuccessAlertDialog("Deposit", "Beneficiary Addres was Copied", "success");
                //
                //       },
                //       child: Icon(
                //         Icons.copy,
                //         color: Theme
                //             .of(context)
                //             .shadowColor,
                //         size: 15.0,
                //       ),
                //     )
                //   ],
                // ),
                //
                // const SizedBox(height: 10.0,),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Bank Routing Number:",
                //           style: CustomWidget(context: context)
                //               .CustomTextStyle(
                //               Theme
                //                   .of(context)
                //                   .hintColor
                //                   .withOpacity(0.6),
                //               FontWeight.w500,
                //               'FontRegular'),),
                //         Text(bank_routing_number,
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 12.0,
                //                 Theme
                //                     .of(context)
                //                     .shadowColor,
                //                 FontWeight.w400,
                //                 'FontRegular')),
                //       ],
                //     ),),
                //     SizedBox(
                //       width: 30.0,
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Clipboard.setData(
                //             ClipboardData(text: bank_routing_number));
                //         CustomWidget(context: context).showSuccessAlertDialog("Deposit", "Bank Routing Number was Copied", "success");
                //
                //       },
                //       child: Icon(
                //         Icons.copy,
                //         color: Theme
                //             .of(context)
                //             .shadowColor,
                //         size: 15.0,
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(height: 10.0,),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("Bank Routing Swift:",
                //           style: CustomWidget(context: context)
                //               .CustomTextStyle(
                //               Theme
                //                   .of(context)
                //                   .hintColor
                //                   .withOpacity(0.6),
                //               FontWeight.w500,
                //               'FontRegular'),),
                //         Text(bank_routing_swift,
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 12.0,
                //                 Theme
                //                     .of(context)
                //                     .shadowColor,
                //                 FontWeight.w400,
                //                 'FontRegular')),
                //       ],
                //     ),),
                //     SizedBox(
                //       width: 30.0,
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Clipboard.setData(
                //             ClipboardData(text: bank_routing_swift));
                //         CustomWidget(context: context).showSuccessAlertDialog("Deposit", "Bank Routing Swift was Copied", "success");
                //
                //       },
                //       child: Icon(
                //         Icons.copy,
                //         color: Theme
                //             .of(context)
                //             .shadowColor,
                //         size: 15.0,
                //       ),
                //     )
                //   ],
                // ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.translate("loc_bank_acc").toString(),
                            style: CustomWidget(context: context)
                                .CustomTextStyle(
                                    Theme.of(context)
                                        .hintColor
                                        .withOpacity(0.6),
                                    FontWeight.w400,
                                    'FontRegular'),
                          ),
                          Text(bank_account_number,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      12.0,
                                      Theme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular')),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30.0,
                    ),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            ClipboardData(text: bank_account_number));
                        CustomWidget(context: context).showSuccessAlertDialog(
                            "Deposit",
                            "Bank Account Number was Copied",
                            "success");
                      },
                      child: Icon(
                        Icons.copy,
                        color: Theme.of(context).shadowColor,
                        size: 15.0,
                      ),
                    )
                  ],
                ),
                // const SizedBox(height: 10.0,),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text("User Reference Id:",
                //           style: CustomWidget(context: context)
                //               .CustomTextStyle(
                //               Theme
                //                   .of(context)
                //                   .hintColor
                //                   .withOpacity(0.6),
                //               FontWeight.w500,
                //               'FontRegular'),),
                //         Text(sfox_ref_id,
                //             style: CustomWidget(context: context)
                //                 .CustomSizedTextStyle(
                //                 12.0,
                //                 Theme
                //                     .of(context)
                //                     .shadowColor,
                //                 FontWeight.w400,
                //                 'FontRegular')),
                //       ],
                //     ),),
                //     SizedBox(
                //       width: 30.0,
                //     ),
                //     InkWell(
                //       onTap: () {
                //         Clipboard.setData(
                //             ClipboardData(text: sfox_ref_id));
                //         CustomWidget(context: context).showSuccessAlertDialog("Deposit", "User Reference Id was Copied", "success");
                //
                //       },
                //       child: Icon(
                //         Icons.copy,
                //         color: Theme
                //             .of(context)
                //             .shadowColor,
                //         size: 15.0,
                //       ),
                //     )
                //   ],
                // ),
              ],
            )),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          AppLocalizations.of(context)!.translate("loc_amount").toString()+" :",
          style: CustomWidget(context: context).CustomTextStyle(
              Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormFieldCustom(
          onEditComplete: () {
            amountFocus.unfocus();
          },
          radius: 5.0,
          // inputFormatters: [
          //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@0-9!_.]')),
          // ],
          error: AppLocalizations.of(context)!.translate("loc_ent_amt"),
          textColor: CustomTheme.of(context).cardColor,
          borderColor: CustomTheme.of(context).canvasColor,
          fillColor: CustomTheme.of(context).primaryColor,
          textInputAction: TextInputAction.next,
          focusNode: amountFocus,
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
              return "Please enter Amount";
            }

            return null;
          },
          enabled: true,
          textInputType: TextInputType.number,
          controller: amountController,
          hintStyle: CustomWidget(context: context).CustomTextStyle(
              Theme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
          textStyle: CustomWidget(context: context).CustomTextStyle(
              Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
        ),
        const SizedBox(
          height: 15.0,
        ),
        orange
            ? Container()
            : Text(
          AppLocalizations.of(context)!.translate("loc_slip").toString(),
                style: CustomWidget(context: context).CustomTextStyle(
                    Theme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
        orange
            ? Container()
            : const SizedBox(
                height: 10.0,
              ),
        orange
            ? Container()
            : InkWell(
                onTap: () {
                  onRequestPermission();
                },
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).disabledColor),
                      borderRadius: BorderRadius.circular(10.0),
                      image: profileImage == "1" || profileImage == "null"
                          ? DecorationImage(
                              image: AssetImage("assets/icons/choose.png"),
                              scale: 2.0)
                          : selectImg!
                              ? DecorationImage(
                                  image: FileImage(File(imageFile!.path)),
                                  fit: BoxFit.fill)
                              : DecorationImage(
                                  image: NetworkImage(profileImage),
                                  fit: BoxFit.fill)),
                ),
              ),

        const SizedBox(
          height: 20.0,
        ),

        orange&& qrImage?  Center(
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
                boxShadow: kElevationToShadow[2],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white),
            child: Image.memory(
            qrImageDetails!,
              height: 155.0,
              width: 150.0,
            ),
          ),
        ):Container(),
      orange?  const SizedBox(
          height: 20.0,
        ):Container(),
        InkWell(
          onTap: (){
            setState(() {
              if(amountController.text.isEmpty){
                CustomWidget(context: context).showSuccessAlertDialog("Zurumi","Please enter Amount", "error");

              } else {
                if(orange)
                  {

                    loading=true;
                    getQRCodeDetails();
                  }
                else{
                  if(selectImg!)
                  {

                    loading=true;
                    fiatDeposit();

                  }
                  else{
                    CustomWidget(context: context).showSuccessAlertDialog("Zurumi","Please Choose Slip", "error");
                  }
                }

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
                  CustomTheme.of(context).primaryColorDark,
                  CustomTheme.of(context).primaryColorLight,
                ],
                tileMode: TileMode.mirror,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              orange? AppLocalizations.of(context)!.translate("loc_get_qr").toString() : AppLocalizations.of(context)!.translate("loc_submit").toString(),
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  17.0,
                  CustomTheme.of(context).focusColor,
                  FontWeight.w500,
                  'FontRegular'),
            ),
          ),
        ),
      ],
    );
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: EdgeInsets.only(left: 20.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
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
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                              ),
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
                                      selectedCoin = coinList[index];
                                      indexVal = 0;

                                      accounttype=accountTypelist.first;
                                      beneficiary_name="";
                                      bank_account_number="";
                                      amountController.clear();
                                      if (selectedCoin!.symbol.toString() ==
                                          "XOF") {
                                        bayment = true;
                                        if(accountTypelist.length==1)
                                          {
                                            accountTypelist.add("Orange Payment");
                                          }


                                      } else {
                                        if (accountTypelist.length > 1) {
                                          accountTypelist.removeAt(1);
                                        }
                                      }

                                      type = coinList[index].type.toString();
                                      if (type != "fiat") {
                                        loading = true;

                                        address = "";
                                        getDetails();
                                      } else {
                                        getFiatDetails();
                                      }
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
                                              .primaryColorDark,
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
                                  height: 10.0,
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

  getDetails() {
    print("Here is data ${selectedCoin!.symbol.toString()}");
    apiUtils
        .getDepositDetails(selectedCoin!.symbol.toString())
        .then((DepositDetailsModel loginData) {
      setState(() {
        loading = false;

        if (loginData.success!) {
          address = loginData.result!.address.toString();
          networkAddress = [];
          if (loginData.network!.length > 0) {
            networkAddress = loginData.network!;
            address = loginData.network![0].address.toString();
          }
        } else {
          address = "";
          //   CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "error");
        }
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  getFiatDetails() {
    apiUtils
        .getAdminBank(selectedCoin!.symbol.toString())
        .then((AdminBankDetails loginData) {
      setState(() {
        loading = false;
        bank_account_number = loginData.result![0].split(":")[3].toString();
        beneficiary_name = loginData.result![0].split(":")[2].toString();
      });
    }).catchError((Object error) {
      print(error);
    });
  }

  getQRCodeDetails() {
    apiUtils
        .verifyPayServices(selectedCoin!.symbol.toString(),amountController.text.toString())
        .then((OrangePayDetails loginData) {
      setState(() {
        loading = false;
        if(loginData.success!)
          {
            qrImage=true;
            Uint8List _bytesImage;
            String _imgString = loginData.result!.qrCode.toString();

            _bytesImage = Base64Decoder().convert(_imgString);
            qrImageDetails=_bytesImage;

          }
        else{
          qrImage=false;
        }

      });
    }).catchError((Object error) {
      print(error);
    });
  }
  updateFiatDeposit() {
    apiUtils
        .verifyFiatDeposit(selectedCoin!.symbol.toString(),amountController.text.toString(),imageFile!.path)
        .then((CommonModel loginData) {
      setState(() {
        loading = false;
        if(loginData.status!)
          {
            amountController.clear();
            profileImage="1";
            CustomWidget(context: context).showSuccessAlertDialog("Zurumi",loginData.message.toString(), "success");

          }
        else
          {
            CustomWidget(context: context).showSuccessAlertDialog("Zurumi",loginData.message.toString(), "error");
          }

      });
    }).catchError((Object error) {
      print(error);
    });
  }

  onRequestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      _pickedImageDialog();
    } else {
      _pickedImageDialog();
    }
  }

  _pickedImageDialog() {
    showModalBottomSheet<void>(
      //background color for modal bottom screen
      backgroundColor: Theme.of(context).focusColor,
      //elevates modal bottom screen
      elevation: 10,
      isScrollControlled: true,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Choose Slip",
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(16.0, Theme.of(context).cardColor,
                              FontWeight.w600, 'FontRegular'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: InkWell(
                              onTap: (){
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery);
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
                                      CustomTheme.of(context).primaryColorDark,
                                      CustomTheme.of(context).primaryColorLight,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  "Gallery",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      17.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ),flex: 4,),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              flex: 4,
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    Navigator.pop(context);
                                    getImage(ImageSource.camera);
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
                                        CustomTheme.of(context).primaryColorDark,
                                        CustomTheme.of(context).primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    "Camera",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        17.0,
                                        CustomTheme.of(context).cardColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  getImage(ImageSource type) async {

    var pickedFile = await picker.pickImage(source: type);
    if (pickedFile != null) {
      setState(() {
        selectImg = true;
        imageFile = File(pickedFile.path);


      });
    }
  }
}
