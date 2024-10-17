import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/common/localization/app_localizations.dart';

import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/coin_list.dart';
import 'package:zurumi/data/crypt_model/market_list_model.dart';
import 'package:zurumi/data/crypt_model/new_socket_data.dart';
import 'package:web_socket_channel/io.dart';

import '../common/custom_widget.dart';
import '../common/theme/custom_theme.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  var array_dta;


  List<MarketListModel> marketList = [];

  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();


  List<CoinList> tradePairList = [];
  List<CoinList> tradePairListAll = [];


  List arrData = [];

  List<String> marketAseetList = [];
  String selectedmarketAseet = "";
  IOWebSocketChannel? channelOpenOrder;


  int indexVal = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getCoinList();
    channelOpenOrder = IOWebSocketChannel.connect(
        Uri.parse("wss://stream.binance.com:9443/ws"),
        pingInterval: Duration(seconds: 30));

  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).primaryColor,
          body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: CustomTheme.of(context).secondaryHeaderColor,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                color: CustomTheme.of(context).secondaryHeaderColor,
                child: loading
                    ? CustomWidget(context: context)
                    .loadingIndicator(CustomTheme.of(context).primaryColor)
                    : Column(
                  children: [
                    Expanded(
                      child: favList(),
                    )
                  ],
                ),
              ),
          ),
        ));
  }

  Widget favList() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
     color: CustomTheme.of(context).secondaryHeaderColor,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 2, 15, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 0.00),
                height: 35.0,
                child: ListView.builder(
                  itemCount: marketAseetList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              indexVal = index;
                              tradePairList.clear();
                              tradePairList = [];
                              selectedmarketAseet = marketAseetList[index];
                              for (int m = 0;
                              m < tradePairListAll.length;
                              m++) {
                                if (tradePairListAll[m]
                                    .marketAsset
                                    .toString()
                                    .toLowerCase() ==
                                    selectedmarketAseet.toLowerCase()) {
                                  tradePairList.add(tradePairListAll[m]);
                                }
                              }
                            });
                          },
                          child: Container(
                              padding:
                              EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
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
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      CustomTheme.of(context).disabledColor,
                                      CustomTheme.of(context).primaryColorLight.withOpacity(0.3),
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),),
                              child: Center(
                                child: Text(
                                  marketAseetList[index].toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      indexVal == index
                                          ? Theme.of(context).primaryColor
                                          : Theme.of(context).cardColor.withOpacity(0.6),
                                      FontWeight.w500,
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
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          GradientText(
                            AppLocalizations.of(context)!.translate("loc_name").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                            colors: [
                              CustomTheme.of(context).primaryColorDark,
                              CustomTheme.of(context).primaryColorLight,
                            ],
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          GradientText(
                            AppLocalizations.of(context)!.translate("loc_vol").toString(),
                            style: CustomWidget(context: context)
                                .CustomSizedTextStyle(
                                13.0,
                                CustomTheme.of(context).cardColor,
                                FontWeight.w500,
                                'FontRegular'),
                            colors: [
                              CustomTheme.of(context).primaryColorDark,
                              CustomTheme.of(context).primaryColorLight,
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      GradientText(
                        AppLocalizations.of(context)!.translate("loc_mkt_price").toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                        colors: [
                          CustomTheme.of(context).primaryColorDark,
                          CustomTheme.of(context).primaryColorLight,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      GradientText(
                        AppLocalizations.of(context)!.translate("loc_change").toString(),
                        style: CustomWidget(context: context)
                            .CustomSizedTextStyle(
                            13.0,
                            CustomTheme.of(context).cardColor,
                            FontWeight.w500,
                            'FontRegular'),
                        colors: [
                          CustomTheme.of(context).primaryColorDark,
                          CustomTheme.of(context).primaryColorLight,
                        ],
                      ),

                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
           tradePairList.length>0?   Container(
             padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
             decoration: BoxDecoration(
               borderRadius: BorderRadius.only(topLeft: Radius.circular(15.0,), topRight: Radius.circular(15.0)),
               color: Theme.of(context).primaryColor,
             ),
             child: ListView.builder(
               itemCount: tradePairList.length,
               shrinkWrap: true,
               controller: controller,
               itemBuilder: (BuildContext context, int index) {
                 double data =
                 double.parse(tradePairList[index].hrExchange.toString());
                 return Column(
                   children: [
                     Container(
                       padding:  EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                       // decoration: BoxDecoration(
                       //     gradient: LinearGradient(
                       //       begin: Alignment.topLeft,
                       //       end: Alignment.bottomRight,
                       //       colors: <Color>[
                       //         CustomTheme.of(context).backgroundColor.withOpacity(0.5),
                       //         CustomTheme.of(context).focusColor.withOpacity(0.5),
                       //       ],
                       //       tileMode: TileMode.mirror,
                       //     ),
                       //     borderRadius: BorderRadius.circular(8.0)),
                       child: Row(
                         children: [
                           Flexible(
                             child: Container(
                               width: MediaQuery.of(context).size.width,
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     tradePairList[index].tradePair.toString(),
                                     style: CustomWidget(context: context)
                                         .CustomSizedTextStyle(
                                         13.0,
                                         Theme.of(context)
                                             .cardColor
                                             .withOpacity(0.8),
                                         FontWeight.w500,
                                         'FontRegular'),
                                   ),
                                   const SizedBox(
                                     height: 5.0,
                                   ),
                                   Text(
                                     double.parse(tradePairList[index]
                                         .hrVolume
                                         .toString()).toString(),

                                     style: CustomWidget(context: context)
                                         .CustomSizedTextStyle(
                                         10.0,
                                         Theme.of(context)
                                             .cardColor
                                             .withOpacity(0.5),
                                         FontWeight.w500,
                                         'FontRegular'),

                                   ),
                                 ],
                               ),
                             ),
                             flex: 3,
                           ),
                           Flexible(
                             child: Container(
                               child: Column(

                                 children: [
                                   Text(
                                     double.parse(tradePairList[index]
                                         .currentPrice
                                         .toString())
                                         .toStringAsFixed(4),
                                     style: CustomWidget(context: context)
                                         .CustomSizedTextStyle(
                                         11.0,
                                         double.parse(data.toString()) >= 0
                                             ? Theme.of(context)
                                             .indicatorColor
                                             : Theme.of(context).hoverColor,
                                         FontWeight.w500,
                                         'FontRegular'),
                                     textAlign: TextAlign.right,
                                   ),
                                   const SizedBox(
                                     height: 5.0,
                                   ),

                                 ],
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                               ),
                               width: MediaQuery.of(context).size.width,
                             ),
                             flex: 3,
                           ),
                           Flexible(
                             child: Container(
                               child: Center(
                                   child: Container(
                                     padding: EdgeInsets.only(
                                         left: double.parse(
                                             data.toString()) >=
                                             0
                                             ?10.0: 8.0,
                                         right: double.parse(
                                             data.toString()) >=
                                             0
                                             ?10.0: 8.0,
                                         top: 8.0,
                                         bottom: 8.0),
                                     child: Text(
                                       data.toStringAsFixed(2) + "%",
                                       style: CustomWidget(context: context)
                                           .CustomSizedTextStyle(
                                           8.0,
                                           Theme.of(context).primaryColor,
                                           FontWeight.w500,
                                           'FontRegular'),
                                     ),
                                     decoration: BoxDecoration(
                                         color: double.parse(data.toString()) >= 0
                                             ? Theme.of(context).indicatorColor
                                             : Theme.of(context).hoverColor,
                                         borderRadius: BorderRadius.circular(5.0)),
                                   )),
                             ),
                             flex: 2,
                           ),
                         ],
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.center,
                       ),
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
                             CustomTheme.of(context).primaryColorDark,
                             CustomTheme.of(context).primaryColorLight,
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
             ),
           ): Container(
             height: MediaQuery.of(context).size.height * 0.5,
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
               ),),
             child: Center(
               child: Text(
                 AppLocalizations.of(context)!.translate("loc_no_rec_found").toString(),
                 style: TextStyle(
                   fontFamily: "FontRegular",
                   color: CustomTheme.of(context).cardColor,
                 ),
               ),
             ),
           ),
            ],
          ),
        ),
      ),
    );
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

                  if(tradePairList[m].baseAsset.toString().toUpperCase()=="SET")
                  {


                  }
                  else
                  {
                    tradePairList[m].hrExchange =  double.parse(ss.p.toString()).toString();
                    tradePairList[m].currentPrice =
                        double.parse(ss.socketDataModelC.toString()).toString();
                    tradePairList[m].hrVolume =
                        double.parse(ss.socketDataModelQ.toString()).toString();
                  }

                }

              }
            });
          }


        }
      },
      onDone: () async {
        await Future.delayed(Duration(seconds: 10));
        var messageJSON = {
          "method": "SUBSCRIBE",
          "params": arrData,
          "id": 1,
        };


        channelOpenOrder = IOWebSocketChannel.connect(
            Uri.parse("ss://stream.binance.com:9443/ws"),
            pingInterval: Duration(seconds: 30));

        channelOpenOrder!.sink.add(json.encode(messageJSON));

        socketData();
      },
      onError: (error) => print("Err" + error),
    );
  }
  getCoinList() {
    apiUtils.getCoinList().then((CoinListModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;

          tradePairList = [];
          tradePairListAll = [];

          tradePairListAll = loginData.result!;

          for (int m = 0; m < tradePairListAll.length; m++) {
            marketAseetList.add(tradePairListAll[m].marketAsset.toString());

            arrData.add( tradePairListAll[m].symbol.toString().toLowerCase()+'@ticker');
          }

          marketAseetList = marketAseetList.toSet().toList();
          selectedmarketAseet = marketAseetList.first;
          loading = false;
          for (int m = 0; m < tradePairListAll.length; m++) {
            if (tradePairListAll[m].marketAsset.toString().toLowerCase() ==
                selectedmarketAseet.toLowerCase()) {
              //arrData.add( tradePairListAll[m].symbol.toString().toLowerCase()+'@ticker');
              tradePairList.add(tradePairListAll[m]);
            }
          }

          var messageJSON = {
            "method": "SUBSCRIBE",
            "params": arrData,
            "id": 1,
          };



          channelOpenOrder = IOWebSocketChannel.connect(
              Uri.parse("wss://stream.binance.com:9443/ws"),
              pingInterval: Duration(seconds: 30));

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


}
