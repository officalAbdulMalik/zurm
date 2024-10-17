import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/common/localization/app_localizations.dart';


import '../../common/custom_widget.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/bank_model.dart';
import '../../data/crypt_model/common_model.dart';
import 'add_bank_details.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({Key? key}) : super(key: key);

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool loading = false;
  APIUtils apiUtils = APIUtils();

  ScrollController controller = ScrollController();
  List<BankList> bankList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getBankList();
  }

  _getRequests() async {
    setState(() {
      loading = true;
      getBankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      // appBar: AppBar(
      //   backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
      //   elevation: 0.0,
      //   leading: InkWell(
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //         child: Container(
      //           padding: EdgeInsets.only(left: 16.0, right: 16.0),
      //           child: Icon(
      //             Icons.arrow_back,
      //             size: 25.0,
      //             color: CustomTheme.of(context).shadowColor,
      //           ),
      //         ),
      //       ),
      //       centerTitle: true,
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
      //       child: InkWell(
      //         onTap: () {
      //           Navigator.of(context)
      //               .push(
      //             MaterialPageRoute(builder: (_) => AddBankScreen()),
      //           )
      //               .then((val) => val ? _getRequests() : null);
      //         },
      //         child: Container(
      //           decoration: BoxDecoration(
      //               color: CustomTheme.of(context).cardColor,
      //               borderRadius: BorderRadius.circular(5.0)),
      //           padding: EdgeInsets.all(5.0),
      //           child: Icon(
      //             Icons.add,
      //             size: 20.0,
      //             color: CustomTheme.of(context).primaryColor,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      //   title: Text(
      //     "Bank Details",
      //     style: CustomWidget(context: context).CustomSizedTextStyle(17.0,
      //         Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
      //   ),
      // ),
      body: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              CustomTheme.of(context).secondaryHeaderColor,
              CustomTheme.of(context).secondaryHeaderColor,
              // CustomTheme.of(context).disabledColor,
            ],
            tileMode: TileMode.mirror,
          ),),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
          child: loading
              ? CustomWidget(context: context).loadingIndicator(
            CustomTheme.of(context).primaryColor,
          )
              : bankDetails(),
        ),
      ),
    ));
  }

  Widget bankDetails() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                MaterialPageRoute(builder: (_) => AddBankScreen()),
                              )
                                  .then((val) => val ? _getRequests() : null);
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: CustomTheme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(5.0)),
                                padding: EdgeInsets.all(5.0),
                                child: Icon(
                                  Icons.add,
                                  size: 20.0,
                                  color: CustomTheme.of(context).primaryColor,
                                ),
                              ),
                            )
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      bankList.length > 0
                          ?  ListView.builder(
                        itemCount: bankList.length,
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          CustomTheme.of(context).primaryColorLight.withOpacity(0.5),
                                          CustomTheme.of(context).primaryColorDark.withOpacity(0.5),
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                      borderRadius: BorderRadius.circular(10.0)),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  // "Name",
                                                  "",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  // bankList[index]
                                                  //     .accountName
                                                  //     .toString(),
                                                  "",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                            ),
                                            InkWell(
                                              child: Container(
                                                padding: EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // color: CustomTheme.of(context).shadowColor.withOpacity(0.5),
                                                    border: Border.all(width: 1.0,color: CustomTheme.of(context).primaryColor.withOpacity(0.5))
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  size: 20.0,
                                                  color: Theme.of(context)
                                                      .splashColor,
                                                ),
                                              ),
                                              onTap: () {
                                                deleteDialog(bankList[index]
                                                    .id
                                                    .toString());
                                              },
                                            )
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                          height: 0.8,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topLeft,
                                              colors: <Color>[
                                                CustomTheme.of(context).disabledColor,
                                                CustomTheme.of(context).disabledColor.withOpacity(0.5),
                                                CustomTheme.of(context).primaryColor,
                                              ],
                                              tileMode: TileMode.mirror,
                                            ),
                                            borderRadius: BorderRadius.circular(10.0),
                                          )
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.translate("loc_acc_no").toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index].accountNo=="null"||bankList[index].accountNo==null ? "--" : bankList[index].accountNo.toString() ,
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.translate("loc_acc_type").toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index].type=="null" || bankList[index].type==null ? "--" : bankList[index].type.toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 8.0, right: 8.0, top: 5.0),
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.translate("loc_bank_name").toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index].bankName=="null" || bankList[index].bankName== null ? "--" :bankList[index].bankName.toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!.translate("loc_bank_IFSC").toString(),
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .cardColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  bankList[index].swiftCode=="null" || bankList[index].swiftCode== null ? "--" :bankList[index].swiftCode.toString(),
                                                  // "",
                                                  style: CustomWidget(
                                                      context: context)
                                                      .CustomTextStyle(
                                                      Theme.of(context)
                                                          .splashColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ],
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                            ),
                                          ],
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      // Container(
                                      //   height: 0.8,
                                      //     decoration: BoxDecoration(
                                      //       gradient: LinearGradient(
                                      //         begin: Alignment.bottomRight,
                                      //         end: Alignment.topLeft,
                                      //         colors: <Color>[
                                      //           CustomTheme.of(context).disabledColor,
                                      //           CustomTheme.of(context).disabledColor.withOpacity(0.5),
                                      //           CustomTheme.of(context).primaryColor,
                                      //         ],
                                      //         tileMode: TileMode.mirror,
                                      //       ),
                                      //       borderRadius: BorderRadius.circular(10.0),
                                      //     )
                                      // ),
                                      // const SizedBox(
                                      //   height: 5.0,
                                      // ),
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       left: 10.0,
                                      //       right: 10.0,
                                      //       top: 5.0,
                                      //       bottom: 5.0),
                                      //   child: Row(
                                      //     children: [
                                      //       Column(
                                      //         children: [
                                      //           Text(
                                      //             AppLocalizations.of(context)!.translate("loc_bank_name"),
                                      //             style: CustomWidget(
                                      //                 context: context)
                                      //                 .CustomTextStyle(
                                      //                 Theme.of(context)
                                      //                     .cardColor,
                                      //                 FontWeight.w400,
                                      //                 'FontRegular'),
                                      //             softWrap: true,
                                      //             overflow:
                                      //             TextOverflow.ellipsis,
                                      //           ),
                                      //           Text(
                                      //             bankList[index]
                                      //                 .bankName
                                      //                 .toString(),
                                      //             style: CustomWidget(
                                      //                 context: context)
                                      //                 .CustomTextStyle(
                                      //                 Theme.of(context)
                                      //                     .splashColor,
                                      //                 FontWeight.w400,
                                      //                 'FontRegular'),
                                      //             softWrap: true,
                                      //             overflow:
                                      //             TextOverflow.ellipsis,
                                      //           ),
                                      //         ],
                                      //         crossAxisAlignment:
                                      //         CrossAxisAlignment.start,
                                      //       ),
                                      //       Column(
                                      //         children: [
                                      //           Text(
                                      //             "Is International",
                                      //             style: CustomWidget(
                                      //                 context: context)
                                      //                 .CustomTextStyle(
                                      //                 Theme.of(context)
                                      //                     .cardColor,
                                      //                 FontWeight.w400,
                                      //                 'FontRegular'),
                                      //             softWrap: true,
                                      //             overflow:
                                      //             TextOverflow.ellipsis,
                                      //           ),
                                      //           Text(
                                      //             // bankList[index]
                                      //             //     .internationalBank
                                      //             //     .toString() ==
                                      //             //     "false"
                                      //             //     ? "NO"
                                      //             //     : "YES",
                                      //             "yes",
                                      //             style: CustomWidget(
                                      //                 context: context)
                                      //                 .CustomTextStyle(
                                      //                 Theme.of(context)
                                      //                     .splashColor,
                                      //                 FontWeight.w400,
                                      //                 'FontRegular'),
                                      //             softWrap: true,
                                      //             overflow:
                                      //             TextOverflow.ellipsis,
                                      //           ),
                                      //         ],
                                      //         crossAxisAlignment:
                                      //         CrossAxisAlignment.end,
                                      //       ),
                                      //     ],
                                      //     mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      //     crossAxisAlignment:
                                      //     CrossAxisAlignment.center,
                                      //   ),
                                      // ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 10.0,),
                            ],
                          );
                        },
                      ) : Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.38),
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.translate("loc_no_rec_found").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                16.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ),
                      )
                    ],
                  ),
                ))

          ],
        ));
  }


  getBankList() {
    apiUtils.getBankDetails().then((BankListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          bankList = loginData.result!;
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

  removeBank(String id) {
    apiUtils.removebankDetails(id).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "success");
          getBankList();
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  deleteDialog(String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                // color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    CustomTheme.of(context).disabledColor,
                    CustomTheme.of(context).primaryColor,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.24,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GradientText(
                      AppLocalizations.of(context)!.translate("loc_are_sure").toString().toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          16.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w600,
                          'FontRegular'),
                      colors: [
                        CustomTheme.of(context).primaryColorDark,
                        CustomTheme.of(context).primaryColorLight,
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 7.0, bottom: 10.0),
                        height: 2.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: <Color>[
                              CustomTheme.of(context).disabledColor,
                              CustomTheme.of(context).disabledColor.withOpacity(0.5),
                              CustomTheme.of(context).primaryColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    Text(
                      AppLocalizations.of(context)!.translate("loc_del_acc").toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                          15.0,
                          Theme.of(context).cardColor,
                          FontWeight.w400,
                          'FontRegular'),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    CustomTheme.of(context).primaryColorDark,
                                    CustomTheme.of(context).primaryColorLight,
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_ok").toString().toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      15.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                loading = true;
                                removeBank(id);
                                Navigator.pop(context);
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          child: InkWell(
                            child: Container(
                              width: 100,
                              height: 40,
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    CustomTheme.of(context).primaryColorDark,
                                    CustomTheme.of(context).primaryColorLight,
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_cancel").toString().toUpperCase(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      15.0,
                                      Theme.of(context).splashColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }
}
