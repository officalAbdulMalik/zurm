import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zurumi/common/colors.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/data/crypt_model/coin_list.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/new_socket_data.dart';
import 'package:zurumi/data/crypt_model/open_order_list_model.dart';
import 'package:zurumi/data/crypt_model/trade_all_pair_list_model.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../common/custom_widget.dart';

import '../common/theme/custom_theme.dart';
import '../data/api_utils.dart';

class Trade_Screen extends StatefulWidget {
  const Trade_Screen({Key? key}) : super(key: key);

  @override
  State<Trade_Screen> createState() => _Trade_ScreenState();
}

class _Trade_ScreenState extends State<Trade_Screen>
    with TickerProviderStateMixin {
  bool loading = false;
  ScrollController controller = ScrollController();
  bool buySell = true;
  bool loanErr = false;

  bool one = false;
  bool five = false;
  bool fifteen = false;
  bool oneday = false;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  List<UserWalletResult> coinList = [];
  List<BuySellData> buyData = [];
  List<BuySellData> buyReverseData = [];

  String balance = "0.000";

  String quoteID = "";
  List<BuySellData> sellData = [];
  List<BuySellData> sellReverseData = [];

  late TabController _tabController, tradeTabController, _tab;
  bool spotOption = false;
  bool marginOption = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool quote = false;
  Animation? _colorTween;
  AnimationController? _animationController;
  IOWebSocketChannel? channelOpenOrder, channelOpenOrder1;
  List<TradeAllPairList> tradePairList = [];
  List<TradeAllPairList> searchCoinList = [];
  TradeAllPairList? selectedPair;

  String livePrice = "0.0000";
  int decimalIndex = 2;
  final List<String> _decimal = [
    "0.01",
    "0.0001",
    "0.00000001",
  ];
  List arrData = [];
  List arrData1 = [];
  bool socketLoader = false;
  String selectedDecimal = "";
  String selectedMarginType = " ";
  APIUtils apiUtils = APIUtils();
  bool buyOption = true;
  bool sellOption = true;
  TextEditingController coinController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController amountController = TextEditingController();

  List<OpenOrders> openOrders = [];

  String escrow = "0.00";
  String val = "";
  String totalBalance = "0.00";

  String totalAmount = "0.00";
  String price = "0.00";
  String stopPrice = "0.00";
  String tradeAmount = "0.00";
  String takerFee = "0.00";
  String takerFeeValue = "0.00";
  final double _currentSliderValue = 0;
  bool enableTrade = false;

  String firstCoin = "";
  String secondCoin = "";
  String QuickfirstCoin = "";
  String QuicksecondCoin = "";

  bool favValue = false;
  String selectedIndex = "";
  String selectedAssetIndex = "";
  String leverageVal = "1";
  String tleverageVal = "1";
  String selectedTime = "";
  List<String> chartTime = [
    "Limit Order",
    "Market Order",
  ];

  String pair = "";

  bool loadingChart = false;

  late final WebViewController webcontroller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    one = true;

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 10000));
    _colorTween =
        ColorTween(begin: Colors.grey.withOpacity(0.5), end: Colors.transparent)
            .animate(_animationController!);

    selectedDecimal = _decimal.first;
    selectedTime = chartTime.first;
    _tabController = TabController(vsync: this, length: 3);
    _tab = TabController(vsync: this, length: 3);
    getCoinList();
    channelOpenOrder1 = IOWebSocketChannel.connect(
        Uri.parse("wss://stream.binance.com:9443/ws"),
        pingInterval: const Duration(seconds: 30));

    if (Platform.isAndroid) {
      webcontroller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://zurumi.com/trading-chart/BTC_USDT'));
    } else if (Platform.isIOS) {
      webcontroller = WebViewController()
        ..setBackgroundColor(const Color(0xFF242B48))
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {
              setState(() {
                loading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {},
          ),
        )
        ..loadRequest(Uri.parse('https://zurumi.com/trading-chart/BTC_USDT'));
    }
  }

  chartload() {
    if (Platform.isAndroid) {
      webcontroller.loadRequest(Uri.parse('https://zurumi.com/trading-chart/' +
          selectedPair!.baseAsset.toString().toUpperCase() +
          "_" +
          selectedPair!.marketAsset.toString().toUpperCase()));
    } else if (Platform.isIOS) {
      webcontroller.loadRequest(Uri.parse('https://zurumi.com/trading-chart/' +
          selectedPair!.baseAsset.toString().toUpperCase() +
          "_" +
          selectedPair!.marketAsset.toString().toUpperCase()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
          ),
          backgroundColor: CustomTheme.of(context).primaryColor,
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            color: CustomTheme.of(context).secondaryHeaderColor,
            child: Stack(
              children: [
                Container(
                  child: spot(),
                ),
                loading
                    ? CustomWidget(context: context)
                        .loadingIndicator(CustomTheme.of(context).primaryColor)
                    : Container()
              ],
            ),
          ),
        ));
  }

  Widget spot() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            livePrice,
            style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
          ),
          InkWell(
              onTap: () {
                showSheeetPair(context);
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/swap.svg'),
                  Text(
                    pair,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        14.0,
                        Theme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ],
              )),
          const SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.32,
            child: InteractiveViewer(
                minScale: 0.5, // Minimum zoom level
                maxScale: 3.0, // Maximum zoom level
                child: WebViewWidget(controller: webcontroller)),
          ),

          // Container(
          //   child: Image.asset("assets/icons/trade.png", height: 150.0, width: MediaQuery.of(context).size.width,),
          // ),
          const SizedBox(
            height: 10.0,
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Flexible(
          //         child: InkWell(
          //           onTap: () {
          //             setState(() {
          //               one = true;
          //               five = false;
          //               fifteen = false;
          //               oneday = false;
          //             });
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             width: MediaQuery.of(context).size.width,
          //             padding: EdgeInsets.only(
          //                 left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          //             decoration: one
          //                 ? BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5.0),
          //                     color: Theme.of(context).shadowColor,
          //                   )
          //                 : BoxDecoration(),
          //             child: Text(
          //               "1m",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                       12.0,
          //                       one
          //                           ? Theme.of(context).primaryColor
          //                           : Theme.of(context).cardColor,
          //                       FontWeight.w400,
          //                       'FontRegular'),
          //             ),
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //       Flexible(
          //         child: InkWell(
          //           onTap: () {
          //             setState(() {
          //               one = false;
          //               five = true;
          //               fifteen = false;
          //               oneday = false;
          //             });
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             width: MediaQuery.of(context).size.width,
          //             padding: EdgeInsets.only(
          //                 left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          //             decoration: five
          //                 ? BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5.0),
          //                     color: Theme.of(context).shadowColor,
          //                   )
          //                 : BoxDecoration(),
          //             child: Text(
          //               "5m",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                       12.0,
          //                       five
          //                           ? Theme.of(context).primaryColor
          //                           : Theme.of(context).cardColor,
          //                       FontWeight.w400,
          //                       'FontRegular'),
          //             ),
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //       Flexible(
          //         child: InkWell(
          //           onTap: () {
          //             setState(() {
          //               one = false;
          //               five = false;
          //               fifteen = true;
          //               oneday = false;
          //             });
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             width: MediaQuery.of(context).size.width,
          //             padding: EdgeInsets.only(
          //                 left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          //             decoration: fifteen
          //                 ? BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5.0),
          //                     color: Theme.of(context).shadowColor,
          //                   )
          //                 : BoxDecoration(),
          //             child: Text(
          //               "15m",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                       12.0,
          //                       fifteen
          //                           ? Theme.of(context).primaryColor
          //                           : Theme.of(context).cardColor,
          //                       FontWeight.w400,
          //                       'FontRegular'),
          //             ),
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //       Flexible(
          //         child: InkWell(
          //           onTap: () {
          //             setState(() {
          //               one = false;
          //               five = false;
          //               fifteen = false;
          //               oneday = true;
          //             });
          //           },
          //           child: Container(
          //             alignment: Alignment.center,
          //             width: MediaQuery.of(context).size.width,
          //             padding: EdgeInsets.only(
          //                 left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          //             decoration: oneday
          //                 ? BoxDecoration(
          //                     borderRadius: BorderRadius.circular(5.0),
          //                     color: Theme.of(context).shadowColor,
          //                   )
          //                 : BoxDecoration(),
          //             child: Text(
          //               "1d",
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                       12.0,
          //                       oneday
          //                           ? Theme.of(context).primaryColor
          //                           : Theme.of(context).cardColor,
          //                       FontWeight.w400,
          //                       'FontRegular'),
          //             ),
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //       Flexible(
          //         child: InkWell(
          //           onTap: () {},
          //           child: Container(
          //             alignment: Alignment.center,
          //             width: MediaQuery.of(context).size.width,
          //             padding: EdgeInsets.only(
          //                 left: 8.0, right: 8.0, top: 5.0, bottom: 5.0),
          //             decoration: BoxDecoration(),
          //             child: Text(
          //               AppLocalizations.of(context)!.translate("loc_more"),
          //               style: CustomWidget(context: context)
          //                   .CustomSizedTextStyle(
          //                       12.0,
          //                       Theme.of(context).cardColor,
          //                       FontWeight.w400,
          //                       'FontRegular'),
          //             ),
          //           ),
          //         ),
          //         flex: 1,
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          Row(
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      buySell = true;
                      enableTrade = true;
                      val = "0%";
                      showSheeet();
                      for (int m = 0; m < coinList.length; m++) {
                        if (selectedPair!.marketAsset
                                .toString()
                                .toLowerCase() ==
                            coinList[m].symbol.toString().toLowerCase()) {
                          balance = coinList[m].balance.toString();
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("loc_sell_trade_txt5")
                          .toString(),
                      style: AppTextStyles.poppinsRegular(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      buySell = false;
                      enableTrade = true;
                      val = "0%";
                      showSheeet();
                      for (int m = 0; m < coinList.length; m++) {
                        if (selectedPair!.baseAsset.toString().toLowerCase() ==
                            coinList[m].symbol.toString().toLowerCase()) {
                          balance = coinList[m].balance.toString();
                        }
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("loc_sell_trade_txt6")
                          .toString(),
                      style: AppTextStyles.poppinsRegular(
                        color: Colors.black,
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Container(
                  height: 40.0,
                  padding: const EdgeInsets.all(3.0),
                  child: TabBar(
                    controller: _tabController,
                    dividerColor: Theme.of(context).secondaryHeaderColor,
                    labelStyle: CustomWidget(context: context)
                        .CustomSizedTextStyle(12.0, Theme.of(context).cardColor,
                            FontWeight.w600, 'FontRegular'),

                    labelColor: CustomTheme.of(context).cardColor,
                    //<-- selected text color
                    unselectedLabelColor: const Color(0xFFA7AFB7),
                    // isScrollable: true,
                    indicatorColor:
                        CustomTheme.of(context).secondaryHeaderColor,
                    indicator: BoxDecoration(
                      // Creates border
                      color: CustomTheme.of(context).secondaryHeaderColor,
                    ),
                    tabs: <Widget>[
                      Tab(
                        text: AppLocalizations.of(context)!
                            .translate("loc_opnord")
                            .toString(),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!
                            .translate("loc_ordcbook")
                            .toString(),
                      ),
                      Tab(
                        text: AppLocalizations.of(context)!
                            .translate("loc_mkt_trade")
                            .toString(),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    color: CustomTheme.of(context).secondaryHeaderColor,
                    child: TabBarView(
                      controller: _tabController,
                      children: <Widget>[
                        openOrdersUIS(),
                        marketWidget(),
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
                              AppLocalizations.of(context)!
                                  .translate("loc_com_soon")
                                  .toString(),
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
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  Widget openOrdersUIS() {
    return Column(
      children: [
        openOrders.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorDark,
                    borderRadius: BorderRadius.circular(10.0)),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: openOrders.length,
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
                                      AppLocalizations.of(context)!
                                          .translate("loc_pair")
                                          .toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              12.0,
                                              Theme.of(context)
                                                  .splashColor
                                                  .withOpacity(0.5),
                                              FontWeight.w400,
                                              'FontRegular'),
                                    ),
                                    Text(
                                      openOrders[index].pair.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              Theme.of(context).splashColor,
                                              FontWeight.w400,
                                              'FontRegular'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: AppColors.whiteColor,
                                  size: 18.0,
                                )
                              ],
                            ),
                            trailing: const SizedBox(
                              width: 1.0,
                              height: 10.0,
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_date")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  openOrders[index]
                                                      .createdAt
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_type")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .tradeType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        14.0,
                                                        openOrders[index]
                                                                    .tradeType
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                "buy"
                                                            ? CustomTheme.of(
                                                                    context)
                                                                .indicatorColor
                                                            : CustomTheme.of(
                                                                    context)
                                                                .hoverColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_ortype")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .orderType
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_price")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  openOrders[index]
                                                      .price
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        "loc_sell_trade_Qty")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .volume
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_status")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              Text(
                                                openOrders[index]
                                                    .status
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor,
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_tot")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .splashColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  openOrders[index]
                                                      .value
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
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
                                                  AppLocalizations.of(context)!
                                                      .translate("loc_cancel")
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .splashColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                loading = true;
                                                updatecancelOrder(
                                                    openOrders[index]
                                                        .id
                                                        .toString());
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
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          height: 1.0,
                          width: MediaQuery.of(context).size.width,
                          color: Theme.of(context).splashColor,
                        ),
                      ],
                    );
                  },
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height * 0.2,
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
                    AppLocalizations.of(context)!
                        .translate("loc_no_rec_found")
                        .toString(),
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        16.0,
                        CustomTheme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                ),
              ),
      ],
    );
  }

  Widget marketWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1.0,
          color: const Color(0xFF1B232A).withOpacity(0.56),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("loc_bids").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.translate("loc_ask").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    12.0,
                    Theme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          height: 1.0,
          color: const Color(0xFF1B232A).withOpacity(0.56),
        ),
        socketLoader
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.38,
                child: CustomWidget(context: context)
                    .loadingIndicator(AppColors.whiteColor),
              )
            : buyData.isNotEmpty && sellData.isNotEmpty
                ? Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: buyOption
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                child: buyData.isNotEmpty
                                    ? ListView.builder(
                                        controller: controller,
                                        itemCount: buyData.length,
                                        itemBuilder:
                                            ((BuildContext context, int index) {
                                          return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  buySell = false;
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    double.parse(buyData[index]
                                                            .price
                                                            .toString())
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .indicatorColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                  Text(
                                                    double.parse(buyData[index]
                                                            .quantity
                                                            .toString()
                                                            .replaceAll(
                                                                ",", ""))
                                                        .toStringAsFixed(
                                                            decimalIndex),
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            10.0,
                                                            Theme.of(context)
                                                                .cardColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                  ),
                                                ],
                                              ));
                                        }))
                                    : Container(
                                        height: !sellOption
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.20,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                // Add one stop for each color
                                                // Values should increase from 0.0 to 1.0
                                                stops: const [
                                              0.1,
                                              0.5,
                                              0.9,
                                            ],
                                                colors: [
                                              CustomTheme.of(context)
                                                  .primaryColor,
                                              CustomTheme.of(context)
                                                  .primaryColorDark,
                                              Theme.of(context)
                                                  .dialogBackgroundColor,
                                            ])),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_data_found")
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: "FontRegular",
                                              color: CustomTheme.of(context)
                                                  .splashColor,
                                            ),
                                          ),
                                        ),
                                      ))
                            : Container(),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        width: 1.0,
                        height: MediaQuery.of(context).size.height * 0.2,
                        color: const Color(0xFF1B232A).withOpacity(0.56),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Flexible(
                        flex: 1,
                        child: sellOption
                            ? SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                                child: sellData.isNotEmpty
                                    ? ListView.builder(
                                        controller: controller,
                                        itemCount: sellData.length,
                                        reverse: false,
                                        itemBuilder:
                                            ((BuildContext context, int index) {
                                          return Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    buySell = true;
                                                  });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      double.parse(
                                                              sellData[index]
                                                                  .price
                                                                  .toString())
                                                          .toStringAsFixed(
                                                              decimalIndex),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              10.0,
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                    Text(
                                                      double.parse(
                                                              sellData[index]
                                                                  .quantity
                                                                  .toString()
                                                                  .replaceAll(
                                                                      ",", ""))
                                                          .toStringAsFixed(
                                                              decimalIndex),
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              10.0,
                                                              Theme.of(context)
                                                                  .cardColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        }))
                                    : Container(
                                        height: !buyOption
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.38
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.17,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                // Add one stop for each color
                                                // Values should increase from 0.0 to 1.0
                                                stops: const [
                                              0.1,
                                              0.5,
                                              0.9,
                                            ],
                                                colors: [
                                              CustomTheme.of(context)
                                                  .primaryColor,
                                              CustomTheme.of(context)
                                                  .primaryColorDark,
                                              Theme.of(context)
                                                  .dialogBackgroundColor,
                                            ])),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_data_found")
                                                .toString(),
                                            style: TextStyle(
                                              fontFamily: "FontRegular",
                                              color: CustomTheme.of(context)
                                                  .splashColor,
                                            ),
                                          ),
                                        ),
                                      ),
                              )
                            : Container(
                                color: Colors.white,
                              ),
                      ),
                    ],
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // Add one stop for each color
                            // Values should increase from 0.0 to 1.0
                            stops: const [
                          0.1,
                          0.5,
                          0.9,
                        ],
                            colors: [
                          CustomTheme.of(context).secondaryHeaderColor,
                          CustomTheme.of(context).secondaryHeaderColor,
                          Theme.of(context).secondaryHeaderColor,
                        ])),
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_data_found")
                            .toString(),
                        style: TextStyle(
                          fontFamily: "FontRegular",
                          color: CustomTheme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
        const SizedBox(
          height: 12.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35.0,
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Center(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    canvasColor: CustomTheme.of(context).canvasColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      items: _decimal
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDecimal = value.toString();
                          for (int m = 0; m < _decimal.length; m++) {
                            if (value == _decimal[m]) {
                              if (m == 0) {
                                decimalIndex = 2;
                              } else if (m == 1) {
                                decimalIndex = 4;
                              } else {
                                decimalIndex = 8;
                              }
                            }
                          }
                        });
                      },
                      isExpanded: false,
                      value: selectedDecimal,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: CustomTheme.of(context).cardColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  showSuccessAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext contexts) {
          return Align(
            alignment: const Alignment(0, 1),
            child: Material(
              color: CustomTheme.of(context).primaryColorDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_all")
                            .toString()
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = true;
                          sellOption = false;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_buy")
                            .toString()
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Navigator.pop(contexts);
                          buyOption = false;
                          sellOption = true;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("loc_sell")
                            .toString()
                            .toUpperCase(),
                        style: CustomWidget(context: context).CustomTextStyle(
                            Theme.of(context).splashColor,
                            FontWeight.w500,
                            'FontRegular'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  void showSheeet() {
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            width: MediaQuery.of(context).size.width,

            // You can wrap this Column with Padding of 8.0 for better design
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          top: 0.0, right: 15.0, left: 15.0, bottom: 20.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            topLeft: Radius.circular(15.0),
                          )),
                      margin: const EdgeInsets.only(top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.translate("loc_avle")}: ",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              11.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      balance,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              11.0,
                                              Theme.of(context).primaryColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      buySell
                                          ? selectedPair!.marketAsset.toString()
                                          : selectedPair!.baseAsset.toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              11.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Icon(
                                      Icons.add_circle,
                                      size: 22.0,
                                      color: Theme.of(context).shadowColor,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 6.0, bottom: 6.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context)
                                            .primaryColorDark,
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                enableTrade = true;
                                                priceController.clear();
                                                amountController.clear();
                                                val = "0%";
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              decoration: enableTrade
                                                  ? BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    )
                                                  : const BoxDecoration(),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate("loc_limit")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        enableTrade
                                                            ? Theme.of(context)
                                                                .cardColor
                                                            : Theme.of(context)
                                                                .primaryColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                enableTrade = false;
                                                priceController.clear();
                                                amountController.clear();
                                                val = "0%";
                                                priceController.text =
                                                    livePrice;
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              decoration: enableTrade
                                                  ? const BoxDecoration()
                                                  : BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25.0),
                                                      color: Theme.of(context)
                                                          .canvasColor,
                                                    ),
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        "loc_side_market")
                                                    .toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        enableTrade
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Theme.of(context)
                                                                .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 5.0, 5.0, 5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context)
                                            .primaryColorDark,
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
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
                                            const EdgeInsets.only(left: 5.0),
                                        height: 40.0,
                                        child: TextField(
                                          enabled: enableTrade,
                                          controller: priceController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  13.0,
                                                  Theme.of(context)
                                                      .primaryColor,
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

                                              if (priceController
                                                  .text.isNotEmpty) {
                                                double amount = double.parse(
                                                    priceController.text);
                                                price = priceController.text;

                                                if (priceController
                                                    .text.isNotEmpty) {
                                                  if (!buySell) {
                                                    takerFee = ((amount *
                                                                double.parse(
                                                                    priceController
                                                                        .text
                                                                        .toString()) *
                                                                double.parse(
                                                                    takerFeeValue
                                                                        .toString())) /
                                                            100)
                                                        .toStringAsFixed(4);

                                                    totalAmount = (double.parse(
                                                                amountController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                priceController
                                                                    .text
                                                                    .toString()))
                                                        .toStringAsFixed(4);
                                                  } else {
                                                    totalAmount = (double.parse(
                                                                amountController
                                                                    .text
                                                                    .toString()) *
                                                            double.parse(
                                                                priceController
                                                                    .text
                                                                    .toString()))
                                                        .toStringAsFixed(4);
                                                  }
                                                }
                                              } else {
                                                tradeAmount = "0.00";
                                                totalAmount = "0.00";
                                              }
                                            });
                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 8.0),
                                              hintText: "0.000",
                                              prefixText: "Price",
                                              hintStyle:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          12.0,
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                              border: InputBorder.none),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                      InkWell(
                                        onTap: () {
                                          if (!enableTrade) {
                                          } else {
                                            setState(() {
                                              if (priceController
                                                  .text.isNotEmpty) {
                                                double amount = double.parse(
                                                    priceController.text);
                                                if (amount > 0) {
                                                  amount = amount - 0.01;
                                                  priceController.text =
                                                      amount.toStringAsFixed(2);
                                                  tradeAmount =
                                                      priceController.text;

                                                  if (priceController
                                                      .text.isNotEmpty) {
                                                    if (!buySell) {
                                                      takerFee = ((amount *
                                                                  double.parse(
                                                                      priceController
                                                                          .text
                                                                          .toString()) *
                                                                  double.parse(
                                                                      takerFeeValue
                                                                          .toString())) /
                                                              100)
                                                          .toStringAsFixed(4);

                                                      totalAmount = (double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString()) *
                                                              double.parse(
                                                                  priceController
                                                                      .text
                                                                      .toString()))
                                                          .toStringAsFixed(4);
                                                    } else {
                                                      totalAmount = (double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString()) *
                                                              double.parse(
                                                                  priceController
                                                                      .text
                                                                      .toString()))
                                                          .toStringAsFixed(4);
                                                    }
                                                  }
                                                }
                                              } else {
                                                priceController.text = "0.01";
                                                tradeAmount =
                                                    amountController.text;
                                                totalAmount = "0.000";
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                            height: 40.0,
                                            width: 35.0,
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: !enableTrade
                                                  ? Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.1)
                                                  : CustomTheme.of(context)
                                                      .canvasColor,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "-",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        20.0,
                                                        !enableTrade
                                                            ? Theme.of(context)
                                                                .cardColor
                                                            : Theme.of(context)
                                                                .primaryColor,
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
                                          if (!enableTrade) {
                                          } else {
                                            setState(() {
                                              if (priceController
                                                  .text.isNotEmpty) {
                                                double amount = double.parse(
                                                    priceController.text);
                                                if (amount >= 0) {
                                                  amount = amount + 0.01;
                                                  priceController.text =
                                                      amount.toStringAsFixed(2);
                                                  tradeAmount =
                                                      priceController.text;

                                                  if (priceController
                                                      .text.isNotEmpty) {
                                                    if (!buySell) {
                                                      takerFee = ((amount *
                                                                  double.parse(
                                                                      priceController
                                                                          .text
                                                                          .toString()) *
                                                                  double.parse(
                                                                      takerFeeValue
                                                                          .toString())) /
                                                              100)
                                                          .toStringAsFixed(4);

                                                      totalAmount = (double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString()) *
                                                              double.parse(
                                                                  priceController
                                                                      .text
                                                                      .toString()))
                                                          .toStringAsFixed(4);
                                                    } else {
                                                      totalAmount = (double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString()) *
                                                              double.parse(
                                                                  priceController
                                                                      .text
                                                                      .toString()))
                                                          .toStringAsFixed(4);
                                                    }
                                                  }
                                                }
                                              } else {
                                                priceController.text = "0.01";
                                                tradeAmount =
                                                    amountController.text;
                                                totalAmount = "0.000";
                                              }
                                            });
                                          }
                                        },
                                        child: Container(
                                            height: 40.0,
                                            width: 35.0,
                                            padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: !enableTrade
                                                  ? Theme.of(context)
                                                      .cardColor
                                                      .withOpacity(0.1)
                                                  : CustomTheme.of(context)
                                                      .canvasColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topRight: Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(5.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "+",
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomSizedTextStyle(
                                                        20.0,
                                                        !enableTrade
                                                            ? Theme.of(context)
                                                                .primaryColor
                                                            : Theme.of(context)
                                                                .cardColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10.0),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).shadowColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 5.0, 5.0, 5.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          // color: Theme.of(context).cardColor,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                child: Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              height: 40.0,
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
                                                        Theme.of(context)
                                                            .primaryColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(r'[0-9.]')),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    price = "0.0";
                                                    // price = value.toString();
                                                    totalAmount = "0.00";

                                                    if (enableTrade) {
                                                      if (amountController
                                                          .text.isNotEmpty) {
                                                        totalAmount = (double.parse(
                                                                    amountController
                                                                        .text
                                                                        .toString()) *
                                                                double.parse(
                                                                    livePrice))
                                                            .toStringAsFixed(4);
                                                      }
                                                    } else {
                                                      if (amountController
                                                          .text.isNotEmpty) {
                                                        double amount =
                                                            double.parse(
                                                                amountController
                                                                    .text);
                                                        if (amount >= 0) {
                                                          tradeAmount =
                                                              amountController
                                                                  .text;

                                                          if (priceController
                                                              .text
                                                              .isNotEmpty) {
                                                            if (!buySell) {
                                                              takerFee = ((amount *
                                                                          double.parse(priceController
                                                                              .text
                                                                              .toString()) *
                                                                          double.parse(takerFeeValue
                                                                              .toString())) /
                                                                      100)
                                                                  .toStringAsFixed(
                                                                      4);

                                                              totalAmount = (double.parse(amountController
                                                                          .text
                                                                          .toString()) *
                                                                      double.parse(priceController
                                                                          .text
                                                                          .toString()))
                                                                  .toStringAsFixed(
                                                                      4);
                                                            } else {
                                                              totalAmount = (double.parse(amountController
                                                                          .text
                                                                          .toString()) *
                                                                      double.parse(priceController
                                                                          .text
                                                                          .toString()))
                                                                  .toStringAsFixed(
                                                                      4);
                                                            }
                                                          }
                                                        }
                                                      } else {
                                                        tradeAmount =
                                                            amountController
                                                                .text;
                                                        totalAmount = "0.000";
                                                      }
                                                    }
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    hintText: "0.00",
                                                    prefixText: AppLocalizations
                                                            .of(context)!
                                                        .translate(
                                                            "loc_sell_trade_txt8"),
                                                    prefixStyle: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    hintStyle: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Theme.of(context)
                                                                .primaryColor,
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                    border: InputBorder.none),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  val = "0%";
                                                  tradeAmount = "0.0";
                                                  totalAmount = "0.0";
                                                  if (enableTrade) {
                                                    if (amountController
                                                        .text.isNotEmpty) {
                                                      double amount =
                                                          double.parse(
                                                              amountController
                                                                  .text);
                                                      if (amount > 0) {
                                                        amount = amount - 0.01;
                                                        amountController.text =
                                                            amount
                                                                .toStringAsFixed(
                                                                    2);
                                                        tradeAmount =
                                                            amountController
                                                                .text;
                                                        totalAmount = (double.parse(
                                                                    amountController
                                                                        .text
                                                                        .toString()) *
                                                                double.parse(
                                                                    livePrice))
                                                            .toStringAsFixed(4);
                                                      }
                                                    } else {
                                                      amountController.text =
                                                          "0.01";
                                                      tradeAmount =
                                                          amountController.text;
                                                      totalAmount = "0.000";
                                                    }
                                                  } else {
                                                    if (amountController
                                                        .text.isNotEmpty) {
                                                      double amount =
                                                          double.parse(
                                                              amountController
                                                                  .text);
                                                      if (amount > 0) {
                                                        amount = amount - 0.01;
                                                        amountController.text =
                                                            amount
                                                                .toStringAsFixed(
                                                                    2);
                                                        tradeAmount =
                                                            amountController
                                                                .text;

                                                        if (priceController
                                                            .text.isNotEmpty) {
                                                          if (!buySell) {
                                                            takerFee = ((amount *
                                                                        double.parse(priceController
                                                                            .text
                                                                            .toString()) *
                                                                        double.parse(takerFeeValue
                                                                            .toString())) /
                                                                    100)
                                                                .toStringAsFixed(
                                                                    4);

                                                            totalAmount = (double.parse(
                                                                        amountController
                                                                            .text
                                                                            .toString()) *
                                                                    double.parse(
                                                                        priceController
                                                                            .text
                                                                            .toString()))
                                                                .toStringAsFixed(
                                                                    4);
                                                          } else {
                                                            totalAmount = (double.parse(
                                                                        amountController
                                                                            .text
                                                                            .toString()) *
                                                                    double.parse(
                                                                        priceController
                                                                            .text
                                                                            .toString()))
                                                                .toStringAsFixed(
                                                                    4);
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      amountController.text =
                                                          "0.01";
                                                      tradeAmount =
                                                          amountController.text;
                                                      totalAmount = "0.000";
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                  height: 40.0,
                                                  width: 35.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                       CustomTheme.of(context)
                                                            .canvasColor,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(5.0),
                                                      bottomLeft:
                                                          Radius.circular(5.0),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "-",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              20.0,
                                                              Theme.of(context)
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
                                                setState(() {
                                                  val = "0%";
                                                  totalAmount = "0.000";
                                                  if (enableTrade) {
                                                    if (amountController
                                                        .text.isNotEmpty) {
                                                      double amount =
                                                          double.parse(
                                                              amountController
                                                                  .text);
                                                      if (amount > 0) {
                                                        amount = amount + 0.01;
                                                        amountController.text =
                                                            amount
                                                                .toStringAsFixed(
                                                                    2);
                                                        tradeAmount =
                                                            amountController
                                                                .text;
                                                        totalAmount = (double.parse(
                                                                    amountController
                                                                        .text
                                                                        .toString()) *
                                                                double.parse(
                                                                    livePrice))
                                                            .toStringAsFixed(4);
                                                      }
                                                    } else {
                                                      amountController.text =
                                                          "0.01";
                                                      tradeAmount =
                                                          amountController.text;
                                                      totalAmount = "0.000";
                                                    }
                                                  } else {
                                                    if (amountController
                                                        .text.isNotEmpty) {
                                                      double amount =
                                                          double.parse(
                                                              amountController
                                                                  .text);
                                                      if (amount >= 0) {
                                                        amount = amount + 0.01;
                                                        amountController.text =
                                                            amount
                                                                .toStringAsFixed(
                                                                    2);
                                                        tradeAmount =
                                                            amountController
                                                                .text;

                                                        if (priceController
                                                            .text.isNotEmpty) {
                                                          if (!buySell) {
                                                            takerFee = ((amount *
                                                                        double.parse(priceController
                                                                            .text
                                                                            .toString()) *
                                                                        double.parse(takerFeeValue
                                                                            .toString())) /
                                                                    100)
                                                                .toStringAsFixed(
                                                                    4);

                                                            totalAmount = (double.parse(
                                                                        amountController
                                                                            .text
                                                                            .toString()) *
                                                                    double.parse(
                                                                        priceController
                                                                            .text
                                                                            .toString()))
                                                                .toStringAsFixed(
                                                                    4);
                                                          } else {
                                                            totalAmount = (double.parse(
                                                                        amountController
                                                                            .text
                                                                            .toString()) *
                                                                    double.parse(
                                                                        priceController
                                                                            .text
                                                                            .toString()))
                                                                .toStringAsFixed(
                                                                    4);
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      amountController.text =
                                                          "0.01";
                                                      tradeAmount =
                                                          amountController.text;
                                                      totalAmount = "0.000";
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                  height: 40.0,
                                                  width: 35.0,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                    right: 10.0,
                                                  ),
                                                  decoration:
                                                       BoxDecoration(
                                                    color:CustomTheme.of(context)
                                                            .canvasColor,
                                                    // borderRadius: BorderRadius.circular(2),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "+",
                                                      style: CustomWidget(
                                                              context: context)
                                                          .CustomSizedTextStyle(
                                                              20.0,
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        height: 2.0,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF1B232A)),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5.0),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    val = "25%";

                                                    if (double.parse(balance) >
                                                        0) {
                                                      double perce = ((double.parse(
                                                                      balance) *
                                                                  25) /
                                                              double.parse(
                                                                  livePrice)) /
                                                          100;
                                                      priceController.text =
                                                          livePrice;

                                                      amountController
                                                          .text = double.parse(
                                                              perce.toString())
                                                          .toStringAsFixed(4);
                                                      double a = double.parse(perce
                                                          .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                                                      double b = double.parse(
                                                          livePrice);
                                                      totalAmount =
                                                          double.parse((a * b)
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  4);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 10.0, 0.0, 10.0),
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
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                        val == "25%"
                                                            ? Theme.of(context)
                                                                .primaryColorLight
                                                            : Theme.of(context)
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
                                                              Theme.of(context)
                                                                  .cardColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    val = "50%";

                                                    if (double.parse(balance) >
                                                        0) {
                                                      double perce = ((double.parse(
                                                                      balance) *
                                                                  50) /
                                                              double.parse(
                                                                  livePrice)) /
                                                          100;

                                                      priceController.text =
                                                          livePrice;
                                                      amountController
                                                          .text = double.parse(
                                                              perce.toString())
                                                          .toStringAsFixed(4);
                                                      double a = double.parse(perce
                                                          .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                                                      double b = double.parse(
                                                          livePrice);
                                                      totalAmount =
                                                          double.parse((a * b)
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  4);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 10.0, 0.0, 10.0),
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
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                        val == "50%"
                                                            ? Theme.of(context)
                                                                .primaryColorLight
                                                            : Theme.of(context)
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
                                                              Theme.of(context)
                                                                  .cardColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    val = "75%";
                                                    if (double.parse(balance) >
                                                        0) {
                                                      double perce = ((double.parse(
                                                                      balance) *
                                                                  75) /
                                                              double.parse(
                                                                  livePrice)) /
                                                          100;
                                                      priceController.text =
                                                          livePrice;
                                                      amountController
                                                          .text = double.parse(
                                                              perce.toString())
                                                          .toStringAsFixed(4);
                                                      double a = double.parse(perce
                                                          .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                                                      double b = double.parse(
                                                          livePrice);
                                                      totalAmount =
                                                          double.parse((a * b)
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  4);
                                                    } else {
                                                      amountController.text =
                                                          "0.00";
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 10.0, 0.0, 10.0),
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
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                        val == "75%"
                                                            ? Theme.of(context)
                                                                .primaryColorLight
                                                            : Theme.of(context)
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
                                                              Theme.of(context)
                                                                  .cardColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5.0,
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    val = "100%";
                                                    if (double.parse(balance) >
                                                        0) {
                                                      double perce = ((double.parse(
                                                                      balance) *
                                                                  100) /
                                                              double.parse(
                                                                  livePrice)) /
                                                          100;

                                                      priceController.text =
                                                          livePrice;
                                                      amountController
                                                          .text = double.parse(
                                                              perce.toString())
                                                          .toStringAsFixed(4);
                                                      double a = double.parse(perce
                                                          .toString()); // this is the value in my first text field (This is the percentage rate i intend to use)
                                                      double b = double.parse(
                                                          livePrice);
                                                      totalAmount =
                                                          double.parse((a * b)
                                                                  .toString())
                                                              .toStringAsFixed(
                                                                  4);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0.0, 10.0, 0.0, 10.0),
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
                                                            ? Theme.of(context)
                                                                .primaryColorDark
                                                            : Theme.of(context)
                                                                .canvasColor,
                                                        val == "100%"
                                                            ? Theme.of(context)
                                                                .primaryColorLight
                                                            : Theme.of(context)
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
                                                              Theme.of(context)
                                                                  .cardColor,
                                                              FontWeight.w500,
                                                              'FontRegular'),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.translate("loc_tot")} : ",
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              11.0,
                                              Theme.of(context).shadowColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    Text(
                                      totalAmount,
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              11.0,
                                              Theme.of(context).primaryColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();

                                    setState(() {
                                      if (priceController.text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog("Trade",
                                                "Please Enter Price", "error");
                                      } else if (amountController
                                          .text.isEmpty) {
                                        CustomWidget(context: context)
                                            .showSuccessAlertDialog("Trade",
                                                "Please Enter Amount", "error");
                                      } else {
                                        loading = true;
                                        doPostTrade();
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 12.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: buySell
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context)
                                              .dialogBackgroundColor,
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Text(
                                      buySell
                                          ? AppLocalizations.of(context)!
                                              .translate("loc_sell_trade_txt5")
                                              .toString()
                                          : AppLocalizations.of(context)!
                                              .translate("loc_sell_trade_txt6")
                                              .toString(),
                                      style: AppTextStyles.poppinsRegular(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 00.0, bottom: 30.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              priceController.text = price;
                              amountController.clear();
                              buySell = true;
                              Navigator.of(context).pop();
                            });
                          },
                          child: Container(
                            height: 45.0,
                            width: 45.0,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/icons/down_arrow.svg',
                                color: Colors.black,
                              ),
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

  getCoinList() {
    apiUtils.getTradePair().then((TradeAllPairListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;

          tradePairList = [];

          tradePairList = loginData.result!;
          searchCoinList = loginData.result!;
          selectedPair = tradePairList.first;
          pair = selectedPair!.tradePair.toString().toUpperCase();
          arrData.add('${selectedPair!.symbol.toString().toLowerCase()}@depth');

          geBalance();
          getOpenOrder();
          arrData1
              .add('${selectedPair!.symbol.toString().toLowerCase()}@ticker');
          var messageJSON = {
            "method": "SUBSCRIBE",
            "params": arrData,
            "id": 1,
          };

          channelOpenOrder = IOWebSocketChannel.connect(
              Uri.parse(
                  "wss://stream.binance.com:9443/ws/${selectedPair!.symbol.toString().toUpperCase()}@depth@1000ms"),
              pingInterval: const Duration(seconds: 30));

          channelOpenOrder!.sink.add(json.encode(messageJSON));

          socketDataOrder();

          var messageJSON1 = {
            "method": "SUBSCRIBE",
            "params": arrData1,
            "id": 1,
          };

          channelOpenOrder1 = IOWebSocketChannel.connect(
              Uri.parse("wss://stream.binance.com:9443/ws"),
              pingInterval: const Duration(seconds: 30));

          channelOpenOrder1!.sink.add(json.encode(messageJSON1));

          socketData();
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

  socketData() {
    channelOpenOrder1!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              SocketDataModel ss = SocketDataModel.fromJson(decode);
              if (selectedPair!.symbol.toString().toLowerCase() ==
                  ss.s.toString().toLowerCase()) {
                if (selectedPair!.symbol.toString().toLowerCase() ==
                    "setusdt") {
                  livePrice = selectedPair!.currentPrice.toString();
                } else {
                  livePrice = ss.socketDataModelC.toString();
                }
              }
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(const Duration(seconds: 10));
        var messageJSON = {
          "method": "SUBSCRIBE",
          "params": arrData1,
          "id": 1,
        };

        channelOpenOrder1 = IOWebSocketChannel.connect(
            Uri.parse("ss://stream.binance.com:9443/ws"),
            pingInterval: const Duration(seconds: 30));

        channelOpenOrder1!.sink.add(json.encode(messageJSON));

        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }

  socketDataOrder() {
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              if (decode['s'] == selectedPair!.symbol.toString()) {
                buyData.clear();
                sellData.clear();
                var list1 = List<dynamic>.from(decode['b']);
                var list2 = List<dynamic>.from(decode['a']);
                for (int m = 0; m < list1.length; m++) {
                  buyData.add(BuySellData(
                    list1[m][0].toString(),
                    list1[m][1].toString(),
                  ));
                  buyReverseData.add(BuySellData(
                    list1[m][0].toString(),
                    list1[m][1].toString(),
                  ));
                }
                for (int m = 0; m < list2.length; m++) {
                  sellData.add(BuySellData(
                    list2[m][0].toString(),
                    list2[m][1].toString(),
                  ));
                  sellReverseData.add(BuySellData(
                    list2[m][0].toString(),
                    list2[m][1].toString(),
                  ));
                }

                buyReverseData = buyReverseData.reversed.toList();
                sellReverseData = sellReverseData.reversed.toList();
              }
            });
          }
        }
      },
      onDone: () async {
        await Future.delayed(const Duration(seconds: 10));
        var messageJSON = {
          "method": "SUBSCRIBE",
          "params": arrData,
          "id": 1,
        };

        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse(
                "wss://stream.binance.com:9443/ws/${selectedPair!.symbol}@depth@1000ms"),
            pingInterval: const Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));

        socketDataOrder();
      },
      onError: (error) => print("ErrMano" + error),
    );
  }

  showSheeetPair(BuildContext contexts) {
    return showModalBottomSheet(
        context: contexts,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setStates) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Container(
                            height: 45.0,
                            padding: const EdgeInsets.only(left: 20.0),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: searchController,
                              focusNode: searchFocus,
                              style: TextStyle(
                                color: Theme.of(context).cardColor,
                              ),
                              enabled: true,
                              onEditingComplete: () {
                                setState(() {
                                  searchFocus.unfocus();
                                });
                              },
                              onChanged: (value) {
                                setStates(() {
                                  tradePairList = [];

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
                                      tradePairList.add(searchCoinList[m]);
                                    }
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 8, bottom: 8),
                                hintText: AppLocalizations.of(context)!
                                    .translate("loc_search"),
                                hintStyle: TextStyle(
                                    fontFamily: "FontRegular",
                                    color: Theme.of(context).dividerColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500),
                                filled: true,
                                fillColor: CustomTheme.of(context).canvasColor,
                                border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      color:
                                          CustomTheme.of(context).canvasColor,
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5.0)),
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
                                tradePairList.addAll(searchCoinList);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6.0),
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: ListView.builder(
                          controller: controller,
                          itemCount: tradePairList.length,
                          itemBuilder: ((BuildContext context, int index) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedPair = tradePairList[index];
                                      print(selectedPair!.currentPrice
                                          .toString());

                                      livePrice =
                                          selectedPair!.currentPrice.toString();
                                      pair = selectedPair!.tradePair
                                          .toString()
                                          .toUpperCase();
                                      arrData.add(
                                          '${selectedPair!.symbol.toString().toLowerCase()}@depth');

                                      arrData1.add(
                                          '${selectedPair!.symbol.toString().toLowerCase()}@ticker');
                                      var messageJSON = {
                                        "method": "SUBSCRIBE",
                                        "params": arrData,
                                        "id": 1,
                                      };
                                      chartload();

                                      channelOpenOrder = IOWebSocketChannel.connect(
                                          Uri.parse(
                                              "wss://stream.binance.com:9443/ws/${selectedPair!.symbol.toString().toUpperCase()}@depth@1000ms"),
                                          pingInterval:
                                              const Duration(seconds: 30));

                                      channelOpenOrder!.sink
                                          .add(json.encode(messageJSON));

                                      buyData.clear();
                                      sellData.clear();
                                      socketDataOrder();

                                      var messageJSON1 = {
                                        "method": "SUBSCRIBE",
                                        "params": arrData1,
                                        "id": 1,
                                      };

                                      channelOpenOrder1 =
                                          IOWebSocketChannel.connect(
                                              Uri.parse(
                                                  "wss://stream.binance.com:9443/ws"),
                                              pingInterval:
                                                  const Duration(seconds: 30));

                                      channelOpenOrder1!.sink
                                          .add(json.encode(messageJSON1));

                                      socketData();

                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0),
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
                                        tradePairList[index]
                                                    .baseAsset
                                                    .toString()
                                                    .toUpperCase() ==
                                                "SET"
                                            ? Image.asset(
                                                "assets/images/logo.png",
                                                height: 25.0,
                                                width: 25.0,
                                              )
                                            : SvgPicture.network(
                                                tradePairList[index]
                                                    .image
                                                    .toString(),
                                                width: 25.0,
                                                height: 25.0,
                                              ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          tradePairList[index]
                                              .tradePair
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

  geBalance() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
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

  doPostTrade() {
    apiUtils
        .postTrade(
      selectedPair!.pairId.toString(),
      buySell ? "buy" : "sell",
      enableTrade ? "limit" : "market",
      amountController.text.toString(),
      priceController.text.toString(),
    )
        .then((CommonModel loginData) {
      setState(() {
        if (loginData.status!) {
          CustomWidget(context: context).showSuccessAlertDialog(
              "Trade", loginData.message.toString(), "success");
          getOpenOrder();
          geBalance();
        } else {
          setState(() {
            loading = false;
            CustomWidget(context: context).showSuccessAlertDialog(
                "Trade", loginData.message.toString(), "error");
          });
        }
      });
    }).catchError((Object error) {});
  }

  getOpenOrder() {
    apiUtils.getOpenOrdersList().then((OpenOrdersModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          openOrders = [];
          openOrders = loginData.result!;
        });
      } else {
        setState(() {
          openOrders = [];
          //  loading = false;
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  updatecancelOrder(String id) {
    apiUtils.cancelOrders(id).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          openOrders = [];
          getOpenOrder();
          geBalance();
        });

        CustomWidget(context: context).showSuccessAlertDialog(
            "Trade", loginData.message.toString(), "success");
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog(
              "Trade", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double? trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class BuySellData {
  String price;
  String quantity;

  BuySellData(this.price, this.quantity);
}

class LikeStatus {
  String id;
  bool status;

  LikeStatus(this.id, this.status);
}

class BalanceData {
  String currency;
  String balance;
  String available;
  String trading;

  BalanceData(this.currency, this.balance, this.available, this.trading);
}
