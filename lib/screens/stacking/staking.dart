import 'package:flutter/material.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/stake_list_model.dart';
import 'package:zurumi/screens/stacking/stacking_subscribe.dart';
import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class Staking_Screen extends StatefulWidget {
  const Staking_Screen({Key? key}) : super(key: key);

  @override
  State<Staking_Screen> createState() => _Staking_ScreenState();
}

class _Staking_ScreenState extends State<Staking_Screen> {
  bool loading = false;

  final ScrollController _scrollController = ScrollController();

  List<StakeList> stackList = [];
  APIUtils apiUtils = APIUtils();

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
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate("loc_stak").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    17.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              leading: InkWell(
                onTap: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
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
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
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
            stackList.isNotEmpty
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: ListView.builder(
                        itemCount: stackList.length,
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 15.0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.white.withOpacity(0.05),
                                        BlendMode.dstATop),
                                    image: const AssetImage(
                                      'assets/images/logo.png',
                                    ),
                                    fit: BoxFit.contain,
                                  ),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                  // color: CustomTheme.of(context).primaryColor,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      // crossAxisAlignment:
                                      // CrossAxisAlignment.center,
                                      // mainAxisAlignment:
                                      // MainAxisAlignment
                                      //     .spaceBetween,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.translate("contract_name")}",
                                          style: AppTextStyles.poppinsRegular(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          // "Plan 1",
                                          stackList[index]
                                              .title
                                              .toString()
                                              .toUpperCase(),
                                          style: AppTextStyles.poppinsRegular(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const Spacer(),
                                        // Text(
                                        //   // stackList[index]
                                        //   //     .stackingTitle
                                        //   //     .toString(),
                                        //   "Plan 1",
                                        //   style: CustomWidget(
                                        //           context: context)
                                        //       .CustomSizedTextStyle(
                                        //           24.0,
                                        //       CustomTheme.of(context).disabledColor,
                                        //           FontWeight.w600,
                                        //           'FontRegular'),
                                        //   textAlign: TextAlign.center,
                                        // ),
                                        Image.asset(
                                          'assets/images/logo.png',
                                          height: 40.0,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.translate("loc_depo_coin")} : ${stackList[index].depositCoin}",
                                      // "Zurumi",
                                      style: AppTextStyles.poppinsRegular(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.translate("loc_min_all")} : ${stackList[index].minAmt}",
                                      // "1",
                                      style:  AppTextStyles.poppinsRegular(
                                            fontSize: 14,fontWeight: FontWeight.w500,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Text(
                                      "${AppLocalizations.of(context)!.translate("loc_max_all")} : ${stackList[index].maxAmt}",
                                      // "100",
                                      style:  AppTextStyles.poppinsRegular(
                                            fontSize: 14,fontWeight: FontWeight.w500,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 2.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${AppLocalizations.of(context)!.translate("loc_duration")} : ${stackList[index].durationTitle}",
                                          // "12 Months",
                                          style: AppTextStyles.poppinsRegular(
                                            fontSize: 14,fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Stacking_Subscribe_Screen(
                                                    stack: stackList[index],
                                                  ),
                                                ));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.25,
                                            padding: const EdgeInsets.only(
                                                top: 7.0, bottom: 7.0),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
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
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .translate("loc_sub_staking")
                                                  .toString(),
                                              style: CustomWidget(
                                                      context: context)
                                                  .CustomSizedTextStyle(
                                                      12.0,
                                                      CustomTheme.of(context)
                                                          .focusColor,
                                                      FontWeight.w400,
                                                      'FontRegular'),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          );
                        },
                      ),
                    ))
                : SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
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
    apiUtils.getStacklist().then((StakeListmodel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          stackList = loginData.result!;
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
