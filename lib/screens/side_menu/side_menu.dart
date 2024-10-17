import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zurumi/common/localization/app_langugage_provider.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/user_details_model.dart';
import 'package:zurumi/screens/side_menu/kyc_info.dart';
import 'package:zurumi/screens/side_menu/swap.dart';
import '../../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';
import '../../common/theme/themes.dart';
import '../../data/api_utils.dart';
import '../profile/profile.dart';
import 'change_password.dart';
import '../basic/login_screen.dart';
import 'email_verify.dart';
import 'google_tfa.dart';
import 'help_center.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key, this.isNavigate}) : super(key: key);

  final bool? isNavigate;

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool theme = false;
  bool kycUpdate = false;
  APIUtils apiUtils = APIUtils();
  String name = "";
  String email = "";
  bool loading = false;
  bool googleUpdate = false;
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();

  String kycStatus = "";
  UserDetails? userDetails;
  late AppLanguageProvider appLanguage;

  String language = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading = true;
    getUserDetails();
    getData();
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String m = preferences.getString('language_code').toString();
    if (m == "fr") {
      language = "1";
    } else {
      language = "0";
    }
  }

  void _changeTheme(BuildContext buildContext, MyThemeKeys key) {
    CustomTheme.instanceOf(buildContext).changeTheme(key);
  }

  getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      String themeType = preferences.getString('theme').toString();
      name = preferences.getString("name").toString() == "null"
          ? "Set Name"
          : preferences.getString("name").toString();

      if (themeType == "null") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        theme = true;
      } else if (themeType == "light") {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.LIGHT);
        theme = false;
      } else {
        CustomTheme.instanceOf(context).changeTheme(MyThemeKeys.DARK);
        theme = true;
      }
    });
  }

  _getRequests() async {
    setState(() {
      getUserDetails();
      loading = true;
    });
  }

  StoreData(String themeData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("theme", themeData);
  }

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguageProvider>(context);
    return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: CustomTheme.of(context).primaryColorDark,
          body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding:
                  const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
              // color: CustomTheme.of(context).secondaryHeaderColor,

              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.isNavigate == true
                                ? InkWell(
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 25.0,
                                      color: Colors.black,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                : const SizedBox(),
                            PopupMenuButton<int>(
                              key: _key,
                              color: CustomTheme.of(context).primaryColorDark,
                              itemBuilder: (context) => [
                                // PopupMenuItem 1
                                PopupMenuItem(
                                  value: 1,
                                  // row with 2 children
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate("loc_english")
                                            .toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                16.0,
                                                language == "0"
                                                    ? Theme.of(context)
                                                        .focusColor
                                                    : Theme.of(context)
                                                        .cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                    ],
                                  ),
                                ),
                                // PopupMenuItem 2
                                PopupMenuItem(
                                  value: 2,
                                  // row with two children
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate("loc_french")
                                            .toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                                16.0,
                                                language == "1"
                                                    ? Theme.of(context)
                                                        .focusColor
                                                    : Theme.of(context)
                                                        .cardColor,
                                                FontWeight.w400,
                                                'FontRegular'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              elevation: 2,
                              onSelected: (value) {
                                if (value == 1) {
                                  language = "0";
                                  appLanguage
                                      .changeLanguage(const Locale("en"));
                                } else if (value == 2) {
                                  language = "1";
                                  appLanguage
                                      .changeLanguage(const Locale("fr"));
                                }
                                getData();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Icon(
                                  Icons.language,
                                  size: 25.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                      builder: (_) => Profile_Screen(
                                            userDetails: userDetails!,
                                          )),
                                )
                                .then((val) => val ? _getRequests() : null);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                                top: 20.0,
                                bottom: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      // "Test",
                                      style: AppTextStyles.poppinsLight(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Email: $email",
                                      // "Email: " + "testing@mailinator.com",
                                      style: AppTextStyles.poppinsLight(),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        //  const SizedBox(height: 20.0,),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.25,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 15.0,
                                bottom: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              // color: CustomTheme
                              //     .of(context)
                              //     .shadowColor
                              //     .withOpacity(0.1),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChangePassword(),
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              // gradient: LinearGradient(
                                              //   begin: Alignment.bottomLeft,
                                              //   end: Alignment.topRight,
                                              //   colors: <Color>[
                                              //     CustomTheme.of(context).bottomAppBarColor,
                                              //     CustomTheme.of(context).backgroundColor,
                                              //   ],
                                              //   tileMode: TileMode.mirror,
                                              // ),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/sidemenu/settings.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/settings.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate(
                                                    "loc_change_password")
                                                .toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    16.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("modify")
                                                .toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .cardColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          // ShaderMask(
                                          //   blendMode: BlendMode.srcIn,
                                          //   shaderCallback: (Rect bounds) => RadialGradient(
                                          //     center: Alignment.centerRight,
                                          //     stops: [0.8, 1],
                                          //     colors: [
                                          //       CustomTheme.of(context).bottomAppBarColor,
                                          //       CustomTheme.of(context).backgroundColor,
                                          //     ],
                                          //   ).createShader(bounds),
                                          //   child: Icon(
                                          //     Icons.arrow_forward_ios_rounded,
                                          //     color: Theme.of(context).backgroundColor,
                                          //     size: 18.0,
                                          //   ),
                                          // ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: CustomTheme.of(context)
                                                .primaryColor,
                                            size: 18.0,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    if (kycStatus == "0" || kycStatus == "3") {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const KYCPage()),
                                          )
                                          .then((val) =>
                                              val ? _getRequests() : null);
                                    } else if (kycStatus == "1") {
                                      CustomWidget(context: context)
                                          .showSuccessAlertDialog(
                                              "Verify KYC",
                                              "KYC Already Verified",
                                              "success");
                                    } else if (kycStatus == "2") {
                                      CustomWidget(context: context)
                                          .showSuccessAlertDialog(
                                              "Verify KYC",
                                              "Waiting for Admin Approval",
                                              "success");
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/sidemenu/security.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "KYC ",
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    16.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                          ),
                                        ],
                                      ),

                                      // ShaderMask(
                                      //   blendMode: BlendMode.srcIn,
                                      //   shaderCallback: (Rect bounds) => RadialGradient(
                                      //     center: Alignment.centerRight,
                                      //     stops: [0.8, 1],
                                      //     colors: [
                                      //       CustomTheme.of(context).bottomAppBarColor,
                                      //       CustomTheme.of(context).backgroundColor,
                                      //     ],
                                      //   ).createShader(bounds),
                                      //   child: Icon(
                                      //     Icons.arrow_forward,
                                      //     color: Theme.of(context).backgroundColor,
                                      //     size: 20.0,
                                      //   ),
                                      // ),

                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: CustomTheme.of(context)
                                            .primaryColor,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Divider(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                          builder: (_) => GoogleTFAScreen(
                                                code: userDetails!
                                                    .google2FaSecret
                                                    .toString(),
                                                type: userDetails!
                                                    .google2FaVerify
                                                    .toString(),
                                              )),
                                    )
                                        .then((val) {
                                      (val == true || val == null)
                                          ? _getRequests()
                                          : null;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child:
                                                // Icon(Icons.account_balance,   size: 20.0,     color: Theme.of(context).backgroundColor,) ),
                                                SvgPicture.asset(
                                              'assets/sidemenu/order.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Google Authenticator",
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    16.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            googleUpdate
                                                ? AppLocalizations.of(context)!
                                                    .translate("loc_disable")
                                                    .toString()
                                                : AppLocalizations.of(context)!
                                                    .translate("loc_enable")
                                                    .toString(),
                                            style:
                                                CustomWidget(context: context)
                                                    .CustomSizedTextStyle(
                                                        12.0,
                                                        Theme.of(context)
                                                            .cardColor
                                                            .withOpacity(0.5),
                                                        FontWeight.w400,
                                                        'FontRegular'),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          // ShaderMask(
                                          //   blendMode: BlendMode.srcIn,
                                          //   shaderCallback: (Rect bounds) => RadialGradient(
                                          //     center: Alignment.centerRight,
                                          //     stops: [0.8, 1],
                                          //     colors: [
                                          //       CustomTheme.of(context).bottomAppBarColor,
                                          //       CustomTheme.of(context).backgroundColor,
                                          //     ],
                                          //   ).createShader(bounds),
                                          //   child: Icon(
                                          //     Icons.arrow_forward_ios_rounded,
                                          //     color: Theme.of(context).backgroundColor,
                                          //     size: 18.0,
                                          //   ),
                                          // ),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: CustomTheme.of(context)
                                                .primaryColor,
                                            size: 18.0,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Divider(
                                  color: CustomTheme.of(context)
                                      .primaryColorDark
                                      .withOpacity(0.3),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(
                                      MaterialPageRoute(
                                          builder: (_) => Email_Verify(
                                                status: userDetails!.emailVerify
                                                    .toString(),
                                              )),
                                    )
                                        .then((val) {
                                      (val == true || val == null)
                                          ? _getRequests()
                                          : null;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(6.0),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              child: Icon(
                                                Icons.email,
                                                size: 20.0,
                                                color: Theme.of(context)
                                                    .primaryColorLight,
                                              )),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/settings.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_email_auth")
                                                .toString(),
                                            style: CustomWidget(
                                                    context: context)
                                                .CustomSizedTextStyle(
                                                    16.0,
                                                    Theme.of(context).cardColor,
                                                    FontWeight.w400,
                                                    'FontRegular'),
                                          ),
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: CustomTheme.of(context)
                                            .primaryColor,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 15.0,
                                bottom: 15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: CustomTheme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    _launchInWebView(Uri.parse(
                                        "https://discord.com/invite/c9zDHt62-Update"));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(0.2),
                                            ),
                                            child: const Icon(
                                              Icons.follow_the_signs,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/help.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("follow")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ShaderMask(
                                      //   blendMode: BlendMode.srcIn,
                                      //   shaderCallback: (Rect bounds) => RadialGradient(
                                      //     center: Alignment.centerRight,
                                      //     stops: [0.8, 1],
                                      //     colors: [
                                      //       CustomTheme.of(context).bottomAppBarColor,
                                      //       CustomTheme.of(context).backgroundColor,
                                      //     ],
                                      //   ).createShader(bounds),
                                      //   child: Icon(
                                      //     Icons.arrow_forward_ios_rounded,
                                      //     color: Theme.of(context).backgroundColor,
                                      //     size: 18.0,
                                      //   ),
                                      // ),

                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  // color: CustomTheme.of(context).shadowColor,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.3),
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     // Navigator.push(
                                //     //     context,
                                //     //     MaterialPageRoute(
                                //     //       builder: (context) => Referral_Screen(),
                                //     //     ));
                                //   },
                                //   child: Row(
                                //     mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Row(
                                //         children: [
                                //           Container(
                                //               padding: EdgeInsets.all(6.0),
                                //               decoration: BoxDecoration(
                                //                 shape: BoxShape.circle,
                                //                 color:
                                //                 Theme.of(context).bottomAppBarColor.withOpacity(0.3),
                                //               ),
                                //               child: Icon(
                                //                 Icons.wallet,
                                //                 size: 20.0,
                                //                 color: Theme.of(context)
                                //                     .bottomAppBarColor,
                                //               )),
                                //           // SvgPicture.asset(
                                //           //   'assets/sidemenu/help.svg',
                                //           //   height: 20.0,
                                //           //   color: Theme.of(context).backgroundColor,
                                //           // ),
                                //           const SizedBox(
                                //             width: 10.0,
                                //           ),
                                //           Text(
                                //             "Referral Information",
                                //             style: CustomWidget(context: context)
                                //                 .CustomSizedTextStyle(
                                //                 16.0,
                                //                 Theme.of(context).cardColor,
                                //                 FontWeight.normal,
                                //                 'FontRegular'),
                                //           ),
                                //         ],
                                //       ),
                                //       // ShaderMask(
                                //       //   blendMode: BlendMode.srcIn,
                                //       //   shaderCallback: (Rect bounds) => RadialGradient(
                                //       //     center: Alignment.centerRight,
                                //       //     stops: [0.8, 1],
                                //       //     colors: [
                                //       //       CustomTheme.of(context).bottomAppBarColor,
                                //       //       CustomTheme.of(context).backgroundColor,
                                //       //     ],
                                //       //   ).createShader(bounds),
                                //       //   child: Icon(
                                //       //     Icons.arrow_forward_ios_rounded,
                                //       //     color: Theme.of(context).backgroundColor,
                                //       //     size: 18.0,
                                //       //   ),
                                //       // ),
                                //
                                //       Icon(
                                //         Icons.arrow_forward_ios_rounded,
                                //         color: CustomTheme.of(context).cardColor,
                                //         size: 18.0,
                                //       )
                                //     ],
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                // Container(
                                //   height: 0.7,
                                //   width: MediaQuery.of(context).size.width,
                                //   // color: CustomTheme.of(context).shadowColor,
                                //   decoration: BoxDecoration(
                                //     gradient: LinearGradient(
                                //       begin: Alignment.bottomLeft,
                                //       end: Alignment.topRight,
                                //       colors: <Color>[
                                //         CustomTheme.of(context).backgroundColor.withOpacity(0.3),
                                //         CustomTheme.of(context).bottomAppBarColor,
                                //       ],
                                //       tileMode: TileMode.mirror,
                                //     ),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 10.0,
                                // ),
                                InkWell(
                                  onTap: () {
                                    _launchInWebView(Uri.parse(
                                        "https://discord.gg/9skDcYG8"));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => HelpCenter(),
                                    //     ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(0.2),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/sidemenu/help.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/help.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_help")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ShaderMask(
                                      //   blendMode: BlendMode.srcIn,
                                      //   shaderCallback: (Rect bounds) => RadialGradient(
                                      //     center: Alignment.centerRight,
                                      //     stops: [0.8, 1],
                                      //     colors: [
                                      //       CustomTheme.of(context).bottomAppBarColor,
                                      //       CustomTheme.of(context).backgroundColor,
                                      //     ],
                                      //   ).createShader(bounds),
                                      //   child: Icon(
                                      //     Icons.arrow_forward_ios_rounded,
                                      //     color: Theme.of(context).backgroundColor,
                                      //     size: 18.0,
                                      //   ),
                                      // ),

                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  // color: CustomTheme.of(context).shadowColor,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.3),
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    _launchInWebView(Uri.parse(
                                        "https://discord.com/invite/eNQpcd6r"));

                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           const SupportTicketList(),
                                    //     ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(0.2),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/sidemenu/group.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/support.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_cu_support")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // ShaderMask(
                                      //   blendMode: BlendMode.srcIn,
                                      //   shaderCallback: (Rect bounds) => RadialGradient(
                                      //     center: Alignment.centerRight,
                                      //     stops: [0.8, 1],
                                      //     colors: [
                                      //       CustomTheme.of(context).bottomAppBarColor,
                                      //       CustomTheme.of(context).backgroundColor,
                                      //     ],
                                      //   ).createShader(bounds),
                                      //   child: Icon(
                                      //     Icons.arrow_forward_ios_rounded,
                                      //     color: Theme.of(context).backgroundColor,
                                      //     size: 18.0,
                                      //   ),
                                      // ),

                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  height: 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  // color: CustomTheme.of(context).shadowColor,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight,
                                      colors: <Color>[
                                        CustomTheme.of(context)
                                            .primaryColorDark
                                            .withOpacity(0.3),
                                        CustomTheme.of(context)
                                            .primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      showSuccessDeactivate(
                                          AppLocalizations.of(context)!
                                              .translate("loc_deactive")
                                              .toString(),
                                          AppLocalizations.of(context)!
                                              .translate("loc_sure_deactive")
                                              .toString());
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .primaryColorLight
                                                  .withOpacity(0.2),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/logout.svg',
                                              height: 20.0,
                                              color: Theme.of(context)
                                                  .primaryColorLight,
                                            ),
                                          ),
                                          // SvgPicture.asset(
                                          //   'assets/sidemenu/help.svg',
                                          //   height: 20.0,
                                          //   color: Theme.of(context).backgroundColor,
                                          // ),
                                          const SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate("loc_deact_acc")
                                                .toString(),
                                            style: AppTextStyles.poppinsRegular(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: Colors.white,
                                        size: 18.0,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                          InkWell(
                            onTap: () {
                              showSuccessAlertDialog(
                                  AppLocalizations.of(context)!
                                      .translate("loc_logout")
                                      .toString(),
                                  AppLocalizations.of(context)!
                                      .translate("loc_sure_logout")
                                      .toString());
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: CustomTheme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate("loc_logout")
                                    .toString(),
                                style: AppTextStyles.poppinsRegular(
                                  color: Colors.white,
                                ),
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
                  loading
                      ? CustomWidget(context: context).loadingIndicator(
                          CustomTheme.of(context).primaryColor,
                        )
                      : Container()
                ],
              )),
        ));
  }

  showSuccessAlertDialog(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              17.0,
                              CustomTheme.of(context).cardColor,
                              FontWeight.w600,
                              'FontRegular'),
                      // colors: [
                      //   CustomTheme.of(context).disabledColor,
                      //   CustomTheme.of(context).primaryColorLight,
                      // ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(true);
                              setState(() {
                                callLogout();
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_okay")
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2)),
                          height: 40.0,
                          width: 1.5,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_cancel")
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  showSuccessDeactivate(String title, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)), //this right here
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              height: MediaQuery.of(context).size.height * 0.22,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(17.0, Colors.black,
                              FontWeight.w600, 'FontRegular'),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'OpenSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                   const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(true);
                              setState(() {
                                getUserDeactivate();
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_okay")
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 17.0,
                                color:Colors.black,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration:  BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          height: 40.0,
                          width: 0.5,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_cancel")
                                  .toString(),
                              style: TextStyle(
                                fontSize: 17.0,
                                color: CustomTheme.of(context)
                                    .dialogBackgroundColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'OpenSans',
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
    // show the dialog
  }

  Future callLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        // TODO:SET MYMAP
        builder: (BuildContext context) => const Login_Screen(),
      ),
      (Route route) => false,
    );
  }

  getUserDetails() {
    apiUtils.getUserDetails().then((UserDetailsModel loginData) {
      if (loginData.success!) {
        debugPrint("User Details ${loginData.result}");

        setState(() {
          loading = false;
          name = "${loginData.result!.firstName} ${loginData.result!.lastName}";
          email = loginData.result!.email.toString();
          kycStatus = loginData.result!.kycVerify.toString();
          userDetails = loginData.result;
          // googleUpdate=loginData.result!.google2FaSecret!;
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

  Future<void> _launchInWebView(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  getUserDeactivate() {
    apiUtils.getDeactAccount().then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() async {
          loading = false;
          callLogout();
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
