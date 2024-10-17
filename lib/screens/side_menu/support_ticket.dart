import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/screens/side_menu/chat_screen.dart';

import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/common_model.dart';
import '../../data/crypt_model/support_ticket_model.dart';

class SupportTicketList extends StatefulWidget {
  const SupportTicketList({Key? key}) : super(key: key);

  @override
  State<SupportTicketList> createState() => _SupportTicketListState();
}

class _SupportTicketListState extends State<SupportTicketList> {
  APIUtils apiUtils = APIUtils();
  ScrollController controller = ScrollController();
  bool loading = false;
  List<SupportTicketListResult> ticketList = [];
  final _formKey = GlobalKey<FormState>();
  FocusNode subjectFocus = FocusNode();
  FocusNode messageFocus = FocusNode();
  TextEditingController subjectController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getTicketList();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Icon(
              Icons.arrow_back,
              size: 25.0,
              color:  CustomTheme.of(context).shadowColor,
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.translate("loc_support").toString(),
          style: TextStyle(
            fontFamily: 'FontSpecial',
            color: CustomTheme.of(context).cardColor,
            fontWeight: FontWeight.w500,
            fontSize: 17.0,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
        child: Stack(
          children: [
            supportListUI(),
            loading
                ? CustomWidget(context: context).loadingIndicator(
              CustomTheme.of(context).primaryColor,
            )
                : Container(),
          ],
        ),
      ),
    ));
  }

  Widget supportListUI() {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 35.0,
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
            AppLocalizations.of(context)!.translate("loc_ticket_list").toString().toUpperCase(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      14.0,
                      Theme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
                InkWell(
                  onTap: () {
                    createTicket();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: CustomTheme.of(context).primaryColorLight.withOpacity(0.2),
                        shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.add,
                      size: 20.0,
                      color: CustomTheme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(top: 50.0),
            child:
            ticketList.length > 0
                ?
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(bottom: 10.0),
              child: ListView.builder(
                  itemCount: ticketList.length,
                  shrinkWrap: true,
                  controller: controller,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  ticket_id: ticketList[index]
                                      .ticketId
                                      .toString(),
                                )));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: <Color>[
                                    CustomTheme.of(context).primaryColorLight.withOpacity(0.4),
                                    CustomTheme.of(context).primaryColorDark.withOpacity(0.4),
                                  ],
                                  tileMode: TileMode.mirror,
                                ),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_title").toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomTextStyle(
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            ticketList[index]
                                                .subject
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomTextStyle(
                                                Theme.of(context)
                                                    .primaryColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!.translate("loc_msg").toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomTextStyle(
                                                Theme.of(context)
                                                    .cardColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            ticketList[index]
                                                .message
                                                .toString(),

                                            style: CustomWidget(
                                                context: context)
                                                .CustomTextStyle(
                                                Theme.of(context)
                                                    .primaryColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            DateFormat("MMM d,yyyy")
                                                .format(ticketList[index]
                                                .createdAt!)
                                                .toString(),
                                            style: CustomWidget(
                                                context: context)
                                                .CustomTextStyle(
                                                Theme.of(context)
                                                    .primaryColor,
                                                FontWeight.w500,
                                                'FontRegular'),
                                          ),
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            )
                : Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    CustomTheme.of(context).secondaryHeaderColor.withOpacity(0.1),
                    CustomTheme.of(context).primaryColor,
                  ],
                  tileMode: TileMode.mirror,
                ),),
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
          )
        ],
      ),
    );
  }

  createTicket() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter ssetState) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
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
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(),
                                GradientText(
                                  AppLocalizations.of(context)!.translate("loc_create_ticket").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      18.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w600,
                                      'FontRegular'),
                                  colors: [
                                    CustomTheme.of(context).disabledColor,
                                    CustomTheme.of(context).primaryColorLight,
                                  ],
                                ),
                                // Text(
                                //   "Create Ticket",
                                //   style: TextStyle(
                                //       fontSize: 18.0,
                                //       color: Theme.of(context)
                                //           .cardColor,
                                //       fontWeight: FontWeight.w700,
                                //       fontFamily: 'FontRegular'),
                                //   textAlign: TextAlign.center,
                                // ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    subjectController.clear();
                                    messageController.clear();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: 15.0),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.of(context).shadowColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.close,
                                          color:
                                          CustomTheme.of(context).primaryColor,
                                          size: 15.0),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_title").toString(),
                              style: CustomWidget(context: context).CustomTextStyle(
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              obscureText: false,
                              textInputAction: TextInputAction.next,
                              hintStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  Theme.of(context)
                                      .dividerColor,
                                  FontWeight.w400,
                                  'FontRegular'),
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z@#0-9!_.$]')),
                              // ],
                              textStyle: CustomWidget(context: context)
                                  .CustomTextStyle(
                                  CustomTheme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              radius: 8.0,
                              focusNode: subjectFocus,
                              controller: subjectController,
                              enabled: true,
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: CustomTheme.of(context)
                                  .canvasColor,
                              fillColor: CustomTheme.of(context)
                                  .canvasColor,
                              onChanged: () {},
                              hintText:
                              AppLocalizations.of(context)!.translate("loc_subject").toString(),
                              textChanged: (value) {},
                              suffix: Container(width: 0.0),
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Please enter the subject";
                                }
                                return null;
                              },
                              maxlines: 1,
                              error: "Enter the Subject",
                              text: "",
                              onEditComplete: () {
                                subjectFocus.unfocus();
                                FocusScope.of(context).requestFocus(messageFocus);
                              },
                              textInputType: TextInputType.text,

                            ),

                            // TextFormField(
                            //   autovalidateMode: AutovalidateMode.onUserInteraction,
                            //   textInputAction: TextInputAction.next,
                            //   decoration: InputDecoration(
                            //     hintStyle: CustomWidget(context: context)
                            //         .CustomTextStyle(
                            //         Theme.of(context)
                            //             .dividerColor,
                            //         FontWeight.w400,
                            //         'FontRegular'),
                            //     border: OutlineInputBorder(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(5.0)),
                            //       borderSide: BorderSide(
                            //           color: CustomTheme.of(context)
                            //               .canvasColor,
                            //           width: 1.0),
                            //     ),
                            //     disabledBorder: OutlineInputBorder(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(5.0)),
                            //       borderSide: BorderSide(
                            //           color: CustomTheme.of(context)
                            //               .canvasColor,
                            //           width: 1.0),
                            //     ),
                            //     enabledBorder: OutlineInputBorder(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(5.0)),
                            //       borderSide: BorderSide(
                            //           color: CustomTheme.of(context)
                            //               .canvasColor,
                            //           width: 1.0),
                            //     ),
                            //     focusedBorder: OutlineInputBorder(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(5.0)),
                            //       borderSide: BorderSide(
                            //           color: CustomTheme.of(context)
                            //               .canvasColor,
                            //           width: 1.0),
                            //     ),
                            //     errorBorder: OutlineInputBorder(
                            //       borderRadius:
                            //       BorderRadius.all(Radius.circular(5.0)),
                            //       borderSide:
                            //       BorderSide(color: Colors.red, width: 1.0),
                            //     ),
                            //     fillColor: Theme.of(context).canvasColor,
                            //     hintText:
                            //     AppLocalizations.of(context)!.translate("loc_subject"),
                            //     counterText: "",
                            //   ),
                            //   style: CustomWidget(context: context).CustomTextStyle(
                            //       Theme.of(context).cardColor,
                            //       FontWeight.w500,
                            //       'FontRegular'),
                            //   focusNode: subjectFocus,
                            //   controller: subjectController,
                            //   enabled: true,
                            //   validator: (value) {
                            //     if (value!.trim().isEmpty) {
                            //       return "Please enter the subject";
                            //     }
                            //     return null;
                            //   },
                            //   maxLength: 30,
                            //   maxLines: 1,
                            //   onEditingComplete: () {
                            //     messageFocus.unfocus();
                            //   },
                            //   keyboardType: TextInputType.text,
                            // ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_msg").toString(),
                              style: CustomWidget(context: context).CustomTextStyle(
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            TextFormField(
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintStyle: CustomWidget(context: context)
                                    .CustomTextStyle(
                                    Theme.of(context)
                                        .dividerColor,
                                    FontWeight.w400,
                                    'FontRegular'),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .canvasColor,
                                      width: 1.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .canvasColor,
                                      width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .canvasColor,
                                      width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: CustomTheme.of(context)
                                          .canvasColor,
                                      width: 1.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                                ),
                                fillColor: Theme.of(context).canvasColor,
                                filled: true,
                                hintText: AppLocalizations.of(context)!.translate("loc_message"),
                                counterText: "",
                              ),
                              style: CustomWidget(context: context).CustomTextStyle(
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                              focusNode: messageFocus,
                              controller: messageController,
                              enabled: true,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return "Please enter the message";
                                }
                                return null;
                              },
                              maxLength: 350,
                              maxLines: 4,
                              onEditingComplete: () {
                                messageFocus.unfocus();
                              },
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    createNewTicket(
                                        subjectController.text.toString(),
                                        messageController.text.toString());
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: <Color>[
                                      CustomTheme.of(context).primaryColorLight,
                                      CustomTheme.of(context).primaryColorDark,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_submit").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).primaryColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }

  getTicketList() {
    apiUtils.fetchSupportTicketList().then((SupportTicketListData loginData) {
      if (loginData.sucess!) {
        setState(() {
          loading = false;
          ticketList = loginData.result!;
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

  createNewTicket(
      String subject,
      String message,
      ) {
    apiUtils.doCreateTicket(subject, message).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          subjectController.clear();
          messageController.clear();
          ticketList == [];
          loading = true;
          getTicketList();
          CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Zurumi", loginData.message.toString(), "error");

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
