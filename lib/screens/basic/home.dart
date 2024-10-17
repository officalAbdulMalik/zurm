import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/common/localization/app_langugage_provider.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/coin_list.dart';
import 'package:zurumi/data/crypt_model/new_socket_data.dart';
import 'package:zurumi/data/crypt_model/user_details_model.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';
import 'package:zurumi/screens/favourite/favourite.dart';
import 'package:zurumi/screens/side_menu/side_menu.dart';
import 'package:zurumi/screens/side_menu/swap.dart';
import 'package:zurumi/screens/stacking/staking.dart';
import 'package:zurumi/screens/wallet.dart';
import 'package:zurumi/screens/wallet/deposit.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zurumi/screens/wallet/withdraw.dart';

import '../../common/bottom_nav.dart';
import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';
import '../side_menu/bank_details.dart';
import '../side_menu/transac_his.dart';
import '../stacking/copy.dart';
import '../market.dart';
import '../trade.dart';

class Home_Screen extends StatefulWidget {
  final bool loginStatus;

  const Home_Screen({Key? key, required this.loginStatus}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen>
    with TickerProviderStateMixin {
  final PageStorageBucket bucket = PageStorageBucket();

  int currentIndex = 0;
  int selectedIndex = 0;
  bool dashview = true;
  bool loading = false;
  bool market = false;
  bool price = false;
  bool change = false;
  bool popular = true;
  bool reward = false;
  bool gainer = false;
  bool marketView = false;
  late AppLanguageProvider appLanguage;
  bool assetView = false;
  final NumberFormat usCurrency = NumberFormat('#,##0', 'en_US');
  ScrollController Controller = ScrollController();
  List<Widget> bottomPage = [
    const Trade_Screen(),
    // BankScreen(),
    // WalletScreen(),
    const SideMenu(),
  ];
  int indexVal = 0;
  List<String> titleText = [
    "loc_side_home",
    "loc_side_market",
    "loc_side_trade",
    // "loc_swap",
    "loc_side_copy",
    "loc_side_assets"
  ];
  Widget screen = Container();
  String selectedType = "";
  List<String> orderType = ["Forward", "Reverse", "Long", "Short"];
  List<String> gird_txt = ["Rewards", "Referrals", "Earn", "Buy", "More"];
  List<String> gird_img = [
    "assets/images/reward.svg",
    "assets/images/referals.svg",
    "assets/images/earn.svg",
    "assets/images/buy.svg",
    "assets/images/more.svg"
  ];

  Color backColor = const Color(0xFFF9F9F9);

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();

  List<CoinList> tradePairList = [];
  List<CoinList> tradePairListAll = [];
  CoinList? details;

  String profileImage = "1";

  List arrData = [];
  String name = "";
  String email = "";
  UserDetails? userDetails;
  List<String> marketAseetList = [];
  String selectedmarketAseet = "";

  IOWebSocketChannel? channelOpenOrder;
  String currentPrice = "0.00";
  double changePrice = 0.00;

  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchPair = [];
  List<String> content = ["loc_most", "loc_gainers", "loc_loser", "loc_newly"];
  List<String> contentimg = [
    "assets/icons/Popular.svg",
    "assets/icons/Gainers.svg",
    "assets/icons/Losers.svg",
    "assets/icons/Newlist.svg"
  ];

  //asset details page
  String usdBalance = "0.00";
  Map<String, double> dataMap = {};

  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539),
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539),
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539)
  ];
  int seleIndex = -1;

  // List of gradients for the
  // background of the pie chart
  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(91, 253, 199, 1),
      const Color.fromRGBO(91, 253, 199, 1),
      // Color.fromRGBO(19, 102, 192, 0.8),
    ],
    [
      const Color.fromRGBO(3, 3, 3, 1),
      const Color.fromRGBO(3, 3, 3, 1),
      // Color.fromRGBO(74, 0, 155, 0.9),
    ],
    [
      const Color.fromRGBO(229, 0, 0, 0.9),
      const Color.fromRGBO(229, 0, 0, 0.9),
      // Color.fromRGBO(8, 168, 25, 0.9),
    ],
    [
      const Color.fromRGBO(125, 50, 5, 0.9),
      const Color.fromRGBO(125, 50, 5, 0.9),
      // Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(129, 182, 205, 1),
      const Color.fromRGBO(129, 182, 205, 1),
      // Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      const Color.fromRGBO(8, 168, 25, 0.9),
      const Color.fromRGBO(8, 168, 25, 0.9),
      // Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      const Color.fromRGBO(236, 149, 27, 0.8),
      const Color.fromRGBO(236, 149, 27, 0.8),
      // Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      const Color.fromRGBO(19, 102, 192, 0.8),
      const Color.fromRGBO(19, 102, 192, 0.8),
    ],
    [
      // Color.fromRGBO(175, 63, 62, 1.0),
      const Color.fromRGBO(74, 0, 155, 0.9),
      const Color.fromRGBO(74, 0, 155, 0.9),
    ]
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    selectedType = orderType.first;
    getCoinList();
    getUserDetails();
    // getCoinList();
    // getCoinListDta();
    getAssetCoinList();
    getCoinsDataList();
    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://stream.binance.com:9443/ws"),
        pingInterval: const Duration(seconds: 30));
  }

  getUserDetails() {
    apiUtils.getUserDetails().then((UserDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          profileImage = loginData.result!.profileimg.toString();
          name = "${loginData.result!.firstName} ${loginData.result!.lastName}";
          email = loginData.result!.email.toString();
          userDetails = loginData.result;
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

  void onSelectItem(int index) async {
    getUserDetails();
    setState(() {
      if (index == 0) {
        dashview = true;
        marketView = false;
        assetView = false;
      } else if (index == 1) {
        dashview = false;
        marketView = true;
        assetView = false;
      } else if (index == 3) {
        dashview = false;
        marketView = false;
        assetView = true;
      } else {
        marketView = false;
        dashview = false;
        assetView = false;
        currentIndex = index;
        selectedIndex = index;
        if (index == 2) {
          screen = bottomPage[0];
        } else if (index == 4) {
          screen = bottomPage[1];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguageProvider>(context);

    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
        child: WillPopScope(
          child: Scaffold(
            backgroundColor: Theme.of(context).primaryColorDark,
            appBar: AppBar(
              toolbarHeight: 0.0,
              // backgroundColor: Colors.purple,
              elevation: 0.0,
              centerTitle: true,
              leading: Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, top: 10.0, bottom: 10.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SideMenu()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(1.5),
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          // color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColorLight
                                  .withOpacity(0.3),
                              image:
                                  profileImage == "1" || profileImage == "null"
                                      ? const DecorationImage(
                                          image: AssetImage(
                                              "assets/images/profile.png"),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: NetworkImage(profileImage),
                                          fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  )),
              // title: currentIndex == 0
              //     ? InkWell(onTap: () {}, child: Container())
              //     : Text(
              //         AppLocalizations.of(context)!.translate(titleText[currentIndex]),
              //         style: CustomWidget(context: context)
              //             .CustomSizedTextStyle(
              //                 18.0,
              //                 Theme.of(context).cardColor,
              //                 FontWeight.w600,
              //                 'FontRegular'),
              //       ),
              title: Container(
                width: 0.0,
              ),
              actions: const [],
            ),
            body: PageStorage(
                bucket: bucket,
                child: dashview
                    ? newHome()
                    : marketView
                        ? FavouriteScreen(
                            marketAseetList: marketAseetList,
                            tradePairList: tradePairList,
                            tradePairListAll: tradePairListAll,
                            indexVal: indexVal,
                            searchPair: searchPair,
                            coinList: coinList,
                            onChanged: (index) {
                              indexVal = index;
                              setState(() {});
                            },
                          )
                        : assetView
                            ? assetsUI()
                            : screen),
            bottomNavigationBar: bottomBar(),
          ),
          onWillPop: () async {
            if (currentIndex != 0) {
              setState(() async {
                selectedIndex = 0;
                currentIndex = 0;
                onSelectItem(0);
              });
            } else {
              exit(0);
            }
            return false;
          },
        ));
  }

  Widget bottomBar() {
    return Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
        child: Stack(
          children: [
            Container(
              height: 80,
              margin: const EdgeInsets.only(top: 25.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        onSelectItem(0);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/home.svg',
                          height: 25.0,
                          color: selectedIndex == 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('loc_side_home')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: selectedIndex == 0
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                        onSelectItem(1);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/markets.svg',
                          height: 25.0,
                          color: selectedIndex == 1
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('loc_side_market')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: selectedIndex == 1
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                        onSelectItem(2);
                      });
                    },
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        // Text(
                        //   "Trades",
                        //   textAlign: TextAlign.center,
                        //   style: GoogleFonts.poppins(
                        //    fontWeight: FontWeight.w500,
                        //     fontSize: 12.0,
                        //     color: selectedIndex == 2
                        //         ? Theme.of(context).bottomAppBarColor
                        //         : Colors.black.withOpacity(0.5),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                        onSelectItem(3);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/assets.svg',
                          height: 25.0,
                          color: selectedIndex == 3
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('loc_side_assets')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: selectedIndex == 3
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                        onSelectItem(4);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/copy.svg',
                          height: 25.0,
                          color: selectedIndex == 4
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .translate('account')
                              .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            color: selectedIndex == 4
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                    child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = 2;
                          onSelectItem(2);
                        });
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                                colors: <Color>[
                                  Color(0xFFB8A4FF),
                                  // Color(0xFFB8A4FF),
                                  Color(0xFF795BF2),
                                ],
                                tileMode: TileMode.mirror,
                              ),
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/trades.svg',
                                  height: 25.0,
                                  // color: AppColors.whiteColor,
                                )
                              ],
                            ),
                          )),
                    )
                  ],
                )))
          ],
        ));
  }

  Widget newHome() {
    print(
      tradePairList.length,
    );

    return Container(
      color: Colors.white, // Set background color to white
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
        child: loading
            ? CustomWidget(context: context).loadingIndicator(
                Colors.purple, // Set loading indicator color to purple
              )
            : Stack(
                children: [
                  coinList.isNotEmpty && tradePairList.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const SideMenu(isNavigate: true,)));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 35.0,
                                    height: 35.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.3),
                                        image: profileImage == "1" ||
                                                profileImage == "null"
                                            ? const DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/profile.png"),
                                                fit: BoxFit.cover)
                                            : DecorationImage(
                                                image:
                                                    NetworkImage(profileImage),
                                                fit: BoxFit.cover)),
                                  ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate('loc_welcome')
                                            .toString(),
                                        style: AppTextStyles.poppinsRegular(
                                          color: Colors
                                              .black, // Set text color to black
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        name.toString(),
                                        style: AppTextStyles.poppinsRegular(
                                          color: Colors
                                              .black, // Set text color to black
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('loc_watchlist')
                                  .toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      14.0,
                                      Colors.black, // Set text color to black
                                      FontWeight.w500,
                                      'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.network(
                                                    "https://zurumi.com/images/color/${tradePairList[0].baseAsset.toString().toLowerCase().replaceAll(" ", "")}.svg",
                                                    height: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/Grow.svg",
                                                    height: 35.0,
                                                    color: Colors.orange,
                                                    fit: BoxFit.fitWidth,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tradePairList[0]
                                                            .baseAsset
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                13.0,
                                                                Colors
                                                                    .black, // Set text color to black
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "${double.parse(tradePairList[0].hrExchange.toString()).toStringAsFixed(2)}%",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                double.parse(tradePairList[0]
                                                                            .currentPrice
                                                                            .toString()) >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${double.parse(tradePairList[0].currentPrice.toString()).toStringAsFixed(4)}",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Colors
                                                                .grey, // Set text color to grey
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.start,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.network(
                                                    "https://zurumi.com/images/color/${tradePairList[1].baseAsset.toString().toLowerCase().replaceAll(" ", "")}.svg",
                                                    height: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/Lose.svg",
                                                    height: 35.0,
                                                    color: Colors.blueAccent,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tradePairList[1]
                                                            .baseAsset
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                13.0,
                                                                Colors
                                                                    .black, // Set text color to black
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "${double.parse(tradePairList[1].hrExchange.toString()).toStringAsFixed(2)}%",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                double.parse(tradePairList[1]
                                                                            .currentPrice
                                                                            .toString()) >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${double.parse(tradePairList[1].currentPrice.toString()).toStringAsFixed(4)}",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Colors
                                                                .grey, // Set text color to grey
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.start,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.network(
                                                    "https://zurumi.com/images/color/${tradePairList[2].baseAsset.toString().toLowerCase().replaceAll(" ", "")}.svg",
                                                    height: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/Lose.svg",
                                                    height: 35.0,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tradePairList[2]
                                                            .baseAsset
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                13.0,
                                                                Colors
                                                                    .black, // Set text color to black
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "${double.parse(tradePairList[2].hrExchange.toString()).toStringAsFixed(2)}%",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                double.parse(tradePairList[2]
                                                                            .currentPrice
                                                                            .toString()) >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${double.parse(tradePairList[2].currentPrice.toString()).toStringAsFixed(4)}",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Colors
                                                                .grey, // Set text color to grey
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.start,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0,
                                              right: 10.0,
                                              top: 5.0,
                                              bottom: 5.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  SvgPicture.network(
                                                    "https://zurumi.com/images/color/${tradePairList[3].baseAsset.toString().toLowerCase().replaceAll(" ", "")}.svg",
                                                    height: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 10.0,
                                                  ),
                                                  SvgPicture.asset(
                                                    "assets/icons/Grow.svg",
                                                    height: 35.0,
                                                    color: Colors
                                                        .deepPurple, // Set icon color to deep purple
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        tradePairList[3]
                                                            .baseAsset
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                13.0,
                                                                Colors
                                                                    .black, // Set text color to black
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      const SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Text(
                                                        "${double.parse(tradePairList[3].hrExchange.toString()).toStringAsFixed(2)}%",
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                double.parse(tradePairList[3]
                                                                            .currentPrice
                                                                            .toString()) >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${double.parse(tradePairList[3].currentPrice.toString()).toStringAsFixed(4)}",
                                                    style: CustomWidget(
                                                            context: context)
                                                        .CustomSizedTextStyle(
                                                            12.0,
                                                            Colors
                                                                .grey, // Set text color to grey
                                                            FontWeight.w500,
                                                            'FontRegular'),
                                                    textAlign: TextAlign.start,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Swap(),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            'assets/icons/buy.png',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_swap")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DepositScreen(
                                                id: coinList[0].name.toString(),
                                                coinList: searchPair,
                                              ),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            'assets/icons/deposit.png',
                                           height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_deposit")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Staking_Screen(),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            'assets/icons/stake.png',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("stake")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Trade_Screen(),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            'assets/icons/Trade.png',
                                           height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("trade")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WithDraw(
                                                id: coinList[0].name.toString(),
                                                coinList: searchPair,
                                              ),
                                            ));
                                      },
                                      child: Column(
                                        children: [
                                          Center(
                                              child: Image.asset(
                                            'assets/icons/withdraw.png',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_withdraw")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 12,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_explore")
                                  .toString(),
                              style: AppTextStyles.poppinsRegular(
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
                        )
                      : Container(),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.47,
                      ),
                      padding: const EdgeInsets.only(top: 5.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      15.0,
                                    ),
                                    topRight: Radius.circular(15.0)),
                              ),
                              child: ListView.builder(
                                itemCount: tradePairList.length,
                                shrinkWrap: true,
                                controller: Controller,
                                itemBuilder: (BuildContext context, int index) {
                                  String image = "";
                                  String name = "";
                                  double data = double.parse(
                                      tradePairList[index]
                                          .hrExchange
                                          .toString());
                                  for (int m = 0; m < coinList.length; m++) {
                                    if (coinList[m]
                                            .symbol
                                            .toString()
                                            .replaceAll(" ", "")
                                            .toLowerCase() ==
                                        tradePairList[index]
                                            .baseAsset
                                            .toString()
                                            .replaceAll(" ", "")
                                            .toLowerCase()) {
                                      name = coinList[m]
                                          .name
                                          .toString()
                                          .toUpperCase();
                                      image = coinList[m].image.toString();
                                    }
                                  }
                                  return Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 3,
                                            child: Container(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.network(
                                                    image,
                                                    height: 30.0,
                                                  ),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        name,
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                12.0,
                                                                Colors
                                                                    .black, // Set text color to black
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      Text(
                                                        tradePairList[index]
                                                            .baseAsset
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: CustomWidget(
                                                                context:
                                                                    context)
                                                            .CustomSizedTextStyle(
                                                                11.0,
                                                                Colors
                                                                    .grey, // Set text color to grey
                                                                FontWeight.w500,
                                                                'FontRegular'),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "${double.parse(tradePairList[index].hrExchange.toString()).toStringAsFixed(2)}%",
                                                  style: AppTextStyles
                                                      .poppinsRegular(
                                                    color: double.parse(
                                                                tradePairList[
                                                                        index]
                                                                    .hrExchange
                                                                    .toString()) >
                                                            0
                                                        ? Colors.blue
                                                        : Colors.orange,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                Text(
                                                  "\$${double.parse(tradePairList[index].currentPrice.toString()).toStringAsFixed(4)}",
                                                  style: AppTextStyles
                                                      .poppinsRegular(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                  textAlign: TextAlign.start,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Container(
                                        height: 1.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: <Color>[
                                              Colors.purple,
                                              Colors.white,
                                            ],
                                            tileMode: TileMode.mirror,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ))
                ],
              ),
      ),
    );
  }

  viewbottomOption() {
    showModalBottomSheet(
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
            return Wrap(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
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
                    padding: EdgeInsets.only(
                      right: 10.0,
                      left: 10.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepositScreen(
                                      id: coinList[0].name.toString(),
                                      coinList: searchPair,
                                    ),
                                  ));
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.3),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.download_rounded,
                                          size: 26.0,
                                          color: Theme.of(context)
                                              .primaryColorLight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate("loc_deposit")
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  Theme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate("loc_depo_cash")
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  12.0,
                                                  Theme.of(context).shadowColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 15.0,
                                  color: Theme.of(context).shadowColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                CustomTheme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.4),
                                CustomTheme.of(context).primaryColorLight,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WithDraw(
                                      id: coinList[0].name.toString(),
                                      coinList: searchPair,
                                    ),
                                  ));
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.upload_rounded,
                                            size: 26.0,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_withdraw")
                                                .toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_withdraw_cash")
                                                .toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .shadowColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 15.0,
                                  color: Theme.of(context).shadowColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Container(
                          height: 1.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                CustomTheme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.4),
                                CustomTheme.of(context).primaryColorLight,
                              ],
                              tileMode: TileMode.mirror,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Swap(),
                                  ));
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.import_export_rounded,
                                            size: 26.0,
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_swap")
                                                .toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    14.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w500,
                                                    'FontRegular'),
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_swap_txt")
                                                .toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .shadowColor,
                                                        FontWeight.w500,
                                                        'FontRegular'),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  size: 15.0,
                                  color: Theme.of(context).shadowColor,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ))
              ],
            );
          });
        });
  }



  Widget assetsUI() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomTheme.of(context).primaryColorDark,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: CustomTheme.of(context).primaryColorDark,
                            // gradient: LinearGradient(
                            //   begin: Alignment.bottomLeft,
                            //   end: Alignment.topRight,
                            //   colors: <Color>[
                            //     CustomTheme.of(context).backgroundColor,
                            //     CustomTheme.of(context).bottomAppBarColor,
                            //   ],
                            //   tileMode: TileMode.mirror,
                            // ),
                            borderRadius: BorderRadius.circular(15.0)),
                        margin: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 5.0),
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 10.0, top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .translate("loc_total")
                                      .toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                Text(
                                  "\$${usCurrency.format(double.parse(usdBalance))}",
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          24.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child: Row(
                                    //     children: [
                                    //       Container(
                                    //         padding: const EdgeInsets.all(1.5),
                                    //         decoration: BoxDecoration(
                                    //             color: Theme.of(context)
                                    //                 .primaryColorLight
                                    //                 .withOpacity(0.3),
                                    //             // color: Theme.of(context).primaryColor,
                                    //             shape: BoxShape.circle),
                                    //         child: Container(
                                    //           alignment: Alignment.center,
                                    //           width: 35.0,
                                    //           height: 35.0,
                                    //           decoration: BoxDecoration(
                                    //               shape: BoxShape.circle,
                                    //               color: Theme.of(context)
                                    //                   .primaryColorLight
                                    //                   .withOpacity(0.3),
                                    //               image: profileImage == "1" ||
                                    //                       profileImage == "null"
                                    //                   ? const DecorationImage(
                                    //                       image: AssetImage(
                                    //                           "assets/images/profile.png"),
                                    //                       fit: BoxFit.cover)
                                    //                   : DecorationImage(
                                    //                       image: NetworkImage(
                                    //                           profileImage),
                                    //                       fit: BoxFit.cover)),
                                    //         ),
                                    //       ),
                                    //       const SizedBox(
                                    //         width: 10.0,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Text(
                                        //   AppLocalizations.of(context)!
                                        //       .translate('loc_welcome')
                                        //       .toString(),
                                        //   style: CustomWidget(context: context)
                                        //       .CustomSizedTextStyle(
                                        //           12.0,
                                        //           Theme.of(context).cardColor,
                                        //           FontWeight.w500,
                                        //           'FontRegular'),
                                        //   textAlign: TextAlign.start,
                                        // ),
                                        // Text(
                                        //   name.toString(),
                                        //   style: CustomWidget(context: context)
                                        //       .CustomSizedTextStyle(
                                        //           14.0,
                                        //           Theme.of(context).cardColor,
                                        //           FontWeight.w500,
                                        //           'FontRegular'),
                                        //   textAlign: TextAlign.start,
                                        // ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            dataMap.isNotEmpty
                                ? PieChart(
                                    // Pass in the data for
                                    // the pie chart
                                    dataMap: dataMap,
                                    // Set the colors for the
                                    // pie chart segments
                                    colorList: colorList,
                                    // Set the radius of the pie chart
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 2.5,
                                    // Set the center text of the pie chart
                                    centerText: "",
                                    // Set the width of the
                                    // ring around the pie chart
                                    ringStrokeWidth: 24,
                                    // Set the animation duration of the pie chart
                                    animationDuration:
                                        const Duration(seconds: 3),
                                    // Set the options for the chart values (e.g. show percentages, etc.)
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                            showChartValues: true,
                                            showChartValuesOutside: true,
                                            showChartValuesInPercentage: true,
                                            showChartValueBackground: false),
                                    // Set the options for the legend of the pie chart
                                    legendOptions: const LegendOptions(
                                        showLegends: true,
                                        legendShape: BoxShape.circle,
                                        legendTextStyle: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                        legendPosition: LegendPosition.bottom,
                                        showLegendsInRow: true),
                                    // Set the list of gradients for
                                    // the background of the pie chart
                                    gradientList: gradientList,
                                  )
                                : Container(),
                          ],
                        )),
                    // const SizedBox(
                    //   height: 15.0,
                    // ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.5,
                    //   padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(25.0),
                    //     gradient: LinearGradient(
                    //       begin: Alignment.centerLeft,
                    //       end: Alignment.centerRight,
                    //       colors: <Color>[
                    //         CustomTheme.of(context).bottomAppBarColor,
                    //         CustomTheme.of(context).backgroundColor,
                    //       ],
                    //       tileMode: TileMode.mirror,
                    //     ),
                    //   ),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Flexible(child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => DepositScreen(
                    //                   id: coinList[0].name.toString(),
                    //                   coinList: searchPair,
                    //                 ),
                    //               ));
                    //         },
                    //         child: Text(
                    //           "Deposit",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //               14.0,
                    //               CustomTheme.of(context).primaryColor,
                    //               FontWeight.w500,
                    //               'FontRegular'),
                    //         ),
                    //       ), flex: 1,),
                    //       const SizedBox(width: 10.0,),
                    //       Container(
                    //         height: 25.0,
                    //         width: 1.0,
                    //         color: Theme.of(context).cardColor,
                    //       ),
                    //       const SizedBox(width: 10.0,),
                    //       Flexible(child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                 builder: (context) => WithDraw(
                    //                   id: coinList[0].name.toString(),
                    //                   coinList: searchPair,
                    //                 ),
                    //               ));
                    //         },
                    //         child: Text(
                    //           "Withdraw",
                    //           style: CustomWidget(context: context)
                    //               .CustomSizedTextStyle(
                    //               14.0,
                    //               CustomTheme.of(context).primaryColor,
                    //               FontWeight.w500,
                    //               'FontRegular'),
                    //         ),
                    //       ), flex: 1,),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              // Container(
              //   margin: EdgeInsets.only(
              //     top: MediaQuery.of(context).size.height * 0.3,
              //   ),
              //   width: MediaQuery.of(context).size.width,
              //   child: Column(
              //     children: [
              //       // Container(
              //       //   height: 45.0,
              //       //   padding: EdgeInsets.only(left: 10.0, right: 10.0),
              //       //   width: MediaQuery.of(context).size.width,
              //       //   child: TextField(
              //       //     controller: searchController,
              //       //     focusNode: searchFocus,
              //       //     style: TextStyle(
              //       //       color: Theme.of(context).cardColor,
              //       //     ),
              //       //     enabled: true,
              //       //     onEditingComplete: () {
              //       //       setState(() {
              //       //         searchFocus.unfocus();
              //       //
              //       //       });
              //       //     },
              //       //     onChanged: (value) {
              //       //
              //       //         setState(() {
              //       //           coinList = [];
              //       //           for (int m = 0; m < searchPair.length; m++) {
              //       //             if (searchPair[m]
              //       //                 .symbol
              //       //                 .toString()
              //       //                 .toLowerCase()
              //       //                 .contains(value.toLowerCase()) ||
              //       //                 searchPair[m]
              //       //                     .symbol
              //       //                     .toString()
              //       //                     .toLowerCase()
              //       //                     .contains(value.toLowerCase())) {
              //       //               coinList.add(searchPair[m]);
              //       //             }
              //       //           }
              //       //         });
              //       //     },
              //       //     decoration: InputDecoration(
              //       //       contentPadding: const EdgeInsets.only(
              //       //           left: 12, right: 0, top: 8, bottom: 8),
              //       //       hintText: "Search",
              //       //       hintStyle: TextStyle(
              //       //           fontFamily: "FontRegular",
              //       //           color: Theme.of(context).highlightColor,
              //       //           fontSize: 14.0,
              //       //           fontWeight: FontWeight.w500),
              //       //       filled: true,
              //       //       fillColor: CustomTheme.of(context).canvasColor,
              //       //       border: OutlineInputBorder(
              //       //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       //         borderSide: BorderSide(
              //       //             color: CustomTheme.of(context)
              //       //                 .canvasColor.withOpacity(0.5),
              //       //             width: 1.0),
              //       //       ),
              //       //       disabledBorder: OutlineInputBorder(
              //       //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       //         borderSide: BorderSide(
              //       //             color: CustomTheme.of(context)
              //       //                 .canvasColor,
              //       //             width: 1.0),
              //       //       ),
              //       //       enabledBorder: OutlineInputBorder(
              //       //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       //         borderSide: BorderSide(
              //       //             color: CustomTheme.of(context)
              //       //                 .canvasColor.withOpacity(0.5),
              //       //             width: 1.0),
              //       //       ),
              //       //       focusedBorder: OutlineInputBorder(
              //       //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       //         borderSide: BorderSide(
              //       //             color: CustomTheme.of(context)
              //       //                 .bottomAppBarColor.withOpacity(0.5),
              //       //             width: 1.0),
              //       //       ),
              //       //       errorBorder: const OutlineInputBorder(
              //       //         borderRadius: BorderRadius.all(Radius.circular(5)),
              //       //         borderSide: BorderSide(color: Colors.red, width: 0.0),
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ),
              //       // coinList.length > 0
              //       //     ? const SizedBox(
              //       //   height: 10.0,
              //       // )
              //       //     : Container(),
              //     ],
              //   ),
              // ),
              coinList.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: CustomTheme.of(context).primaryColorDark,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(
                              15.0,
                            ),
                            topRight: Radius.circular(15.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15.0, right: 15.0, bottom: 10.0),
                      child: SingleChildScrollView(
                          controller: controller,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: coinList.length,
                            shrinkWrap: true,
                            controller: controller,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 35.0,
                                              width: 35.0,
                                              // decoration: BoxDecoration(
                                              //   borderRadius:
                                              //   BorderRadius.circular(
                                              //       5.0),
                                              //   color: CustomTheme.of(context)
                                              //       .cardColor,
                                              // ),
                                              // padding: EdgeInsets.all(5.0),
                                              child: SvgPicture.network(
                                                coinList[index]
                                                    .image
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10.0,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  coinList[index]
                                                      .name
                                                      .toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .cardColor,
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Text(
                                                  coinList[index]
                                                      .symbol
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .hintColor,
                                                          FontWeight.normal,
                                                          'FontRegular'),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              coinList[index]
                                                  .balance
                                                  .toString(),
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomTextStyle(
                                                          Theme.of(context)
                                                              .cardColor,
                                                          FontWeight.w600,
                                                          'FontRegular'),
                                              textAlign: TextAlign.end,
                                            ),
                                            Text(
                                              "${coinList[index].usdtconvert} ${AppLocalizations.of(context)!.translate("loc_usdt")}",
                                              style:
                                                  CustomWidget(context: context)
                                                      .CustomSizedTextStyle(
                                                          10.0,
                                                          Theme.of(context)
                                                              .cardColor,
                                                          FontWeight.w400,
                                                          'FontRegular'),
                                              textAlign: TextAlign.end,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      viewbottomOption();
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: <Color>[
                                          CustomTheme.of(context)
                                              .primaryColorDark,
                                          CustomTheme.of(context)
                                              .primaryColorLight,
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                ],
                              );
                            },
                          )))
                  : Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.42),
                      height: MediaQuery.of(context).size.height * 0.35,
                      color: CustomTheme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_no_rec_found")
                              .toString(),
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
        ));
  }

  getCoinList() {
    apiUtils.getCoinList().then((CoinListModel loginData) {
      if (loginData.success!) {
        debugPrint("COINS LIST DATA SUCESS ${loginData.result!.length}");

        setState(() {
          tradePairList = [];
          tradePairListAll = [];

          List<CoinList> tradePairListAlls = loginData.result!;
          for (int m = 0; m < tradePairListAlls.length; m++) {
            if (tradePairListAlls[m].marketAsset.toString() != "INR") {
              tradePairListAll.add(tradePairListAlls[m]);
            }
          }

          for (int m = 0; m < tradePairListAll.length; m++) {
            marketAseetList.add(tradePairListAll[m].marketAsset.toString());

            arrData.add(
                '${tradePairListAll[m].symbol.toString().toLowerCase()}@ticker');
          }

          marketAseetList = marketAseetList.toSet().toList();
          selectedmarketAseet = marketAseetList.first;

          for (int m = 0; m < tradePairListAll.length; m++) {
            if (tradePairListAll[m].marketAsset.toString().toLowerCase() ==
                selectedmarketAseet.toLowerCase()) {
              //arrData.add( tradePairListAll[m].symbol.toString().toLowerCase()+'@ticker');
              tradePairList.add(tradePairListAll[m]);
            }
          }

          //

          var messageJSON = {
            "method": "SUBSCRIBE",
            "params": arrData,
            "id": 1,
          };

          channelOpenOrder = IOWebSocketChannel.connect(
              Uri.parse("wss://stream.binance.com:9443/ws"),
              pingInterval: const Duration(seconds: 30));

          channelOpenOrder!.sink.add(json.encode(messageJSON));

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
      throw error;
    });
  }

  socketData() {
    channelOpenOrder!.stream.listen(
      (data) {
        if (data != null || data != "null") {
          var decode = jsonDecode(data);

          if (mounted) {
            setState(() {
              SocketDataModel ss = SocketDataModel.fromJson(decode);
              for (int m = 0; m < tradePairList.length; m++) {
                if (tradePairList[m].symbol.toString().toLowerCase() ==
                    ss.s.toString().toLowerCase()) {
                  if (tradePairList[m].baseAsset.toString().toUpperCase() ==
                      "BTC") {
                    currentPrice =
                        double.parse(ss.socketDataModelC.toString()).toString();
                    changePrice = double.parse(ss.p.toString());
                  }
                  // else
                  // {
                  tradePairList[m].hrExchange =
                      double.parse(ss.p.toString()).toString();
                  tradePairList[m].currentPrice =
                      double.parse(ss.socketDataModelC.toString()).toString();
                  tradePairList[m].hrVolume =
                      double.parse(ss.socketDataModelQ.toString()).toString();
                  // }
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
          "params": arrData,
          "id": 1,
        };

        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("ss://stream.binance.com:9443/ws"),
            pingInterval: const Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));

        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }

  // getCoinListDta() {
  //   apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
  //     if (loginData.success!) {
  //       setState(() {
  //         loading = false;
  //         coinList = loginData.result!;
  //         coinList.sort((a, b) => b.balance!.compareTo(a.balance!));
  //       });
  //     } else {
  //       setState(() {
  //         loading = false;
  //       });
  //     }
  //   }).catchError((Object error) {
  //     print(error);
  //     setState(() {
  //       loading = false;
  //     });
  //     throw error;
  //   });
  // }

  getCoinsDataList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
          searchPair = loginData.result!;
          // usdBalance = loginData.usdTotal.toString();
          List<String> letters = [];
          List<double> numbers = [];

          coinList.sort((a, b) => b.balance!.compareTo(a.balance!));
          for (int m = 0; m < coinList.length; m++) {
            if (double.parse(coinList[m].balance.toString()) > 0) {
              letters.add(coinList[m].symbol.toString());
              numbers.add(double.parse(coinList[m].balance.toString()));
            }
          }
          // dataMap = Map.fromIterables(letters, numbers);
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
      throw error;
    });
  }

  chooseOption(int index) {
    setState(() {
      print(index);
      tradePairList.clear();
      tradePairList = [];
      tradePairList.addAll(tradePairListAll);
      if (index == 0) {
        tradePairList.sort((b, a) => double.parse(a.currentPrice.toString())
            .compareTo(double.parse(b.currentPrice.toString())));
      } else if (index == 1) {
        tradePairList.sort((b, a) => double.parse(a.hrExchange.toString())
            .compareTo(double.parse(b.hrExchange.toString())));
      } else if (index == 2) {
        tradePairList.sort((a, b) => double.parse(a.hrExchange.toString())
            .compareTo(double.parse(b.hrExchange.toString())));
      } else if (index == 3) {
        tradePairList.sort((a, b) => DateTime.parse(a.createdAt.toString())
            .compareTo(DateTime.parse(a.createdAt.toString())));

        tradePairList = tradePairList.reversed.toList();
      }
    });
  }

  getAssetCoinList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
          searchPair = loginData.result!;
          usdBalance = loginData.usdTotal.toString();
          List<String> letters = [];
          List<double> numbers = [];

          coinList.sort((a, b) => b.balance!.compareTo(a.balance!));
          for (int m = 0; m < coinList.length; m++) {
            if (double.parse(coinList[m].balance.toString()) > 0) {
              letters.add(coinList[m].symbol.toString());
              numbers.add(double.parse(coinList[m].balance.toString()));
            }
          }
          dataMap = Map.fromIterables(letters, numbers);
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
      throw error;
    });
  }
}

class BottomItem extends StatelessWidget {
  const BottomItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColorLight.withOpacity(0.3),
          ),
          child: Center(
            child: Icon(
              Icons.download_rounded,
              size: 26.0,
              color: Theme.of(context).primaryColorLight,
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate("loc_deposit").toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(14.0,
                  Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
            ),
            Text(
              AppLocalizations.of(context)!
                  .translate("loc_depo_cash")
                  .toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  12.0,
                  Theme.of(context).shadowColor,
                  FontWeight.w500,
                  'FontRegular'),
            )
          ],
        )
      ],
    );
  }
}
