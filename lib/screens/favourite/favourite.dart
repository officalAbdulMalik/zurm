
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/data/crypt_model/coin_list.dart';
import 'package:zurumi/data/crypt_model/user_wallet_balance_model.dart';
import 'package:zurumi/screens/side_menu/swap.dart';
import 'package:zurumi/screens/wallet/deposit.dart';
import 'package:zurumi/screens/wallet/withdraw.dart';

class FavouriteScreen extends StatefulWidget {
   FavouriteScreen({super.key, required this.marketAseetList, this.indexVal, this.onChanged,required this.tradePairList,required this.tradePairListAll, this.coinList, required this.searchPair});

  final List<String> marketAseetList;
  String selectedmarketAseet = "";
 final  List<CoinList>? tradePairList;
   final List<CoinList>? tradePairListAll;
  final int? indexVal;
  final List<UserWalletResult>? coinList;
  final List<UserWalletResult> searchPair;
  final Function(int index)? onChanged;

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 0.00),
                height: 35.0,
                child: ListView.builder(
                  itemCount: widget.marketAseetList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              // widget.indexVal = index;
                              widget.tradePairList!.clear();
                              widget.selectedmarketAseet = widget.marketAseetList[index];
                              for (int m = 0;
                              m < widget.tradePairListAll!.length;
                              m++) {
                                if (widget.tradePairListAll![m]
                                    .marketAsset
                                    .toString()
                                    .toLowerCase() ==
                                    widget.selectedmarketAseet.toLowerCase()) {
                                  widget.tradePairList!.add(widget.tradePairListAll![m]);
                                }
                              }
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 0.0, 20.0, 0.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: widget.indexVal != index
                                        ? Colors.black
                                        : Colors.white),
                                color: widget.indexVal == index
                                    ? Colors.purple
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  widget.marketAseetList[index].toString(),
                                  style: AppTextStyles.poppinsRegular(
                                    color: widget.indexVal != index
                                        ? Colors.black
                                        : Colors.white,
                                  ),
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
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!
                            .translate("loc_name")
                            .toString(),
                        style: AppTextStyles.poppinsRegular(),
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .translate("loc_vol")
                            .toString(),
                        style: AppTextStyles.poppinsRegular(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Text(
                      AppLocalizations.of(context)!
                          .translate("loc_mkt_price")
                          .toString(),
                      style: AppTextStyles.poppinsRegular()),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .translate("loc_change")
                        .toString(),
                    style: AppTextStyles.poppinsRegular(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              widget.tradePairList!.isNotEmpty
                  ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 10,right: 10,bottom: 30),
                itemCount: widget.tradePairList!.length,
                shrinkWrap: true,
                // controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  double data = double.parse(
                      widget.tradePairList![index].hrExchange.toString());
                  return Column(
                    children: [
                      InkWell(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius:15,

                              child: SvgPicture.network(
                                "https://zurumi.com/images/color/${widget.tradePairList![index].baseAsset.toString().toLowerCase().replaceAll(" ", "")}.svg",
                                height: 30.0,
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.tradePairList![index]
                                          .baseAsset
                                          .toString(),
                                      style:
                                      CustomWidget(context: context)
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
                                      double.parse(widget.tradePairList![index]
                                          .hrVolume
                                          .toString())
                                          .toStringAsFixed(4),
                                      style:
                                      CustomWidget(context: context)
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
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      double.parse(widget.tradePairList![index]
                                          .currentPrice
                                          .toString())
                                          .toStringAsFixed(4),
                                      style: CustomWidget(
                                          context: context)
                                          .CustomSizedTextStyle(
                                          11.0,
                                          double.parse(data
                                              .toString()) >=
                                              0
                                              ? Theme.of(context)
                                              .indicatorColor
                                              : Theme.of(context)
                                              .hoverColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left:
                                      double.parse(data.toString()) >=
                                          0
                                          ? 10.0
                                          : 8.0,
                                      right:
                                      double.parse(data.toString()) >=
                                          0
                                          ? 10.0
                                          : 8.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border:Border.all(color:double.parse(data.toString()) >=
                                          0
                                          ?Colors.blue:Colors.orange,),
                                      borderRadius:
                                      BorderRadius.circular(5.0)),

                                  child: Text(
                                    data.toStringAsFixed(2) + "%",
                                    style: AppTextStyles.poppinsRegular(
                                      color: double.parse(data.toString()) >=
                                          0
                                          ?Colors.blue:Colors.orange,
                                      fontSize:  11.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
              )
                  : Container(
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
                  ),
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate("loc_no_rec_found")
                        .toString(),
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
                                          id: widget.coinList![0].name.toString(),
                                          coinList: widget.searchPair,
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
                                          id: widget.coinList![0].name.toString(),
                                          coinList:  widget.searchPair,
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
}
