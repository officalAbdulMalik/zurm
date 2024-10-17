import 'package:flutter/material.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';

import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/stack_his_list_model.dart';

class StackHistory extends StatefulWidget {
  const StackHistory({Key? key}) : super(key: key);

  @override
  State<StackHistory> createState() => _StackHistoryState();
}

class _StackHistoryState extends State<StackHistory> {
  bool loading = false;

  ScrollController _scrollController = ScrollController();

  List<StackHistoryList> stackList = [];
  APIUtils apiUtils = APIUtils();
  String livePrice="0.000";

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
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate("loc_stak_his").toString(),
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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: CustomTheme.of(context).secondaryHeaderColor,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      stack(),
                      loading
                          ? CustomWidget(context: context).loadingIndicator(
                              CustomTheme.of(context).primaryColor,
                            )
                          : Container()
                    ],
                  ))),
        ));
  }

  Widget stack() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0,),
            stackList.length > 0
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: ListView.builder(
                        itemCount: stackList.length,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                           double staked=double.parse(stackList[index].noOfCoin.toString())/double.parse(livePrice);
                           double total=double.parse(stackList[index].totalEstimatedReward.toString())/double.parse(livePrice);
                          return Column(
                            children: [
                              Container(
                                width:
                                MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(top: 15.0,bottom: 15.0
                                   ),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: <Color>[
                                      CustomTheme.of(context).highlightColor.withOpacity(0.5),
                                      CustomTheme.of(context).disabledColor,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                  Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_title").toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .cardColor.withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            stackList[index]
                                                .stakingTitle
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                14.0,
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w600,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                      ),
                                      Column(

                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_date").toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .cardColor.withOpacity(0.5),
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            stackList[index]
                                                .createdAt
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                      )
                                    ],
                                  ),),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      height: 1.0,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_depo_coin").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              stackList[index]
                                                  .depositCoin
                                                  .toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        Column(

                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_amount").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              stackList[index]
                                                  .actualStakingAmount
                                                  .toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                        )
                                      ],
                                    ),),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_zet_stk").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                            stackList[index].durationTitle.toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        Column(

                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_tot_rewd").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              stackList[index].totalEstimatedReward.toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                        )
                                      ],
                                    ),),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_stk_rewd").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              stackList[index].annualYield.toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        Column(

                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_lst_rewd").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              stackList[index]
                                                  .lastReward
                                                  .toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                        )
                                      ],
                                    ),),

                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Container(
                                      height: 1.0,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Padding(padding: EdgeInsets.only(left: 10.0,right: 10.0),child:    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_nxt_rewd").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                          stackList[index].nextReward.toString()==""||stackList[index].nextReward.toString()=="null" || stackList[index].nextReward.toString()==null ? "---" : stackList[index].nextReward.toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                        ),
                                        Column(

                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_action").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor.withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              "---",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                        )
                                      ],
                                    ),),const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          );
                        },
                      ),
                    ))
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
              height: 25.0,
            ),
          ],
        ),
      ),
    );
  }

  getStackList() {
    apiUtils.getStackHistory().then((StackHistoryListmodel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          stackList = loginData.data!;
          livePrice=loginData.livePrice!.toString();
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
}
