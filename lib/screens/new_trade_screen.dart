
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';

class New_Trade_Screen extends StatefulWidget {
  const New_Trade_Screen({super.key});

  @override
  State<New_Trade_Screen> createState() => _New_Trade_ScreenState();
}

class _New_Trade_ScreenState extends State<New_Trade_Screen> with TickerProviderStateMixin {

  bool chart= false;
  bool trade= false;
  bool spot= false;
  bool margin= false;
  bool buy= false;
  bool sell= false;
  bool enableTrade = false;
  String price = "0.00";
  String tradeAmount = "0.00";
  bool buyOption = true;
  bool sellOption = true;

  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  late TabController _tabController, tradeTabController;
  ScrollController controller = ScrollController();

  String selectedTime = "";
  String selectedDecimal = "";
  int decimalIndex = 2;

  List<String> chartTime = [
    "Limit Order",
    "Market Order",
  ];
  final List<String> _decimal = [
    "0.01",
    "0.0001",
    "0.00000001",
  ];

  String val = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    trade = true;
    spot = true;
    buy = true;
    selectedTime = chartTime.first;
    selectedDecimal = _decimal.first;
    _tabController = TabController(vsync: this, length: 2);
  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: CustomTheme.of(context).secondaryHeaderColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0,),
              Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.start,
               children: [
                 GestureDetector(
                   onTap: (){
                     setState(() {
                       spot = true;
                       margin = false;
                     });
                   },
                   child: Text(
                     "Spot",
                     style: CustomWidget(context: context).CustomSizedTextStyle(
                         spot ?  14.0 : 14.5,
                         spot ? CustomTheme.of(context).cardColor : CustomTheme.of(context).scaffoldBackgroundColor,
                         FontWeight.w500,
                         'FontRegular'),
                   ),
                 ),
                 const SizedBox(width: 10.0,),
                 GestureDetector(
                   onTap: (){
                     setState(() {
                       spot = false;
                       margin = true;
                     });
                   },
                   child: Text(
                     "Margin",
                     style: CustomWidget(context: context).CustomSizedTextStyle(
                         margin? 14.0 : 14.5,
                         margin?  CustomTheme.of(context).cardColor : CustomTheme.of(context).scaffoldBackgroundColor,
                         FontWeight.w500,
                         'FontRegular'),
                   ),
                 )
               ],
             ),
              const SizedBox(height: 15.0,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: CustomTheme.of(context).cardColor.withOpacity(0.4),
                ),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(child: InkWell(
                      onTap: (){
                        setState(() {
                          trade= false;

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        decoration: trade ? BoxDecoration() : BoxDecoration(
                          color:  CustomTheme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          "Charts",
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              CustomTheme.of(context).focusColor,
                              FontWeight.w500,
                              'FontRegular'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ), flex: 1,),
                    Flexible(child: InkWell(
                      onTap: (){
                        setState(() {
                          trade= true;

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        decoration: trade ? BoxDecoration(
                          color:  CustomTheme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ) : BoxDecoration(),
                        child: Text(
                          "Trade",
                          style: CustomWidget(context: context).CustomSizedTextStyle(
                              14.0,
                              CustomTheme.of(context).focusColor,
                              FontWeight.w500,
                              'FontRegular'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ), flex: 1,)
                  ],
                ),
              ),
              const SizedBox(height: 15.0,),
              trade ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(child: buySell(), flex: 3,),
                    Flexible(child: marketOrder(), flex: 2,)
                  ],
                ),
              ) : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset("assets/icons/trade.png", height: MediaQuery.of(context).size.height * 0.35, width: MediaQuery.of(context).size.width,)
                  ],
                ),
              ),

              const SizedBox(height: 15.0,),

              // Container(
              //   height: 35.0,
              //   width: MediaQuery.of(context).size.width,
              //   padding: const EdgeInsets.only(
              //       left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(5.0),
              //     color: CustomTheme.of(context).canvasColor,
              //   ),
              //   child: Theme(
              //     data: Theme.of(context).copyWith(
              //       canvasColor: CustomTheme.of(context).canvasColor,
              //     ),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton(
              //         items: _decimal
              //             .map((value) => DropdownMenuItem(
              //           child: Text(
              //             value,
              //             style: CustomWidget(context: context)
              //                 .CustomSizedTextStyle(
              //                 12.0,
              //                 Theme.of(context).cardColor,
              //                 FontWeight.w500,
              //                 'FontRegular'),
              //           ),
              //           value: value,
              //         ))
              //             .toList(),
              //         onChanged: (value) {
              //           setState(() {
              //             selectedDecimal = value.toString();
              //             for (int m = 0; m < _decimal.length; m++) {
              //               if (value == _decimal[m]) {
              //                 if (m == 0) {
              //                   decimalIndex = 2;
              //                 } else if (m == 1) {
              //                   decimalIndex = 4;
              //                 } else {
              //                   decimalIndex = 8;
              //                 }
              //               }
              //             }
              //           });
              //         },
              //         isExpanded: false,
              //         value: selectedDecimal,
              //         icon: Icon(
              //           Icons.keyboard_arrow_down,
              //           color: CustomTheme.of(context).cardColor,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),


              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Container(
                      height: 40.0,
                      padding: EdgeInsets.all(3.0),
                      child: TabBar(
                        controller: _tabController,
                        dividerColor: CustomTheme.of(context).secondaryHeaderColor,
                        labelStyle: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            12.0,
                            Theme.of(context).cardColor,
                            FontWeight.w600,
                            'FontRegular'),

                        labelColor: CustomTheme.of(context).cardColor,
                        //<-- selected text color
                        unselectedLabelColor: Color(0xFFA7AFB7),
                        // isScrollable: true,
                        indicatorColor: CustomTheme.of(context).secondaryHeaderColor,
                        indicator: BoxDecoration(
                          // Creates border
                          color:
                          CustomTheme.of(context).secondaryHeaderColor,
                        ),
                        tabs: <Widget>[
                          Tab(
                            text: AppLocalizations.of(context)!.translate("loc_opnord").toString(),
                          ),
                          // Tab(
                          //   text: AppLocalizations.of(context)!.translate("loc_ordcbook").toString(),
                          // ),
                          Tab(
                            text: AppLocalizations.of(context)!.translate("loc_mkt_trade").toString(),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        color: CustomTheme.of(context).secondaryHeaderColor,
                        child: TabBarView(
                          controller: _tabController,
                          children: <Widget>[
                            openOrdersUI(),
                            // marketOrder(),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: <Color>[
                                    CustomTheme.of(context).secondaryHeaderColor,
                                    CustomTheme.of(context).secondaryHeaderColor,
                                    CustomTheme.of(context).secondaryHeaderColor,
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_com_soon").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    ));
  }


  Widget buySell() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.menu_open_outlined, size: 22.0, color: CustomTheme.of(context).cardColor,),
                const SizedBox(width: 5.0,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      // spot = true;
                      // margin = false;
                    });
                  },
                  child: Text(
                    "Eth/Usdt".toUpperCase(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        15.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ),
                const SizedBox(width: 5.0,),
                Container(
                  padding: EdgeInsets.only(top: 1.0, bottom: 1.0, right: 2.0, left: 2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: CustomTheme.of(context).hoverColor.withOpacity(0.2),
                  ),
                  child: Text(
                    "-4.25%",
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        9.0,
                        CustomTheme.of(context).hoverColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                )
              ],
            ),
            const SizedBox(height: 15.0,),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).cardColor.withOpacity(0.4),
              ),
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(child: InkWell(
                    onTap: (){
                      setState(() {
                        buy= true;
                        sell= false;

                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: buy ? BoxDecoration(
                        color:  CustomTheme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ) : BoxDecoration(),
                      child: Text(
                        "Buy",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            13.0,
                            CustomTheme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ), flex: 1,),
                  Flexible(child: InkWell(
                    onTap: (){
                      setState(() {
                        buy= false;
                        sell= true;
                      });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: sell ? BoxDecoration(
                        color:  CustomTheme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(5.0),
                      ) : BoxDecoration(),
                      child: Text(
                        "Sell",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            13.0,
                            CustomTheme.of(context).focusColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ), flex: 1,)
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Available",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      10.0,
                      CustomTheme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                Row(
                  children: [
                    Text(
                      "0 ETH",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    ),
                    const SizedBox(width: 5.0,),
                    Icon(Icons.add_circle_outline, size: 16.0, color: CustomTheme.of(context).disabledColor,),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0,),
            Container(
              height: 26.0,
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
                    items: chartTime
                        .map((value) => DropdownMenuItem(
                      child: Text(
                        value,
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      ),
                      value: value,
                    ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTime = value.toString();

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
            const SizedBox(height: 8.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Container(
                        padding: EdgeInsets.only(left: 5.0),
                        height: 38.0,
                        child: TextField(
                          // enabled: enableTrade,
                          controller: priceController,
                          keyboardType: const TextInputType
                              .numberWithOptions(decimal: true),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                              13.0,
                              CustomTheme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              price = "0.0";
                              tradeAmount = "0.00";
                            });
                          },
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(bottom: 8.0),
                              hintText: "0.000",
                              prefixText: "Price",
                              prefixStyle: TextStyle(
                                color: CustomTheme.of(context)
                                    .dividerColor,
                              ),
                              hintStyle:
                              CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  CustomTheme.of(context).dividerColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              border: InputBorder.none),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                        height: 38.0,
                        width: 35.0,
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        // decoration: BoxDecoration(
                        //   color: CustomTheme.of(context).primaryColor,
                        // ),
                        child: Center(
                          child: Text(
                            "-",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                CustomTheme.of(context)
                                    .cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  InkWell(
                    onTap: () {

                    },
                    child: Container(
                        height: 38.0,
                        width: 35.0,
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Center(
                          child: Text(
                            "+",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0,),
            Container(
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(5.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      child: Container(
                        padding:
                        EdgeInsets.only(left: 5.0),
                        height: 38.0,
                        child: TextField(
                          controller: amountController,
                          keyboardType:
                          const TextInputType
                              .numberWithOptions(
                              decimal: true),
                          style: CustomWidget(
                              context: context)
                              .CustomSizedTextStyle(
                              13.0,
                              CustomTheme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .allow(RegExp(r'[0-9.]')),
                          ],
                          onChanged: (value) {
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.only(
                                  bottom: 8.0),
                              hintText: "0.00",
                              prefixText: "Qty",
                              prefixStyle: TextStyle(
                                color: CustomTheme.of(context)
                                    .dividerColor,
                              ),
                              hintStyle: CustomWidget(
                                  context: context)
                                  .CustomSizedTextStyle(
                                  12.0,
                                  CustomTheme.of(context).dividerColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              border: InputBorder.none),
                          textAlign: TextAlign.center,
                        ),
                      )),
                  InkWell(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Container(
                        height: 38.0,
                        width: 35.0,
                        padding:
                        const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: CustomTheme.of(context).canvasColor,
                        ),
                        child: Center(
                          child: Text(
                            "-",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 2.0,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {

                      });
                    },
                    child: Container(
                        height: 38.0,
                        width: 35.0,
                        padding:
                        const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Center(
                          child: Text(
                            "+",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                18.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0,),
            Container(
              child: Row(
                children: [
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          val = "25%";

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            0.0, 6.0, 0.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              5.0),
                          gradient: LinearGradient(
                            begin:
                            Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              val == "25%"
                                  ? CustomTheme.of(context)
                                  .primaryColorDark
                                  : CustomTheme.of(context)
                                  .canvasColor,
                              val == "25%"
                                  ? CustomTheme.of(context)
                                  .primaryColorLight
                                  : CustomTheme.of(context)
                                  .canvasColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "25%",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                CustomTheme.of(context)
                                    .cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          val = "50%";

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            0.0, 6.0, 0.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              5.0),
                          gradient: LinearGradient(
                            begin:
                            Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              val == "50%"
                                  ? CustomTheme.of(context)
                                  .primaryColorDark
                                  : CustomTheme.of(context)
                                  .canvasColor,
                              val == "50%"
                                  ? CustomTheme.of(context)
                                  .primaryColorLight
                                  : CustomTheme.of(context)
                                  .canvasColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "50%",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                CustomTheme.of(context)
                                    .cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          val = "75%";

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            0.0, 6.0, 0.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              5.0),
                          gradient: LinearGradient(
                            begin:
                            Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              val == "75%"
                                  ? CustomTheme.of(context)
                                  .primaryColorDark
                                  : CustomTheme.of(context)
                                  .canvasColor,
                              val == "75%"
                                  ? CustomTheme.of(context)
                                  .primaryColorLight
                                  : CustomTheme.of(context)
                                  .canvasColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "75%",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                CustomTheme.of(context)
                                    .cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          val = "100%";

                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        padding: EdgeInsets.fromLTRB(
                            0.0, 6.0, 0.0, 5.0),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              5.0),
                          gradient: LinearGradient(
                            begin:
                            Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: <Color>[
                              val == "100%"
                                  ? CustomTheme.of(context)
                                  .primaryColorDark
                                  : CustomTheme.of(context)
                                  .canvasColor,
                              val == "100%"
                                  ? CustomTheme.of(context)
                                  .primaryColorLight
                                  : CustomTheme.of(context)
                                  .canvasColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "100%",
                            style: CustomWidget(
                                context: context)
                                .CustomSizedTextStyle(
                                10.0,
                                CustomTheme.of(context)
                                    .cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                        ),
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            const SizedBox(height: 5.0,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      10.0,
                      CustomTheme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                Text(
                  "0 USDT",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      11.0,
                      CustomTheme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ],
            ),
            const SizedBox(height: 5.0,),
            buy ? InkWell(
              onTap: (){
                setState(() {

                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: buy ? BoxDecoration(
                  color:  CustomTheme.of(context).indicatorColor,
                  borderRadius: BorderRadius.circular(5.0),
                ) : BoxDecoration(),
                child: Text(
                  "Buy"+ " USDT",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      CustomTheme.of(context).focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                  textAlign: TextAlign.center,
                ),
              ),
            ) : InkWell(
              onTap: (){
                setState(() {

                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                decoration: sell ? BoxDecoration(
                  color:  CustomTheme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(5.0),
                ) : BoxDecoration(),
                child: Text(
                  "Sell" + " ETH",
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      CustomTheme.of(context).focusColor,
                      FontWeight.w500,
                      'FontRegular'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.4,
            //   child: Column(
            //     children: [
            //       Container(
            //         height: 40.0,
            //         padding: EdgeInsets.all(3.0),
            //         child: TabBar(
            //           controller: _tabController,
            //           dividerColor: CustomTheme.of(context).secondaryHeaderColor,
            //           labelStyle: CustomWidget(context: context)
            //               .CustomSizedTextStyle(
            //               12.0,
            //               Theme.of(context).cardColor,
            //               FontWeight.w600,
            //               'FontRegular'),
            //
            //           labelColor: CustomTheme.of(context).cardColor,
            //           //<-- selected text color
            //           unselectedLabelColor: Color(0xFFA7AFB7),
            //           // isScrollable: true,
            //           indicatorColor: CustomTheme.of(context).secondaryHeaderColor,
            //           indicator: BoxDecoration(
            //             // Creates border
            //             color:
            //             CustomTheme.of(context).secondaryHeaderColor,
            //           ),
            //           tabs: <Widget>[
            //             Tab(
            //               text: AppLocalizations.of(context)!.translate("loc_opnord").toString(),
            //             ),
            //             Tab(
            //               text: AppLocalizations.of(context)!.translate("loc_ordcbook").toString(),
            //             ),
            //             Tab(
            //               text: AppLocalizations.of(context)!.translate("loc_mkt_trade").toString(),
            //             )
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(
            //           margin: EdgeInsets.only(top: 10.0),
            //           color: CustomTheme.of(context).secondaryHeaderColor,
            //           child: TabBarView(
            //             controller: _tabController,
            //             children: <Widget>[
            //               // openOrdersUI(),
            //               // marketUI(),
            //               Container(
            //                 height: MediaQuery.of(context).size.height * 0.3,
            //                 decoration: BoxDecoration(
            //                   gradient: LinearGradient(
            //                     begin: Alignment.topCenter,
            //                     end: Alignment.bottomCenter,
            //                     colors: <Color>[
            //                       CustomTheme.of(context).secondaryHeaderColor,
            //                       CustomTheme.of(context).secondaryHeaderColor,
            //                       CustomTheme.of(context).secondaryHeaderColor,
            //                     ],
            //                     tileMode: TileMode.mirror,
            //                   ),
            //                 ),
            //                 child: Center(
            //                   child: Text(
            //                     AppLocalizations.of(context)!.translate("loc_com_soon").toString(),
            //                     style: CustomWidget(context: context)
            //                         .CustomSizedTextStyle(
            //                         16.0,
            //                         CustomTheme.of(context).cardColor,
            //                         FontWeight.w500,
            //                         'FontRegular'),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }


  Widget openOrdersUI() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // openOrders.length > 0 ?

            Container(
              decoration: BoxDecoration(
                  color: CustomTheme.of(context).shadowColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: 5,
                // itemCount: openOrders.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          key: PageStorageKey(index.toString()),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.translate("loc_pair").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        CustomTheme.of(context)
                                            .cardColor
                                            .withOpacity(0.5),
                                        FontWeight.w400,
                                        'FontRegular'),
                                  ),
                                  Text(
                                    // openOrders[index].pair.toString(),
                                    "ETH/USDT",
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        CustomTheme.of(context).cardColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_outlined,
                                color:  CustomTheme.of(context).cardColor,
                                size: 18.0,
                              )
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_date").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Container(
                                              child: Text(
                                                // openOrders[index].createdAt.toString(),
                                                "10-12-2024",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    CustomTheme.of(context)
                                                        .splashColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: MediaQuery.of(context).size.width *0.3,
                                            )
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_type").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Text(
                                              // openOrders[index].tradeType.toString(),
                                              "buy",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  14.0,
                                                  // openOrders[index]
                                                  //     .tradeType
                                                  //     .toString()
                                                  //     .toLowerCase() ==
                                                  //     "buy"
                                                  //     ?
                                                  CustomTheme.of(
                                                      context)
                                                      .indicatorColor,
                                                  // : CustomTheme.of(
                                                  // context)
                                                  // .hoverColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_ortype").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Text(
                                              // openOrders[index].orderType.toString(),
                                              "Spot",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_price").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Container(
                                              child: Text(
                                                // openOrders[index].price.toString(),
                                                "15.0002",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    CustomTheme.of(context)
                                                        .splashColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: MediaQuery.of(context).size.width *0.3,
                                            ),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_sell_trade_Qty").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Text(
                                              // openOrders[index].volume.toString(),
                                              "10.0",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_status").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Text(
                                              // openOrders[index].status.toString(),
                                              "Completed",
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor,
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)!.translate("loc_tot").toString(),
                                              style: CustomWidget(
                                                  context: context)
                                                  .CustomSizedTextStyle(
                                                  12.0,
                                                  CustomTheme.of(context)
                                                      .splashColor
                                                      .withOpacity(0.5),
                                                  FontWeight.w400,
                                                  'FontRegular'),
                                            ),
                                            Container(
                                              child: Text(
                                                // openOrders[index].value.toString(),
                                                "12.0000",
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    CustomTheme.of(context)
                                                        .splashColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              width: MediaQuery.of(context).size.width* 0.3,
                                            ),
                                          ],
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                        ),
                                        InkWell(
                                          child: Container(
                                            width: 80,
                                            padding: const EdgeInsets.only(
                                                top: 3.0, bottom: 3.0),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                AppLocalizations.of(context)!.translate("loc_cancel").toString(),
                                                style: CustomWidget(
                                                    context: context)
                                                    .CustomSizedTextStyle(
                                                    12.0,
                                                    CustomTheme.of(context)
                                                        .splashColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              // loading = true;
                                              // updatecancelOrder(
                                              //     openOrders[index]
                                              //         .id
                                              //         .toString());
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                          trailing: Container(
                            width: 1.0,
                            height: 10.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width,
                        color: CustomTheme.of(context).splashColor,
                      ),
                    ],
                  );
                },
              ),
            ),

            // //     :
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: <Color>[
            //         CustomTheme.of(context).secondaryHeaderColor,
            //         CustomTheme.of(context).secondaryHeaderColor,
            //         CustomTheme.of(context).secondaryHeaderColor,
            //       ],
            //       tileMode: TileMode.mirror,
            //     ),
            //   ),
            //   child: Center(
            //     child: Text(
            //       AppLocalizations.of(context)!.translate("loc_no_rec_found").toString(),
            //       style: CustomWidget(context: context).CustomSizedTextStyle(
            //           16.0,
            //           CustomTheme.of(context).cardColor,
            //           FontWeight.w500,
            //           'FontRegular'),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget marketOrder(){
    return Container(
      padding: EdgeInsets.only(left: 10.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // color: Colors.red,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price",
                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                11.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          const SizedBox(height: 2.0,),
                          Text(
                            "(USDT)",
                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                11.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Qty",
                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                11.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          ),
                          const SizedBox(height: 2.0,),
                          Text(
                            "(ETH)",
                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                11.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(
                      "3,536.53",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).hoverColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),
                    Flexible(child: Text(
                      "0.1414",
                      style: CustomWidget(context: context).CustomSizedTextStyle(
                          11.0,
                          CustomTheme.of(context).cardColor,
                          FontWeight.w500,
                          'FontRegular'),
                    )),

                  ],
                ),
              ],),
            ),
            const SizedBox(height: 5.0,),
            Text(
              "3,536.53",
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  CustomTheme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
            ),
            const SizedBox(height: 5.0,),
            Container(
              // color: Colors.blue,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text(
                        "3,536.53",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).indicatorColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),
                      Flexible(child: Text(
                        "0.1414",
                        style: CustomWidget(context: context).CustomSizedTextStyle(
                            11.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                      )),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
