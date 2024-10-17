import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/screens/side_menu/terms_condition.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.translate("loc_help").toString(),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                17.0,
                Theme.of(context).cardColor,
                FontWeight.w500,
                'FontRegular'),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child:Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Icon(
                Icons.arrow_back,
                size: 25.0,
                color:  CustomTheme.of(context).shadowColor,
              ),
            ),
          )),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                CustomTheme.of(context).secondaryHeaderColor,
                CustomTheme.of(context).primaryColor,
                CustomTheme.of(context).primaryColor,
                // CustomTheme.of(context).disabledColor.withOpacity(0.4),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child:Stack(
            children: [
              Column(
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height * 0.64,
                    margin: EdgeInsets.only(top: 0.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [


                          const SizedBox(
                            height: 20.0,
                          ),


                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsCondition(title: "loc_terms", content: 'https://zurumi.com/termsofuse'),
                                  ));
                            },
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [


                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_terms").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) => RadialGradient(
                                    center: Alignment.centerRight,
                                    stops: [0.8, 1],
                                    colors: [
                                      CustomTheme.of(context).primaryColorLight,
                                      CustomTheme.of(context).primaryColorDark,
                                    ],
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 20.0,
                          // ),
                          // Container(
                          //   height: 0.7,
                          //   width: MediaQuery.of(context).size.width,
                          //   color: CustomTheme.of(context).shadowColor,
                          // ),

                          const SizedBox(
                            height: 30.0,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsCondition(title: "loc_ppolicy", content: 'https://zurumi.com/privacypolicy'),
                                  ));

                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.translate("loc_ppolicy").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          16.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.normal,
                                          'FontRegular'),
                                    ),
                                  ],
                                ),
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) => RadialGradient(
                                    center: Alignment.centerRight,
                                    stops: [0.8, 1],
                                    colors: [
                                      CustomTheme.of(context).primaryColorLight,
                                      CustomTheme.of(context).primaryColorDark,
                                    ],
                                  ).createShader(bounds),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Theme.of(context).primaryColorDark,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),


                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),

            ],
          )
      ),
    ));
  }
}
