import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/user_details_model.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';
import 'package:zurumi/screens/side_menu/transac_his.dart';
import 'package:zurumi/screens/wallet/deposit.dart';
import 'package:zurumi/screens/wallet/withdraw.dart';
import '../common/custom_widget.dart';

import '../common/theme/custom_theme.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  APIUtils apiUtils = APIUtils();
  bool loading = false;
  List<UserWalletResult> coinList = [];
  List<UserWalletResult> searchPair = [];
  ScrollController controller = ScrollController();
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  String btcBalance = "0.00";
  String usdBalance = "0.00";
  String profileImage = "1";
  Map<String, double> dataMap = {

  };
  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xff6666ff),
    const Color(0xffffff00),
    const Color(0xff669999),
    const Color(0xff800000),
    const Color(0xff33ff99),
    const Color(0xffFE9539),
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
    const Color(0xff3398F6),
    const Color(0xffFA4A42),
    const Color(0xffFE9539)
  ];

  String name="";
  String email="";
  // List of gradients for the
  // background of the pie chart
  final gradientList = <List<Color>>[
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ],
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
    ,
    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],
    [
      Color.fromRGBO(175, 63, 62, 1.0),
      Color.fromRGBO(254, 154, 92, 1),
    ]
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getCoinList();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          body: Container(
            decoration: BoxDecoration(
              color: CustomTheme.of(context).secondaryHeaderColor,
            ),
            child: loading
                ? CustomWidget(context: context).loadingIndicator(
                    CustomTheme.of(context).primaryColor,
                  )
                : assetsUI(),
          ),
        ));
  }

  Widget assetsUI() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: CustomTheme.of(context).secondaryHeaderColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: CustomTheme.of(context).primaryColor,
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
                      
                        margin:
                            EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                        padding: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                        Row(
                          children: [
                            InkWell(
                              onTap: () {

                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(1.5),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColorLight
                                            .withOpacity(0.3),
                                        // color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle),
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .primaryColorLight
                                              .withOpacity(0.3),
                                          image: profileImage == "1" ||
                                              profileImage == "null"
                                              ? DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/profile.png"),
                                              fit: BoxFit.cover)
                                              : DecorationImage(
                                              image: NetworkImage(
                                                  profileImage),
                                              fit: BoxFit.cover)),
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
                                        AppLocalizations.of(context)!.translate('loc_welcome').toString(),
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            12.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                      Text(
                                        name.toString(),
                                        style: CustomWidget(
                                            context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate('loc_watchlist').toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate("loc_total").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          14.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/eye.svg',
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  usdBalance,
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          24.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.translate("loc_usd").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                          18.0,
                                          Theme.of(context).splashColor,
                                          FontWeight.w400,
                                          'FontRegular'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                      dataMap.length>0?      PieChart(
                              // Pass in the data for
                              // the pie chart
                              dataMap: dataMap,
                              // Set the colors for the
                              // pie chart segments
                              colorList: colorList,
                              // Set the radius of the pie chart
                              chartRadius: MediaQuery.of(context).size.width / 2.5,
                              // Set the center text of the pie chart
                              centerText: "",
                              // Set the width of the
                              // ring around the pie chart
                              ringStrokeWidth: 24,
                              // Set the animation duration of the pie chart
                              animationDuration: const Duration(seconds: 3),
                              // Set the options for the chart values (e.g. show percentages, etc.)
                              chartValuesOptions: const ChartValuesOptions(
                                  showChartValues: true,
                                  showChartValuesOutside: true,
                                  showChartValuesInPercentage: true,
                                  showChartValueBackground: false),
                              // Set the options for the legend of the pie chart
                              legendOptions: const LegendOptions(
                                  showLegends: true,
                                  legendShape: BoxShape.circle,
                                  legendTextStyle: TextStyle(fontSize: 12,color:     Colors.black, ),
                                  legendPosition: LegendPosition.bottom,
                                  showLegendsInRow: true),
                              // Set the list of gradients for
                              // the background of the pie chart
                              gradientList: gradientList,
                            ):Container(),
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
              coinList.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                        color: CustomTheme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              15.0,
                            ),
                            topRight: Radius.circular(15.0)),
                      ),
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15.0, right: 15.0),
                      padding: EdgeInsets.only(
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
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
                                            child: coinList[index]
                                                        .symbol
                                                        .toString()
                                                        .toUpperCase() ==
                                                    "SET"
                                                ? Image.asset(
                                                    "assets/images/logo.png",
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
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                coinList[index].name.toString(),
                                                style: CustomWidget(
                                                        context: context)
                                                    .CustomTextStyle(
                                                        Theme.of(context)
                                                            .cardColor,
                                                        FontWeight.w600,
                                                        'FontRegular'),
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
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
                                        children: [
                                          Text(
                                            coinList[index].balance.toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomTextStyle(
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w600,
                                                    'FontRegular'),
                                            textAlign: TextAlign.end,
                                          ),
                                          Text(
                                            coinList[index]
                                                    .usdtconvert
                                                    .toString() +" "+
                              AppLocalizations.of(context)!.translate("loc_usdt").toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    10.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                            textAlign: TextAlign.end,
                                          ),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                      )
                                    ],
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
                      color: CustomTheme.of(context).secondaryHeaderColor,
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
        ));
  }

  getCoinList() {
    apiUtils.walletBalanceInfo().then((UserWalletBalanceModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          coinList = loginData.result!;
          searchPair = loginData.result!;
          usdBalance = loginData.usdTotal.toString();
          List<String> letters = [];
          List<double> numbers = [];

          coinList..sort((a, b) => b.balance!.compareTo(a.balance!));
          for(int m=0;m<coinList.length;m++)
            {
              if(double.parse(coinList[m].balance.toString())>0)
                {
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
    });
  }

  getUserDetails() {
    apiUtils.getUserDetails().then((UserDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          profileImage = loginData.result!.profileimg.toString();
          name = loginData.result!.firstName.toString() +
              " " +
              loginData.result!.lastName.toString();
          email = loginData.result!.email.toString();
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
