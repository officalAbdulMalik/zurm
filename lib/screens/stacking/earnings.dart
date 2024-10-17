import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';

import 'package:zurumi/common/textformfield_custom.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/earning_list_model.dart';
import 'package:zurumi/screens/stacking/earning_history_screen.dart';

class Earnings extends StatefulWidget {
  const Earnings({Key? key}) : super(key: key);

  @override
  State<Earnings> createState() => _EarningsState();
}

class _EarningsState extends State<Earnings> {
  bool loading = false;

  List<EarningList> earnList = [];
  APIUtils apiUtils = APIUtils();
  ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  FocusNode subjectFocus = FocusNode();

  TextEditingController subjectController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getStackList();
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
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate("loc_earns").toString(),
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
              decoration: BoxDecoration(
                color: CustomTheme.of(context).secondaryHeaderColor.withOpacity(.5),
                // gradient: LinearGradient(
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                //   colors: <Color>[
                //     CustomTheme.of(context).secondaryHeaderColor,
                //     CustomTheme.of(context).primaryColor,
                //     CustomTheme.of(context).disabledColor,
                //   ],
                //   tileMode: TileMode.mirror,
                // ),
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                      child: earningUI(),
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

  Widget earningUI() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            earnList.length > 0
                ? ListView.builder(
                    itemCount: earnList.length,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, index) {
                      String amt = "0";
                      if (earnList[index].key.toString() == "") {
                        amt = earnList[index].amount.toString();
                      }
                      amt = amt.replaceAll("SET", "");
                      return Column(
                        children: [
                          InkWell(

                            child:  Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(
                                  15.0, 20.0, 15.0, 20.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10.0),
                                // boxShadow: kElevationToShadow[2],
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomTheme.of(context)
                                        .secondaryHeaderColor,
                                    CustomTheme.of(context)
                                        .disabledColor.withOpacity(0.5),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                                //  color: Theme.of(context).secondaryHeaderColor,
                              ),
                              child:Row(

                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,

                                    children: [

                                      Image.network(earnList[index].image.toString(),height: 50.0,),

                                      const SizedBox(width: 10.0,),
                                      Column(
                                        children: [
                                          Text(
                                            earnList[index]
                                                .name
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                16.0,
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w600,
                                                'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                          Text(
                                            earnList[index]
                                                .amount
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      ),

                                    ],
                                  ),
                                  earnList[index]
                                      .key
                                      .toString() ==
                                      "" &&
                                      double.parse(amt) > 0
                                      ? const SizedBox(
                                    height: 10.0,
                                  )
                                      : Container(),
                                  earnList[index]
                                      .key
                                      .toString() ==
                                      ""
                                      ? InkWell(
                                    onTap: () {
                                      createWithdraw(amt);
                                    },
                                    child: Container(
                                      padding:
                                      EdgeInsets.only(
                                          top: 5.0,
                                          bottom: 5.0,
                                          left: 25.0,
                                          right: 25.0),
                                      alignment:
                                      Alignment.center,
                                      decoration:
                                      BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            4.0),
                                        gradient:
                                        LinearGradient(
                                          begin: Alignment
                                              .bottomLeft,
                                          end: Alignment
                                              .topRight,
                                          colors: <Color>[
                                            CustomTheme.of(
                                                context)
                                                .primaryColorDark,
                                            CustomTheme.of(
                                                context)
                                                .primaryColorLight,
                                          ],
                                          tileMode: TileMode
                                              .mirror,
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate("loc_withdraw").toString(),
                                        style: CustomWidget(
                                            context:
                                            context)
                                            .CustomSizedTextStyle(
                                            10.0,
                                            Theme.of(
                                                context)
                                                .primaryColor,
                                            FontWeight
                                                .w400,
                                            'FontRegular'),
                                        textAlign: TextAlign
                                            .center,
                                      ),
                                    ),
                                  )
                                      : Container()
                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              )
                            ),onTap: (){

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EarningHistoryScreen(
                                          type: earnList[
                                          index]
                                              .key
                                              .toString()),
                                ));
                          },
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                        ],
                      );
                    },
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.5,
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
                  ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  createWithdraw(String amt) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    CustomTheme.of(context).secondaryHeaderColor,
                    CustomTheme.of(context).primaryColor,
                    CustomTheme.of(context).disabledColor,
                  ],
                  tileMode: TileMode.mirror,
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(),
                            GradientText(
                              AppLocalizations.of(context)!.translate("loc_withdraw").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                              colors: [
                                CustomTheme.of(context).primaryColorDark,
                                CustomTheme.of(context).primaryColorLight,
                              ],
                            ),
                            // Text(
                            //   "Create Ticket",
                            //   style: TextStyle(
                            //       fontSize: 18.0,
                            //       color: Theme.of(context)
                            //           .cardColor,
                            //       fontWeight: FontWeight.w700,
                            //       fontFamily: 'FontRegular'),
                            //   textAlign: TextAlign.center,
                            // ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                subjectController.clear();
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15.0),
                                decoration: BoxDecoration(
                                  color: CustomTheme.of(context).shadowColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.close,
                                      color:
                                          CustomTheme.of(context).primaryColor,
                                      size: 15.0),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate("loc_amount").toString(),
                          style: CustomWidget(context: context).CustomTextStyle(
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        TextFormFieldCustom(
                          obscureText: false,
                          textInputAction: TextInputAction.done,
                          hintStyle: CustomWidget(context: context)
                              .CustomTextStyle(Theme.of(context).dividerColor,
                                  FontWeight.w400, 'FontRegular'),
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_.$]')),
                          // ],
                          textStyle: CustomWidget(context: context)
                              .CustomTextStyle(
                                  CustomTheme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                          radius: 5.0,
                          focusNode: subjectFocus,
                          controller: subjectController,
                          enabled: true,
                          textColor: CustomTheme.of(context).primaryColor,
                          borderColor: CustomTheme.of(context).canvasColor,
                          fillColor: CustomTheme.of(context).canvasColor,
                          onChanged: () {},
                          hintText: AppLocalizations.of(context)!.translate("loc_amount").toString(),
                          textChanged: (value) {},
                          suffix: Container(width: 0.0),
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please enter the Amount";
                            }
                            return null;
                          },
                          maxlines: 1,
                          error: "Enter the Amount",
                          text: "",
                          onEditComplete: () {
                            subjectFocus.unfocus();
                          },
                          textInputType: TextInputType.number,

                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                dowithdraw();
                              }
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
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.translate("loc_submit").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      17.0,
                                      CustomTheme.of(context).primaryColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  getStackList() {
    apiUtils.getEarninglist().then((EarningListmodel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          earnList = loginData.result!;
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

  dowithdraw() {
    apiUtils
        .doStakingWithdraw(subjectController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = true;
          getStackList();

          CustomWidget(context: context).showSuccessAlertDialog(
              "Withdraw", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Withdraw", loginData.message.toString(), "error");
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
