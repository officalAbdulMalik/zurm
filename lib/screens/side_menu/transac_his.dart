import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';

import '../../data/api_utils.dart';
import '../../data/crypt_model/trade_his_model.dart';

class Transaction_History extends StatefulWidget {
  const Transaction_History({super.key});

  @override
  State<Transaction_History> createState() => _Transaction_HistoryState();
}

class _Transaction_HistoryState extends State<Transaction_History> {

  bool loading = false;
  ScrollController controller = ScrollController();
  APIUtils apiUtils = APIUtils();
  List<TradeHistory> historyList = [];
  final List<String> trasnType = ["loc_trade_history","loc_depo_history"];
  String selectedtrasnType = "";

  @override
  void initState() {
    // TODO: implement initState

 
    selectedtrasnType = trasnType.first;
    super.initState();
    getTransacHistory();


    loading=true;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
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
              color:  CustomTheme.of(context).shadowColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("loc_trans_his").toString(),
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme.of(context).cardColor,
            fontWeight: FontWeight.w500,
            fontSize: 17.0,
          ),
        ),
        toolbarHeight: 0.0,
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
              // CustomTheme.of(context).disabledColor.withOpacity(0.4),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Stack(
          children: [
            transacListUI(),
            loading
                ? CustomWidget(context: context).loadingIndicator(
              CustomTheme.of(context).primaryColor,
            )
                : Container(),
          ],
        ),
      ),
    ));
  }


  Widget transacListUI() {
    return Container(
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  AppLocalizations.of(context)!.translate("loc_trans_his").toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      17.0,
                      Theme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                InkWell(
                    onTap: () {
                     setState(() {
                       loading= true;
                       getTransacHistory();
                     });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColorLight.withOpacity(0.3),
                      ),
                      child:  Icon(
                        Icons.refresh_rounded,
                        size: 20.0,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    )),
              ],
            ),
          ),
    //       Container(
    //         margin: EdgeInsets.only(top: 50,left: 10.0,right: 10.0),
    //         height: 40.0,
    //         padding: const EdgeInsets.only(
    //             left: 10.0,
    //             right: 10.0,
    //             top: 0.0,
    //             bottom: 0.0),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(5.0),
    //           color:
    //           CustomTheme.of(context).backgroundColor.withOpacity(0.5),
    //         ),
    //         child: Center(
    //           child: Theme(
    //             data: Theme.of(context).copyWith(
    //               canvasColor: CustomTheme.of(context)
    //                   .focusColor,
    //             ),
    //             child: DropdownButtonHideUnderline(
    //               child: DropdownButton(
    //                 items: trasnType
    //                     .map((value) =>
    //                     DropdownMenuItem(
    //                       child: Text(
    // AppLocalizations.of(context)!.translate(value).toString(),
    //                         style: CustomWidget(
    //                             context:
    //                             context)
    //                             .CustomSizedTextStyle(
    //                             12.0,
    //                             Theme.of(
    //                                 context)
    //                                 .cardColor,
    //                             FontWeight.w500,
    //                             'FontRegular'),
    //                       ),
    //                       value: value,
    //                     ))
    //                     .toList(),
    //                 onChanged: (value) {
    //                   setState(() {
    //                     selectedtrasnType =
    //                         value.toString();
    //                   });
    //                 },
    //                 isExpanded: true,
    //                 value: selectedtrasnType,
    //                 icon: Icon(
    //                   Icons.keyboard_arrow_down,
    //                   color: CustomTheme.of(context)
    //                       .cardColor,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 10.0,),
          tradeHistory()
        ],
      ),
    );
  }
Widget tradeHistory(){
    return           historyList.length>0 ?Container(
      height: MediaQuery.of(context).size.height,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.12),
      padding: EdgeInsets.only(bottom: 10.0),
      child:
      SingleChildScrollView(
        child: ListView.builder(
            itemCount: historyList.length,
            shrinkWrap: true,
            controller: controller,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ChatScreen(
                      //       ticket_id: ticketList[index]
                      //           .ticketId
                      //           .toString(),
                      //     )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 5.0),
                      padding: EdgeInsets.only(left: 15.0, right: 15.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              CustomTheme.of(context).primaryColorLight.withOpacity(0.4),
                              CustomTheme.of(context).primaryColorDark.withOpacity(0.4),
                            ],
                            tileMode: TileMode.mirror,
                          ),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_pairs").toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                historyList[index].pair.toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_trans_typ").toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                historyList[index].tradeType.toString(),
                                // DateFormat("MMM d,yyyy")
                                //     .format(ticketList[index]
                                //     .createdAt!)
                                //     .toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .indicatorColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_trans_amt").toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                historyList[index].price.toString(),
                                // ticketList[index]
                                //     .message
                                //     .toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_date").toString() + " :",
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                DateFormat("MMM d,yyyy")
                                    .format(historyList[index]
                                    .createdAt!)
                                    .toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate("loc_status").toString() + " : ",
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                historyList[index].status.toString(),
                                style: CustomWidget(
                                    context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .primaryColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0,)
                ],
              );
            }),
      ),
    ) :   Container(
      height: MediaQuery.of(context).size.height * 0.3,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            CustomTheme.of(context).secondaryHeaderColor,
            CustomTheme.of(context).secondaryHeaderColor,
          ],
          tileMode: TileMode.mirror,
        ),),
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
    );
}

  getTransacHistory() {
    apiUtils.getTradeHis().then((TradeHistoryModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          historyList = loginData.result!.tradeHistory!;
        });
      } else {
        setState(() {
          loading = false;
        });
      }
    }).catchError((Object error) {
      print("Mano");
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

}

