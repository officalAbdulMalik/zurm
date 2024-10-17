import 'dart:io';

import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/common/textformfield_custom.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/login_model.dart';
import 'package:zurumi/screens/basic/home.dart';
import 'package:zurumi/screens/basic/register_success.dart';
import 'package:zurumi/screens/basic/sign_uo_screen.dart';
import '../../common/country.dart';
import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/theme/custom_theme.dart';
import 'forgot_password.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({Key? key}) : super(key: key);

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen>
    with TickerProviderStateMixin {
  bool signin = false;
  bool email = false;
  FocusNode emailFocus = FocusNode();
  FocusNode signupEmailFocus = FocusNode();
  FocusNode fnameFocus = FocusNode();
  FocusNode refCodeFocus = FocusNode();
  FocusNode lnameFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode signupPasswordFocus = FocusNode();
  FocusNode conPassFocus = FocusNode();
  bool passVisible = false;
  bool conpassVisible = false;
  Country? _selectedCountry;
  bool countryB = false;
  FocusNode mobileFocus = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController conPasswordController = TextEditingController();
  TextEditingController refCodeController = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final regformKey = GlobalKey<FormState>();
  final loginformKey = GlobalKey<FormState>();
  bool loading = false;
  APIUtils apiUtils = APIUtils();
  String emailValue = "1";
  String ip = "";

  var deviceData;
  String? _currentAddress;
  Position? _currentPosition;

  int count = 0;

  final LocalAuthentication auth = LocalAuthentication();
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signin = true;
    email = true;
    // loading=true;
    //  emailController=TextEditingController(text: "guzuludeva.alpharive@gmail.com");
    // passwordController=TextEditingController(text: "Seasaw18!");
    // emailController = TextEditingController(text: "bello.coder@gmail.com");
    // passwordController = TextEditingController(text: "Badman116");
    getData();
    initCountry();
    getDeviceInfo();
    _initNetworkInfo();
    // _getCurrentPosition();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;

      _getAvailableBiometrics();
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();

      _authenticateWithBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: AppLocalizations.of(context)!
            .translate("loc_finger_input")
            .toString(),
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print(authenticated);
      print("Cancel : $authenticated $count");
      if (authenticated) {
        setState(() {
          verifyFinger();
          loading = true;
        });
      } else {
        // setState(() {
        //   count = count + 1;
        //   if (count > 2) {
        //     _authenticateWithBiometrics();
        //   }
        // });
      }

      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
      if (count > 1) {
        _authenticateWithBiometrics();
      }
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  getDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      setState(() {
        print(deviceData['device_id'].toString());
      });
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      setState(() {});
    }
  }

  // Future<void> _getCurrentPosition() async {
  //   final hasPermission = await _handleLocationPermission();
  //   if (!hasPermission) return;
  //   await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high)
  //       .then((Position position) {
  //  setState(() {
  //    _currentPosition = position;
  //    getUserLocation();
  //  });
  //   }).catchError((e) {
  //     debugPrint(e);
  //   });
  // }

  getUserLocation() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude);
    Placemark place = placemarks[0];

    setState(() {
      loading = false;
      _currentAddress = place.street.toString() +
          "," +
          place.country.toString() +
          "," +
          place.postalCode.toString();
    });
  }

  // Future<bool> _handleLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //     //     content: Text('Location services are disabled. Please enable the services')));
  //     return false;
  //   }
  //   // permission = await Geolocator.checkPermission();
  //   // if (permission == LocationPermission.denied) {
  //   //   permission = await Geolocator.requestPermission();
  //   //   if (permission == LocationPermission.denied) {
  //   //     // ScaffoldMessenger.of(context).showSnackBar(
  //   //     //     const SnackBar(content: Text('Location permissions are denied')));
  //   //     return false;
  //   //   }
  //   }
  // if (permission == LocationPermission.deniedForever) {
  //   // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //   //     content: Text('Location permissions are permanently denied, we cannot request permissions.')));
  //   return false;
  // }
  // return true;
  // }
  Future<void> _initNetworkInfo() async {
    String? wifiName,
        wifiBSSID,
        wifiIPv4,
        wifiIPv6,
        wifiGatewayIP,
        wifiBroadcast,
        wifiSubmask;

    try {
      wifiIPv4 = await NetworkInfo().getWifiIP();
    } on PlatformException catch (e) {
      wifiIPv4 = 'Failed to get Wifi IPv4';
    }

    setState(() {
      // ip = 'Wifi Name: $wifiName\n'
      //     'Wifi BSSID: $wifiBSSID\n'
      //     'Wifi IPv4: $wifiIPv4\n'
      //     'Wifi IPv6: $wifiIPv6\n'
      //     'Wifi Broadcast: $wifiBroadcast\n'
      //     'Wifi Gateway: $wifiGatewayIP\n'
      //     'Wifi Submask: $wifiSubmask\n';

      ip = wifiIPv4.toString();
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'os_version': build.version.release,
      'device_model': build.model,
      'device_id': build.id,
      'deviceos_type': 'android',
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'os_version': data.systemName! + " " + data.systemVersion!,
      'device_model': data.name,
      'deviceos_type': data.systemName,
      'device_id': data.identifierForVendor
    };
  }

  getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emailValue = preferences.getString("emailZurumi").toString();
  }

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
  }

  void _onPressedShowBottomSheet() async {
    final country = await showCountryPickerSheets(
      context,
    );
    if (country != null) {
      setState(() {
        _selectedCountry = country;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColorDark,
      appBar: AppBar(
        backgroundColor: CustomTheme.of(context).primaryColorDark,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              CustomTheme.of(context).primaryColorDark, // For iOS: (dark icons)
          statusBarIconBrightness:
              Brightness.light, // For Android: (dark icons)
        ),
        elevation: 0.0,
        // toolbarHeight: 0.0,
        // leading: Padding(
        //     padding: EdgeInsets.only(left: 0.0, top: 5.0, bottom: 5.0),
        //     child: InkWell(
        //       onTap: () {
        //         // Navigator.push(context,MaterialPageRoute(builder:(context)=> Home_Screen()));
        //         Navigator.pop(context);
        //       },
        //       child: Center(
        //         child: Icon(
        //           Icons.close,
        //           color: CustomTheme.of(context).dialogBackgroundColor.withOpacity(0.4),
        //           size: 30.0,
        //         ),
        //       ),
        //     )),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: <Color>[
          //     CustomTheme.of(context).primaryColor,
          //     CustomTheme.of(context).primaryColor,
          //     CustomTheme.of(context).primaryColor,
          //     // CustomTheme.of(context).backgroundColor.withOpacity(0.4),
          //   ],
          //   tileMode: TileMode.mirror,
          // ),
          color: CustomTheme.of(context).primaryColorDark,
        ),
        child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, bottom: 10.0, top: 10.0),
            child: Stack(
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     // Container(
                //     //   padding: EdgeInsets.all(5.0),
                //     //   decoration: BoxDecoration(
                //     //     // gradient: LinearGradient(
                //     //     //   begin: Alignment.centerLeft,
                //     //     //   end: Alignment.centerRight,
                //     //     //   colors: <Color>[
                //     //     //     CustomTheme.of(context).primaryColorLight,
                //     //     //     CustomTheme.of(context).primaryColorDark,
                //     //     //   ],
                //     //     //   tileMode: TileMode.mirror,
                //     //     // ),
                //     //     borderRadius: BorderRadius.circular(15.0),
                //     //     color: CustomTheme.of(context).canvasColor,
                //     //   ),
                //     //   child: Row(
                //     //     crossAxisAlignment: CrossAxisAlignment.center,
                //     //     children: [
                //     //       Flexible(
                //     //           child: InkWell(
                //     //         onTap: () {
                //     //           setState(() {
                //     //             signin = true;
                //     //           });
                //     //         },
                //     //         child: Container(
                //     //           padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                //     //           alignment: Alignment.center,
                //     //           width: MediaQuery.of(context).size.width,
                //     //           decoration: signin
                //     //               ? BoxDecoration(
                //     //                   borderRadius: BorderRadius.circular(25.0),
                //     //                   color:
                //     //                       CustomTheme.of(context).primaryColor,
                //     //                 )
                //     //               : BoxDecoration(),
                //     //           child: Text(
                //     //             AppLocalizations.of(context)!
                //     //                 .translate("loc_sign_in")
                //     //                 .toString(),
                //     //             style: CustomWidget(context: context)
                //     //                 .CustomSizedTextStyle(
                //     //                     13.0,
                //     //                     signin
                //     //                         ? CustomTheme.of(context).cardColor
                //     //                         : CustomTheme.of(context)
                //     //                             .focusColor,
                //     //                     FontWeight.w500,
                //     //                     'FontRegular'),
                //     //           ),
                //     //         ),
                //     //       )),
                //     //       Flexible(
                //     //         child: InkWell(
                //     //           onTap: () {
                //     //             setState(() {
                //     //               signin = false;
                //     //             });
                //     //           },
                //     //           child: Container(
                //     //             padding:
                //     //                 EdgeInsets.only(top: 10.0, bottom: 10.0),
                //     //             alignment: Alignment.center,
                //     //             width: MediaQuery.of(context).size.width,
                //     //             decoration: signin
                //     //                 ? BoxDecoration()
                //     //                 : BoxDecoration(
                //     //                     borderRadius:
                //     //                         BorderRadius.circular(25.0),
                //     //                     color: CustomTheme.of(context)
                //     //                         .primaryColor,
                //     //                   ),
                //     //             child: Text(
                //     //               AppLocalizations.of(context)!
                //     //                   .translate("loc_sign_up")
                //     //                   .toString(),
                //     //               style: CustomWidget(context: context)
                //     //                   .CustomSizedTextStyle(
                //     //                       13.0,
                //     //                       signin
                //     //                           ? CustomTheme.of(context)
                //     //                               .focusColor
                //     //                           : CustomTheme.of(context)
                //     //                               .cardColor,
                //     //                       FontWeight.w500,
                //     //                       'FontRegular'),
                //     //             ),
                //     //           ),
                //     //         ),
                //     //       )
                //     //     ],
                //     //   ),
                //     // ),
                //     // const SizedBox(
                //     //   height: 45.0,
                //     // ),
                //     Image.asset("assets/images/logo.png",
                //         height: 120.0, width: 120.0, fit: BoxFit.contain),
                //     const SizedBox(
                //       height: 30.0,
                //     ),
                //     Text(
                //       signin
                //           ? AppLocalizations.of(context)!
                //               .translate("loc_wel")
                //               .toString()
                //           : AppLocalizations.of(context)!
                //               .translate("loc_sign_up")
                //               .toString(),
                //       style: CustomWidget(context: context)
                //           .CustomSizedTextStyle(
                //               28.0,
                //               CustomTheme.of(context).focusColor,
                //               FontWeight.w600,
                //               'FontRegular'),
                //       textAlign: TextAlign.center,
                //     ),
                //     const SizedBox(
                //       height: 30.0,
                //     ),
                //   ],
                // ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: SingleChildScrollView(
                    child: SignInUI(),
                  ),
                ),
                loading
                    ? CustomWidget(context: context).loadingIndicator(
                        CustomTheme.of(context).primaryColor,
                      )
                    : Container()
              ],
            )),
      ),
    );
  }

  Widget SignInUI() {
    return Container(
      child: Form(
        key: loginformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",
                height: 120.0, width: 120.0, fit: BoxFit.contain),
            const SizedBox(
              height: 30.0,
            ),
            Text(
              signin
                  ? AppLocalizations.of(context)!
                      .translate("loc_wel")
                      .toString()
                  : AppLocalizations.of(context)!
                      .translate("loc_sign_up")
                      .toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  22.0,
                  CustomTheme.of(context).focusColor,
                  FontWeight.w600,
                  'FontRegular'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              AppLocalizations.of(context)!
                  .translate("loc_email_up")
                  .toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(
                  14.0,
                  CustomTheme.of(context).focusColor,
                  FontWeight.w400,
                  'FontRegular'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 15.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  email
                      ? AppLocalizations.of(context)!
                          .translate("loc_email")
                          .toString()
                      : AppLocalizations.of(context)!
                          .translate("loc_mobile")
                          .toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      CustomTheme.of(context).dividerColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),

                // GestureDetector(
                //   onTap: (){
                //     setState(() {
                //       if(email ==true) {
                //         email = false;
                //         emailController.clear();
                //       }
                //       else {
                //         email = true;
                //         mobileController.clear();
                //       }
                //     });
                //   },
                //   child: GradientText(
                //     email? "Sign in with mobile": "Sign in with Email"  ,
                //     style: CustomWidget(context: context)
                //         .CustomSizedTextStyle(
                //         13.0,
                //         CustomTheme.of(context).cardColor,
                //         FontWeight.w500,
                //         'FontRegular'),
                //     colors: [
                //       CustomTheme.of(context).backgroundColor,
                //       CustomTheme.of(context).bottomAppBarColor,
                //     ],
                //   ),
                // ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            email
                ? TextFormFieldCustom(
                    onEditComplete: () {
                      emailFocus.unfocus();
                      FocusScope.of(context).requestFocus(passFocus);
                    },
                    radius: 8.0,
                    error: AppLocalizations.of(context)!
                        .translate("loc_email_enter")
                        .toString(),
                    textColor: CustomTheme.of(context).cardColor,
                    borderColor: Colors.transparent,
                    fillColor:
                        CustomTheme.of(context).canvasColor.withOpacity(0.2),
                    hintStyle: CustomWidget(context: context)
                        .CustomSizedTextStyle(
                            15.0,
                            CustomTheme.of(context).dividerColor,
                            FontWeight.w400,
                            'FontRegular'),
                    textStyle: CustomWidget(context: context).CustomTextStyle(
                        CustomTheme.of(context).cardColor,
                        FontWeight.w500,
                        'FontRegular'),
                    textInputAction: TextInputAction.next,
                    focusNode: emailFocus,
                    maxlines: 1,
                    text: '',
                    hintText: AppLocalizations.of(context)!
                        .translate("loc_email_hint")
                        .toString(),
                    obscureText: false,
                    suffix: Container(
                      width: 0.0,
                    ),
                    textChanged: (value) {},
                    onChanged: () {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter email";
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    enabled: true,
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: CustomTheme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.only(left: 1.0, right: 3.0, top: 1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 7.0, right: 10.0, top: 14.0, bottom: 14.0),
                          decoration: BoxDecoration(
                            color: CustomTheme.of(context).canvasColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: _onPressedShowBottomSheet,
                                child: Row(
                                  children: [
                                    countryB
                                        ? Image.asset(
                                            _selectedCountry!.flag.toString(),
                                            package:
                                                AppLocalizations.of(context)!
                                                    .translate("loc_cnty_code"),
                                            height: 20.0,
                                            width: 25.0,
                                          )
                                        : Container(
                                            width: 0.0,
                                          ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Text(
                                      countryB
                                          ? _selectedCountry!.callingCode
                                              .toString()
                                          : "+1",
                                      style: TextStyle(
                                          color: CustomTheme.of(context)
                                              .dividerColor,
                                          fontFamily: 'UberMove',
                                          fontSize: 16.0),
                                    ),
                                    const SizedBox(
                                      width: 3.0,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      size: 15.0,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Container(
                                height: 20.0,
                                width: 1.0,
                                color: CustomTheme.of(context).dividerColor,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Flexible(
                            flex: 1,
                            child: TextFormField(
                              onEditingComplete: () {
                                mobileFocus.unfocus();
                              },
                              controller: mobileController,
                              maxLength: 15,
                              focusNode: mobileFocus,
                              enabled: true,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                              decoration: InputDecoration(
                                counterText: ""
                                    "",
                                contentPadding: const EdgeInsets.only(
                                    left: 12, right: 0, top: 2, bottom: 2),
                                hintText: "456 321 7896",
                                hintStyle: TextStyle(
                                    color: CustomTheme.of(context).dividerColor,
                                    fontFamily: 'UberMoveLight',
                                    fontSize: 16.0),
                                border: InputBorder.none,
                                fillColor: CustomTheme.of(context)
                                    .canvasColor
                                    .withOpacity(0.2),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            const SizedBox(
              height: 30.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!
                    .translate("loc_password")
                    .toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    CustomTheme.of(context).dividerColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextFormFieldCustom(
              obscureText: !passVisible,
              textInputAction: TextInputAction.next,
              textColor: CustomTheme.of(context).cardColor,
              borderColor: Colors.transparent,
              fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                  15.0,
                  CustomTheme.of(context).dividerColor,
                  FontWeight.w400,
                  'FontRegular'),
              textStyle: CustomWidget(context: context).CustomTextStyle(
                  CustomTheme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
              radius: 8.0,
              focusNode: passFocus,
              suffix: IconButton(
                icon: Icon(
                  passVisible ? Icons.visibility : Icons.visibility_off,
                  color: CustomTheme.of(context).dividerColor,
                ),
                onPressed: () {
                  setState(() {
                    passVisible = !passVisible;
                  });
                },
              ),
              controller: passwordController,
              enabled: true,
              onChanged: () {},
              hintText: AppLocalizations.of(context)!
                  .translate("loc_pass_hint")
                  .toString(),
              textChanged: (value) {},
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter Password";
                }

                return null;
              },
              maxlines: 1,
              error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
              text: "",
              onEditComplete: () {
                passFocus.unfocus();
              },
              textInputType: TextInputType.visiblePassword,
            ),
            const SizedBox(
              height: 8.0,
            ),
            signin
                ? GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                    },
                    child: GradientText(
                      AppLocalizations.of(context)!
                          .translate("loc_forgot_password")
                          .toString(),
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              13.0,
                              CustomTheme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                      colors: const [
                        Color(0xFF00A7FF),
                        Color(0xFF00A7FF),
                      ],
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 30.0,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (loginformKey.currentState!.validate()) {
                    loading = true;
                    verifyMail();
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      CustomTheme.of(context).primaryColor,
                      CustomTheme.of(context).primaryColor,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  AppLocalizations.of(context)!
                      .translate("loc_sign_in")
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
            signin
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            signin = true;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_dont_acc")
                              .toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  CustomTheme.of(context).focusColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return const SignUpScreen();
                          },));
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_sign_up")
                              .toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  CustomTheme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            signin = false;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_new_user")
                              .toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  CustomTheme.of(context).focusColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            signin = false;
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("loc_get_start")
                              .toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(
                                  13.0,
                                  CustomTheme.of(context).primaryColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20.0,
            ),
            emailValue == "1" || emailValue == "null" || emailValue == null
                ? Container()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        _authenticateWithBiometrics();
                      });
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(
                                color:
                                    CustomTheme.of(context).primaryColorLight,
                                width: 1.50)),
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint_outlined,
                              size: 25.0,
                              color: CustomTheme.of(context).primaryColorLight,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("loc_finger_print")
                                  .toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      16.0,
                                      CustomTheme.of(context).primaryColorLight,
                                      FontWeight.w500,
                                      'FontRegular'),
                            ),
                          ],
                        )),
                  ),
          ],
        ),
      ),
    );
  }

  // Widget SignUpUI() {
  //   return Container(
  //     child: Form(
  //       key: regformKey,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const SizedBox(
  //             height: 10.0,
  //           ),
  //           Text(
  //             AppLocalizations.of(context)!
  //                 .translate("loc_first_name")
  //                 .toString(),
  //             style: CustomWidget(context: context).CustomSizedTextStyle(
  //                 13.0,
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           TextFormFieldCustom(
  //             onEditComplete: () {
  //               fnameFocus.unfocus();
  //               FocusScope.of(context).requestFocus(lnameFocus);
  //             },
  //             radius: 8.0,
  //             error: AppLocalizations.of(context)!
  //                 .translate("loc_name_hint")
  //                 .toString(),
  //             textColor: CustomTheme.of(context).cardColor,
  //             borderColor: Colors.transparent,
  //             fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //             hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
  //                 15.0,
  //                 CustomTheme.of(context).dividerColor,
  //                 FontWeight.w400,
  //                 'FontRegular'),
  //             textStyle: CustomWidget(context: context).CustomTextStyle(
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //             textInputAction: TextInputAction.next,
  //             focusNode: fnameFocus,
  //             maxlines: 1,
  //             text: '',
  //             hintText: AppLocalizations.of(context)!
  //                 .translate("loc_name_hnt")
  //                 .toString(),
  //             obscureText: false,
  //             suffix: Container(
  //               width: 0.0,
  //             ),
  //             textChanged: (value) {},
  //             onChanged: () {},
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "Please enter First Name";
  //               }
  //               return null;
  //             },
  //             enabled: true,
  //             textInputType: TextInputType.name,
  //             controller: fnameController,
  //           ),
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           Text(
  //             AppLocalizations.of(context)!
  //                 .translate("loc_last_name")
  //                 .toString(),
  //             style: CustomWidget(context: context).CustomSizedTextStyle(
  //                 13.0,
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           TextFormFieldCustom(
  //             onEditComplete: () {
  //               lnameFocus.unfocus();
  //               FocusScope.of(context).requestFocus(emailFocus);
  //             },
  //             radius: 8.0,
  //             error: AppLocalizations.of(context)!
  //                 .translate("loc_lname_hint")
  //                 .toString(),
  //             textColor: CustomTheme.of(context).cardColor,
  //             borderColor: Colors.transparent,
  //             fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //             hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
  //                 15.0,
  //                 CustomTheme.of(context).dividerColor,
  //                 FontWeight.w400,
  //                 'FontRegular'),
  //             textStyle: CustomWidget(context: context).CustomTextStyle(
  //                 Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
  //             textInputAction: TextInputAction.next,
  //             focusNode: emailFocus,
  //             maxlines: 1,
  //             text: '',
  //             hintText: AppLocalizations.of(context)!
  //                 .translate("loc_lname_hnt")
  //                 .toString(),
  //             obscureText: false,
  //             suffix: Container(
  //               width: 0.0,
  //             ),
  //             textChanged: (value) {},
  //             onChanged: () {},
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "Please enter Last Name";
  //               }
  //               return null;
  //             },
  //             enabled: true,
  //             textInputType: TextInputType.name,
  //             controller: lnameController,
  //           ),
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 email
  //                     ? AppLocalizations.of(context)!
  //                         .translate("loc_email")
  //                         .toString()
  //                     : AppLocalizations.of(context)!
  //                         .translate("loc_mobile")
  //                         .toString(),
  //                 style: CustomWidget(context: context).CustomSizedTextStyle(
  //                     13.0,
  //                     CustomTheme.of(context).cardColor,
  //                     FontWeight.w500,
  //                     'FontRegular'),
  //               ),
  //
  //               // GestureDetector(
  //               //   onTap: (){
  //               //     setState(() {
  //               //       if(email ==true) {
  //               //         email = false;
  //               //         emailController.clear();
  //               //       }
  //               //       else {
  //               //         email = true;
  //               //         mobileController.clear();
  //               //       }
  //               //     });
  //               //   },
  //               //   child: GradientText(
  //               //     email? "Sign in with mobile": "Sign in with Email"  ,
  //               //     style: CustomWidget(context: context)
  //               //         .CustomSizedTextStyle(
  //               //         13.0,
  //               //         CustomTheme.of(context).cardColor,
  //               //         FontWeight.w500,
  //               //         'FontRegular'),
  //               //     colors: [
  //               //       CustomTheme.of(context).backgroundColor,
  //               //       CustomTheme.of(context).bottomAppBarColor,
  //               //     ],
  //               //   ),
  //               // ),
  //             ],
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           email
  //               ? TextFormFieldCustom(
  //                   onEditComplete: () {
  //                     signupEmailFocus.unfocus();
  //                     FocusScope.of(context).requestFocus(signupPasswordFocus);
  //                   },
  //                   radius: 8.0,
  //                   error: AppLocalizations.of(context)!
  //                       .translate("loc_email_enter"),
  //                   textColor: CustomTheme.of(context).cardColor,
  //                   borderColor: Colors.transparent,
  //                   fillColor:
  //                       CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //                   hintStyle: CustomWidget(context: context)
  //                       .CustomSizedTextStyle(
  //                           15.0,
  //                           CustomTheme.of(context).dividerColor,
  //                           FontWeight.w400,
  //                           'FontRegular'),
  //                   textStyle: CustomWidget(context: context).CustomTextStyle(
  //                       CustomTheme.of(context).cardColor,
  //                       FontWeight.w500,
  //                       'FontRegular'),
  //                   textInputAction: TextInputAction.next,
  //                   focusNode: signupEmailFocus,
  //                   maxlines: 1,
  //                   text: '',
  //                   hintText: AppLocalizations.of(context)!
  //                       .translate("loc_email_hint")
  //                       .toString(),
  //                   obscureText: false,
  //                   suffix: Container(
  //                     width: 0.0,
  //                   ),
  //                   textChanged: (value) {},
  //                   onChanged: () {},
  //                   validator: (value) {
  //                     if (value!.isEmpty) {
  //                       return "Please enter Email";
  //                     } else if (!RegExp(
  //                             r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //                         .hasMatch(value)) {
  //                       return "Please enter valid Email";
  //                     }
  //                     return null;
  //                   },
  //                   enabled: true,
  //                   textInputType: TextInputType.emailAddress,
  //                   controller: signupEmailController,
  //                 )
  //               : Container(
  //                   width: MediaQuery.of(context).size.width,
  //                   decoration: BoxDecoration(
  //                     color: CustomTheme.of(context).canvasColor,
  //                     borderRadius: BorderRadius.circular(8.0),
  //                   ),
  //                   padding: EdgeInsets.only(left: 1.0, right: 3.0, top: 1.0),
  //                   child: Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.only(
  //                             left: 7.0, right: 10.0, top: 14.0, bottom: 14.0),
  //                         decoration: BoxDecoration(
  //                           color: CustomTheme.of(context).canvasColor,
  //                           borderRadius: BorderRadius.only(
  //                             topLeft: Radius.circular(5.0),
  //                             bottomLeft: Radius.circular(5.0),
  //                           ),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             InkWell(
  //                               onTap: _onPressedShowBottomSheet,
  //                               child: Row(
  //                                 children: [
  //                                   countryB
  //                                       ? Image.asset(
  //                                           _selectedCountry!.flag.toString(),
  //                                           package:
  //                                               "country_calling_code_picker",
  //                                           height: 20.0,
  //                                           width: 25.0,
  //                                         )
  //                                       : Container(
  //                                           width: 0.0,
  //                                         ),
  //                                   const SizedBox(
  //                                     width: 5.0,
  //                                   ),
  //                                   Text(
  //                                     countryB
  //                                         ? _selectedCountry!.callingCode
  //                                             .toString()
  //                                         : "+1",
  //                                     style: TextStyle(
  //                                         color: CustomTheme.of(context)
  //                                             .dividerColor,
  //                                         fontFamily: 'UberMove',
  //                                         fontSize: 16.0),
  //                                   ),
  //                                   const SizedBox(
  //                                     width: 3.0,
  //                                   ),
  //                                   const Icon(
  //                                     Icons.keyboard_arrow_down_outlined,
  //                                     size: 15.0,
  //                                     color: Colors.white,
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                             const SizedBox(
  //                               width: 10.0,
  //                             ),
  //                             Container(
  //                               height: 20.0,
  //                               width: 1.0,
  //                               color: CustomTheme.of(context).dividerColor,
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                       Container(
  //                         child: Flexible(
  //                           flex: 1,
  //                           child: TextFormField(
  //                             onEditingComplete: () {
  //                               mobileFocus.unfocus();
  //                             },
  //                             controller: mobileController,
  //                             maxLength: 15,
  //                             focusNode: mobileFocus,
  //                             enabled: true,
  //                             textInputAction: TextInputAction.next,
  //                             keyboardType: TextInputType.number,
  //                             style: CustomWidget(context: context)
  //                                 .CustomSizedTextStyle(
  //                                     16.0,
  //                                     CustomTheme.of(context).primaryColor,
  //                                     FontWeight.w400,
  //                                     'FontRegular'),
  //                             decoration: InputDecoration(
  //                               counterText: ""
  //                                   "",
  //                               contentPadding: const EdgeInsets.only(
  //                                   left: 12, right: 0, top: 2, bottom: 2),
  //                               hintText: "456 321 7896",
  //                               hintStyle: TextStyle(
  //                                   color: CustomTheme.of(context).dividerColor,
  //                                   fontFamily: 'UberMoveLight',
  //                                   fontSize: 16.0),
  //                               border: InputBorder.none,
  //                               fillColor: CustomTheme.of(context)
  //                                   .canvasColor
  //                                   .withOpacity(0.2),
  //                               enabledBorder: InputBorder.none,
  //                               focusedBorder: InputBorder.none,
  //                               errorBorder: InputBorder.none,
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           Text(
  //             AppLocalizations.of(context)!
  //                 .translate("loc_password")
  //                 .toString(),
  //             style: CustomWidget(context: context).CustomSizedTextStyle(
  //                 13.0,
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           TextFormFieldCustom(
  //             obscureText: !passVisible,
  //             textInputAction: TextInputAction.next,
  //             textColor: CustomTheme.of(context).cardColor,
  //             borderColor: Colors.transparent,
  //             fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //             hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
  //                 15.0,
  //                 CustomTheme.of(context).dividerColor,
  //                 FontWeight.w400,
  //                 'FontRegular'),
  //             textStyle: CustomWidget(context: context).CustomTextStyle(
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //             radius: 8.0,
  //             focusNode: signupPasswordFocus,
  //             suffix: IconButton(
  //               icon: Icon(
  //                 passVisible ? Icons.visibility : Icons.visibility_off,
  //                 color: CustomTheme.of(context).dividerColor,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   passVisible = !passVisible;
  //                 });
  //               },
  //             ),
  //             controller: signupPasswordController,
  //             enabled: true,
  //             onChanged: () {},
  //             hintText: AppLocalizations.of(context)!
  //                 .translate("loc_pass_hint")
  //                 .toString(),
  //             textChanged: (value) {},
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "Please enter Password";
  //               }
  //
  //               return null;
  //             },
  //             maxlines: 1,
  //             error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
  //             text: "",
  //             onEditComplete: () {
  //               signupPasswordFocus.unfocus();
  //             },
  //             textInputType: TextInputType.visiblePassword,
  //           ),
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           Text(
  //             AppLocalizations.of(context)!
  //                 .translate("loc_conf_password")
  //                 .toString(),
  //             style: CustomWidget(context: context).CustomSizedTextStyle(
  //                 13.0,
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           TextFormFieldCustom(
  //             obscureText: !conpassVisible,
  //             textInputAction: TextInputAction.next,
  //             textColor: CustomTheme.of(context).cardColor,
  //             borderColor: Colors.transparent,
  //             fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //             hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
  //                 15.0,
  //                 CustomTheme.of(context).dividerColor,
  //                 FontWeight.w400,
  //                 'FontRegular'),
  //             textStyle: CustomWidget(context: context).CustomTextStyle(
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //             radius: 8.0,
  //             focusNode: conPassFocus,
  //             suffix: IconButton(
  //               icon: Icon(
  //                 conpassVisible ? Icons.visibility : Icons.visibility_off,
  //                 color: CustomTheme.of(context).dividerColor,
  //               ),
  //               onPressed: () {
  //                 setState(() {
  //                   conpassVisible = !conpassVisible;
  //                 });
  //               },
  //             ),
  //             controller: conPasswordController,
  //             enabled: true,
  //             onChanged: () {},
  //             hintText: AppLocalizations.of(context)!
  //                 .translate("loc_pass_hint")
  //                 .toString(),
  //             textChanged: (value) {},
  //             validator: (value) {
  //               if (value!.isEmpty) {
  //                 return "Please enter Confirm Password";
  //               }
  //
  //               return null;
  //             },
  //             maxlines: 1,
  //             error: AppLocalizations.of(context)!.translate("loc_valid_pass"),
  //             text: "",
  //             onEditComplete: () {
  //               conPassFocus.unfocus();
  //             },
  //             textInputType: TextInputType.visiblePassword,
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           const SizedBox(
  //             height: 20.0,
  //           ),
  //           Text(
  //             AppLocalizations.of(context)!
  //                 .translate("loc_referral")
  //                 .toString(),
  //             style: CustomWidget(context: context).CustomSizedTextStyle(
  //                 13.0,
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           TextFormFieldCustom(
  //             obscureText: false,
  //             textInputAction: TextInputAction.next,
  //             textColor: CustomTheme.of(context).cardColor,
  //             borderColor: Colors.transparent,
  //             fillColor: CustomTheme.of(context).canvasColor.withOpacity(0.2),
  //             hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
  //                 15.0,
  //                 CustomTheme.of(context).dividerColor,
  //                 FontWeight.w400,
  //                 'FontRegular'),
  //             textStyle: CustomWidget(context: context).CustomTextStyle(
  //                 CustomTheme.of(context).cardColor,
  //                 FontWeight.w500,
  //                 'FontRegular'),
  //             radius: 8.0,
  //             focusNode: refCodeFocus,
  //             suffix: IconButton(
  //               icon: Icon(
  //                 Icons.paste_outlined,
  //                 color: CustomTheme.of(context).dividerColor,
  //               ),
  //               onPressed: () {
  //                 setState(() {});
  //               },
  //             ),
  //             controller: refCodeController,
  //             enabled: true,
  //             onChanged: () {},
  //             hintText: AppLocalizations.of(context)!
  //                 .translate("loc_ref_code")
  //                 .toString(),
  //             textChanged: (value) {},
  //             validator: (value) {
  //               return null;
  //             },
  //             maxlines: 1,
  //             error:
  //                 AppLocalizations.of(context)!.translate("loc_valid_ref_code"),
  //             text: "",
  //             onEditComplete: () {
  //               refCodeFocus.unfocus();
  //             },
  //             textInputType: TextInputType.number,
  //           ),
  //           const SizedBox(
  //             height: 8.0,
  //           ),
  //           // GradientText(
  //           //   AppLocalizations.of(context)!.translate("loc_forgot_password"),
  //           //   style: CustomWidget(context: context)
  //           //       .CustomSizedTextStyle(
  //           //       13.0,
  //           //       CustomTheme.of(context).cardColor,
  //           //       FontWeight.w500,
  //           //       'FontRegular'),
  //           //   colors: [
  //           //     CustomTheme.of(context).backgroundColor,
  //           //     CustomTheme.of(context).bottomAppBarColor,
  //           //   ],
  //           // ),
  //           const SizedBox(
  //             height: 30.0,
  //           ),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               InkWell(
  //                 onTap: () {
  //                   setState(() {
  //                     if (regformKey.currentState!.validate()) {
  //                       loading = true;
  //                       registerMail();
  //                     }
  //                   });
  //                 },
  //                 child: Container(
  //                   padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     gradient: LinearGradient(
  //                       begin: Alignment.centerLeft,
  //                       end: Alignment.centerRight,
  //                       colors: <Color>[
  //                         CustomTheme.of(context).primaryColor,
  //                         CustomTheme.of(context).primaryColor,
  //                       ],
  //                       tileMode: TileMode.mirror,
  //                     ),
  //                     borderRadius: BorderRadius.circular(30.0),
  //                   ),
  //                   child: Text(
  //                     AppLocalizations.of(context)!
  //                         .translate("loc_sign_up")
  //                         .toString(),
  //                     style: CustomWidget(context: context)
  //                         .CustomSizedTextStyle(
  //                             16.0,
  //                             CustomTheme.of(context).focusColor,
  //                             FontWeight.w500,
  //                             'FontRegular'),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20.0,
  //               ),
  //               // Text(
  //               //   AppLocalizations.of(context)!.translate("loc_login_other"),
  //               //   style: CustomWidget(context: context)
  //               //       .CustomSizedTextStyle(
  //               //       13.0,
  //               //       CustomTheme.of(context).dividerColor,
  //               //       FontWeight.w500,
  //               //       'FontRegular'),
  //               // ),
  //               // const SizedBox(
  //               //   height: 20.0,
  //               // ),
  //               // Row(
  //               //   crossAxisAlignment: CrossAxisAlignment.center,
  //               //   children: [
  //               //     Flexible(child: InkWell(
  //               //       onTap: (){
  //               //
  //               //       },
  //               //       child: Container(
  //               //         padding: EdgeInsets.only(top: 11.0, bottom: 11.0),
  //               //         alignment: Alignment.center,
  //               //         width: MediaQuery.of(context).size.width,
  //               //         decoration: BoxDecoration(
  //               //           borderRadius: BorderRadius.circular(10.0),
  //               //           color: CustomTheme.of(context).canvasColor,
  //               //         ),
  //               //         child: Row(
  //               //           crossAxisAlignment: CrossAxisAlignment.center,
  //               //           mainAxisAlignment: MainAxisAlignment.center,
  //               //           children: [
  //               //             SvgPicture.asset("assets/images/fb.svg",height: 22.0,),
  //               //             const SizedBox(
  //               //               width: 5.0,
  //               //             ),
  //               //             Text(
  //               //               AppLocalizations.of(context)!.translate("loc_fb"),
  //               //               style: CustomWidget(context: context)
  //               //                   .CustomSizedTextStyle(
  //               //                   13.0,
  //               //                   CustomTheme.of(context).focusColor,
  //               //                   FontWeight.w500,
  //               //                   'FontRegular'),
  //               //             )
  //               //           ],
  //               //         ),
  //               //       ),
  //               //     )),
  //               //     const SizedBox(
  //               //       width: 10.0,
  //               //     ),
  //               //     Flexible(child:  InkWell(
  //               //       onTap: (){
  //               //
  //               //       },
  //               //       child: Container(
  //               //         padding: EdgeInsets.only(top: 11.0,bottom: 11.0),
  //               //         alignment: Alignment.center,
  //               //         width: MediaQuery.of(context).size.width,
  //               //         decoration: BoxDecoration(
  //               //           borderRadius: BorderRadius.circular(10.0),
  //               //           color: CustomTheme.of(context).canvasColor,
  //               //         ),
  //               //         child: Row(
  //               //           crossAxisAlignment: CrossAxisAlignment.center,
  //               //           mainAxisAlignment: MainAxisAlignment.center,
  //               //           children: [
  //               //             SvgPicture.asset("assets/images/google.svg",height: 22.0,),
  //               //             const SizedBox(
  //               //               width: 5.0,
  //               //             ),
  //               //             Text(
  //               //               AppLocalizations.of(context)!.translate("loc_google"),
  //               //               style: CustomWidget(context: context)
  //               //                   .CustomSizedTextStyle(
  //               //                   13.0,
  //               //                   CustomTheme.of(context).focusColor,
  //               //                   FontWeight.w500,
  //               //                   'FontRegular'),
  //               //             )
  //               //           ],
  //               //         ),
  //               //       ),
  //               //     ),)
  //               //   ],
  //               // ),
  //               const SizedBox(
  //                 height: 45.0,
  //               ),
  //               // Container(
  //               //   child: Column(
  //               //     crossAxisAlignment: CrossAxisAlignment.center,
  //               //     mainAxisAlignment: MainAxisAlignment.center,
  //               //     children: [
  //               //       SvgPicture.asset("assets/images/finger_print.svg",height: 40.0,),
  //               //       const SizedBox(
  //               //         height: 20.0,
  //               //       ),
  //               //       Text(
  //               //         "Use fingerprint instead?",
  //               //         style: CustomWidget(context: context)
  //               //             .CustomSizedTextStyle(
  //               //             13.0,
  //               //             CustomTheme.of(context).cardColor,
  //               //             FontWeight.w500,
  //               //             'FontRegular'),
  //               //       )
  //               //     ],
  //               //   ),
  //               // )
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  verifyMail() async {
   await apiUtils
        .doLoginEmail(
      emailController.text.toString(),
      passwordController.text.toString(),
      ip,
      deviceData['device_id'].toString(),
      _currentAddress.toString(),
    )
        .then((loginData) {
          debugPrint('Here is login Data ${loginData.toString()}');
      if (loginData['success']) {
        debugPrint(loginData['success'].toString());
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home_Screen(
              loginStatus: true,
            ),
          ),
        );

        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_login").toString(), loginData.message.toString(), "success");
          // CustomWidget(context: context).showSuccessAlertDialog(
          //     AppLocalizations.of(context)!.translate("loc_login").toString(),
          //     AppLocalizations.of(context)!
          //         .translate("loc_login_msg")
          //         .toString(),
          //     "success");
          storeData(loginData['result']['access_token'],
              emailController.text.toString());
        });


      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_login").toString(), loginData.message.toString(), "error");
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_login").toString(),
              AppLocalizations.of(context)!.translate("loc_log_msg").toString(),
              "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  verifyFinger() {
    apiUtils
        .doLoginBiometric(
      emailValue,
      ip,
      deviceData['deviceos_type'].toString(),
      _currentAddress.toString(),
      deviceData['device_id'].toString(),
    )
        .then((LoginDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_login").toString(), loginData.message.toString(), "success");
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_login").toString(),
              AppLocalizations.of(context)!
                  .translate("loc_login_msg")
                  .toString(),
              "success");
          storeData(loginData.result!.accessToken.toString(),
              emailController.text.toString());
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Home_Screen(
              loginStatus: true,
            ),
          ),
        );
      } else {
        setState(() {
          loading = false;
          // CustomWidget(context: context).showSuccessAlertDialog(AppLocalizations.of(context)!.translate("loc_login").toString(), loginData.message.toString(), "error");
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_login").toString(),
              AppLocalizations.of(context)!.translate("loc_log_msg").toString(),
              "error");
        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  registerMail() {
    apiUtils
        .doVerifyRegister(
            fnameController.text.toString(),
            lnameController.text.toString(),
            signupEmailController.text.toString(),
            signupPasswordController.text.toString(),
            conPasswordController.text.toString(),
            refCodeController.text.toString())
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;
          signin = false;
          fnameController.clear();
          lnameController.clear();
          signupEmailController.clear();
          signupPasswordController.clear();
          conPasswordController.clear();
          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_reg").toString(),
              AppLocalizations.of(context)!.translate("loc_reg_msg").toString(),
              "success");

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Register_Success_Screen(),
            ),
          );
        });
      } else {
        setState(() {
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              AppLocalizations.of(context)!.translate("loc_reg").toString(),
              AppLocalizations.of(context)!
                  .translate("loc_regis_msg")
                  .toString(),
              "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  storeData(String token, String email) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", token);
    preferences.setString("emailZurumi", email);
  }
}
