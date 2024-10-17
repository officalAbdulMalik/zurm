import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/stake_list_model.dart';
import 'package:zurumi/screens/stacking/stacking_subscribe.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class Copy_Trade extends StatefulWidget {
  const Copy_Trade({Key? key}) : super(key: key);

  @override
  State<Copy_Trade> createState() => _Copy_TradeState();
}

class _Copy_TradeState extends State<Copy_Trade> {

  bool loading = false;

  ScrollController _scrollController = ScrollController();


  List<StakeList> stackList=[];
  APIUtils apiUtils=APIUtils();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading=true;
    getStackList();


  }
  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme
          .of(context)
          .secondaryHeaderColor,
      body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: CustomTheme
              .of(context)
              .secondaryHeaderColor,
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



  Widget stack(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [


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
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,

                            child: Stack(
                              children: [
                                Column(
                                  children: [

                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1.0, color: CustomTheme.of(context).primaryColorLight,),
                                        borderRadius: BorderRadius.circular(10.0),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            CustomTheme.of(context).secondaryHeaderColor,
                                            CustomTheme.of(context).disabledColor,
                                          ],
                                          tileMode: TileMode.mirror,
                                        ),
                                        // color: Theme.of(context).cardColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                               stackList[index].title.toString(),
                                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                                    24.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w600,
                                                    'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                              Image.asset('assets/images/logo.png', height: 40.0,),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_depo_coin").toString()+" : "+ stackList[index].depositCoin.toString(),
                                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_min_all").toString()+" : "+ stackList[index].minAmt.toString(),
                                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_max_all").toString()+" : "+ stackList[index].maxAmt.toString(),
                                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 2.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_duration").toString()+" : "+ stackList[index].durationTitle.toString(),
                                            style: CustomWidget(context: context).CustomSizedTextStyle(
                                                12.0,
                                                Theme.of(context).cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          // Text(
                                          //   AppLocalizations.of(context)!.translate("loc_tot_etr").toString()+" : "+ stackList[index].totalEtr.toString()+"%",
                                          //   style: CustomWidget(context: context).CustomSizedTextStyle(
                                          //       12.0,
                                          //       Theme.of(context).cardColor,
                                          //       FontWeight.w400,
                                          //       'FontRegular'),
                                          //   textAlign: TextAlign.center,
                                          // ),
                                          // const SizedBox(
                                          //   height: 10.0,
                                          // ),
                                          InkWell(
                                            onTap: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>  Stacking_Subscribe_Screen(
                                                      stack: stackList[index],
                                                    ),
                                                  ));
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomLeft,
                                                  end: Alignment.topRight,
                                                  colors: <Color>[
                                                    CustomTheme.of(context).primaryColorDark,
                                                    CustomTheme.of(context).primaryColorLight,
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ),
                                              ),
                                              child: Text(
                                                AppLocalizations.of(context)!.translate("loc_sub_staking").toString(),
                                                style: CustomWidget(context: context).CustomSizedTextStyle(
                                                    12.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                        ],),
                                    )
                                  ],
                                ),


                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0,),
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
