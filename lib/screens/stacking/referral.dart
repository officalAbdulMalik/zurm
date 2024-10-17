import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/referral_his_model.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';

class Referral_Screen extends StatefulWidget {
  const Referral_Screen({Key? key}) : super(key: key);

  @override
  State<Referral_Screen> createState() => _Referral_ScreenState();
}

class _Referral_ScreenState extends State<Referral_Screen> {
  bool loading = false;
  List<String> idProofType = [];
  String selectedIdProof = "";
  APIUtils apiUtils = APIUtils();
  ReferralInformation? referralInformation;
  Map<String, List<LevelInformation>>? levelInformation;

  List<LevelInformation> levelInfo = [];
  ScrollController _scrollController = ScrollController();
  String email = "";

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
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          appBar: AppBar(
              backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
              elevation: 0.0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.translate("loc_share_frnd").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    17.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Icon(
                    Icons.arrow_back,
                    size: 25.0,
                    color: CustomTheme.of(context).shadowColor,
                  ),
                ),
              )),
          body: Container(
              decoration: BoxDecoration(
                color: CustomTheme.of(context).secondaryHeaderColor,
              ),
              height: MediaQuery.of(context).size.height,
              child: loading
                  ? CustomWidget(context: context)
                      .loadingIndicator(CustomTheme.of(context).primaryColor)
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        child: Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 10.0,),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                    top: 15.0,
                                    bottom: 20.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: <Color>[
                                      CustomTheme.of(context).primaryColorLight.withOpacity(0.8),
                                      CustomTheme.of(context).primaryColorDark.withOpacity(0.5),
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GradientText(
                                      AppLocalizations.of(context)!.translate("loc_refr_url").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                              14.0,
                                              CustomTheme.of(context).canvasColor,
                                              FontWeight.w500,
                                              'FontRegular'),
                                      colors: [
                                        CustomTheme.of(context).canvasColor,
                                        CustomTheme.of(context)
                                            .canvasColor,
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: Text(
                                              referralInformation!.referUrl=="null"|| referralInformation!.referUrl==null ? "--" : referralInformation!.referUrl.toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        )),
                                        InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: referralInformation!.referUrl.toString()));
                                            CustomWidget(context: context)
                                                .showSuccessAlertDialog(
                                                    "Referral",
                                                    "URL was Copied",
                                                    "success");
                                          },
                                          child: Icon(
                                            Icons.copy_outlined,
                                            color: CustomTheme.of(context).cardColor,
                                            size: 16.0,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_refr_id").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .canvasColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          referralInformation!.referId
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_role").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        Text(
                                          referralInformation!.myRole == ""||referralInformation!.myRole=="null"||referralInformation!.myRole==null ? "-": referralInformation!.myRole
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_my_stak").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        Text(
                                          referralInformation!.myOverAllStake
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_buss").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        Text(
                                          referralInformation!.myBussiness
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_stg_leg").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        Text(
                                          referralInformation!.strongLeg
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GradientText(
                                          AppLocalizations.of(context)!.translate("loc_oth_leg").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                          colors: [
                                            CustomTheme.of(context)
                                                .canvasColor,
                                            CustomTheme.of(context)
                                                .canvasColor,
                                          ],
                                        ),
                                        Text(
                                          referralInformation!.otherLeg
                                              .toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  14.0,
                                                  CustomTheme.of(context).cardColor,
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
                              const SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          CustomTheme.of(context).primaryColor,
                                      width: 1.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: CustomTheme.of(context).primaryColor,
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor:
                                        CustomTheme.of(context).canvasColor,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      menuMaxHeight:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      items: idProofType
                                          .map((value) => DropdownMenuItem(
                                                child: Text(
                                                  value.toString(),
                                                  style: CustomWidget(
                                                          context: context)
                                                      .CustomSizedTextStyle(
                                                          14.0,
                                                          CustomTheme.of(context)
                                                              .cardColor,
                                                          FontWeight.w500,
                                                          'FontRegular'),
                                                ),
                                                value: value,
                                              ))
                                          .toList(),
                                      onChanged: (value) async {
                                        setState(() {
                                          selectedIdProof = value.toString();
                                          levelInfo = [];
                                          levelInformation!
                                              .forEach((key, value) {
                                            if (selectedIdProof.toString() ==
                                                key) {
                                              levelInfo.addAll(value);
                                            }
                                          });
                                        });
                                      },
                                      hint: Text(
                                        AppLocalizations.of(context)!.translate("loc_slct_catgy").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                14.0,
                                                CustomTheme.of(context).primaryColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                      ),
                                      isExpanded: true,
                                      value: selectedIdProof,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        // color: AppColors.otherTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              levelInfo.length > 0
                                  ? ListView.builder(
                                      itemCount: levelInfo.length,
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        bool check = false;
                                        if (email ==
                                            levelInfo[index].mail.toString()) {
                                          check = true;
                                        } else {
                                          check = false;
                                        }
                                        return Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              padding: EdgeInsets.only(
                                                  top: 15.0, bottom: 15.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: <Color>[
                                                    CustomTheme.of(context).secondaryHeaderColor,
                                                    CustomTheme.of(context).disabledColor.withOpacity(0.6),
                                                  ],
                                                  tileMode: TileMode.mirror,
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_name").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                 check?Row(
                                                  children: [
                                                    Text(
                                                      levelInfo[index]
                                                          .name
                                                          .toString(),
                                                      style: CustomWidget(
                                                          context:
                                                          context)
                                                          .CustomSizedTextStyle(
                                                          14.0,
                                                          CustomTheme.of(
                                                              context)
                                                              .cardColor,
                                                          FontWeight
                                                              .w600,
                                                          'FontRegular'),
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                    ),
                                                    Text(
                                                     " ("+ AppLocalizations.of(context)!.translate("loc_strong").toString()+" )",
                                                      style: CustomWidget(
                                                          context:
                                                          context)
                                                          .CustomSizedTextStyle(
                                                          14.0,
                                                          Colors.green,
                                                          FontWeight
                                                              .w600,
                                                          'FontRegular'),
                                                      textAlign:
                                                      TextAlign
                                                          .center,
                                                    ),
                                                  ],
                                                 )   :      Text(
                                                              levelInfo[index]
                                                                  .name
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      14.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w600,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_roles").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                          .role
                                                                          .toString() ==
                                                                      "null"
                                                                  ? "---"
                                                                  : levelInfo[
                                                                          index]
                                                                      .role
                                                                      .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    height: 1.0,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_mail").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                  .mail
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_overall_stak").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                  .overAllStake
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_bus").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                  .business
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Container(
                                                    height: 1.0,
                                                    color: Colors.white
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        right: 10.0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_tot").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                  .total
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(context)!.translate("loc_parent_info").toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor
                                                                          .withOpacity(
                                                                              0.5),
                                                                      FontWeight
                                                                          .w400,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Text(
                                                              levelInfo[index]
                                                                  .parentInfo
                                                                  .toString(),
                                                              style: CustomWidget(
                                                                      context:
                                                                          context)
                                                                  .CustomSizedTextStyle(
                                                                      12.0,
                                                                      CustomTheme.of(
                                                                              context)
                                                                          .cardColor,
                                                                      FontWeight
                                                                          .w500,
                                                                      'FontRegular'),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.translate("loc_no_rec_found").toString(),
                                          style: CustomWidget(context: context)
                                              .CustomSizedTextStyle(
                                                  16.0,
                                                  CustomTheme.of(context)
                                                      .cardColor,
                                                  FontWeight.w500,
                                                  'FontRegular'),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    )),
        ));
  }

  getStackList() {
    apiUtils.getreferralHistory().then((ReferralHistoryListmodel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          referralInformation = loginData.data!.referralInformation;
          levelInformation = loginData.data!.levelInformation;
          email = referralInformation!.strongemail.toString();
          levelInformation!.keys.forEach((key) {
            idProofType.add(key);
          });
          selectedIdProof = idProofType.first;

          levelInformation!.forEach((key, value) {
            if (selectedIdProof.toString() == key) {
              levelInfo.addAll(value);
            }
          });
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
