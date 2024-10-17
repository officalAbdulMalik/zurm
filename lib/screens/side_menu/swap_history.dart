import 'package:flutter/material.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/custom_widget.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/swap_history_model.dart';

class Swap_History extends StatefulWidget {
  const Swap_History({super.key});

  @override
  State<Swap_History> createState() => _Swap_HistoryState();
}

class _Swap_HistoryState extends State<Swap_History> {

  bool loading = false;
  ScrollController _scrollController = ScrollController();
  APIUtils apiUtils = APIUtils();
  List<SwapHistory> historyList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getSwapHistory();
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
                AppLocalizations.of(context)!.translate("loc_swap_his").toString(),
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
              color: CustomTheme.of(context).focusColor.withOpacity(0.5),
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Stack(
                    children: [
                      swap(),
                      loading
                          ? CustomWidget(context: context).loadingIndicator(
                        CustomTheme.of(context).primaryColor,
                      )
                          : Container()
                    ],
                  ))),
        ));
  }

  Widget swap() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0,),
            historyList.length > 0
                ?
            Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemBuilder: (BuildContext context, int index) {
                      // double staked=double.parse(stackList[index].noOfCoin.toString())/double.parse(livePrice);
                      // double total=double.parse(stackList[index].totalEstimatedReward.toString())/double.parse(livePrice);
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
                                  CustomTheme.of(context).secondaryHeaderColor,
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
                                          AppLocalizations.of(context)!.translate("loc_rcev_coin").toString(),
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
                                         historyList[index].receiveCoin.toString(),
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
                                          AppLocalizations.of(context)!.translate("loc_spn_coin").toString(),
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
                                          historyList[index].spendCoin.toString(),
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
                                          AppLocalizations.of(context)!.translate("loc_volum").toString(),
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
                                         historyList[index].volume.toString(),
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
                                          AppLocalizations.of(context)!.translate("loc_val").toString(),
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
                                          historyList[index].value.toString(),
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
                                          AppLocalizations.of(context)!.translate("loc_fee").toString(),
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
                                          historyList[index].fees.toString(),
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
                                          AppLocalizations.of(context)!.translate("loc_status").toString(),
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
                                          historyList[index].statusText.toString(),
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


  getSwapHistory() {
    apiUtils.getSwapHis().then((SwapHistoryModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          historyList = loginData.result!;
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
