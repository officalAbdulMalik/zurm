import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zurumi/screens/basic/home.dart';
import 'package:zurumi/screens/basic/welcome_details.dart';
import 'package:zurumi/screens/basic/welcome_screen.dart';
import '../../common/theme/custom_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String check = "";

  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setData();
  }

  setData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('language_code', 'fr');
    preferences.setString('countryCode', 'CA');
    String word = preferences.getString("welcomeZuru").toString();
    token = preferences.getString('token');

    if (token != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Home_Screen(
          loginStatus: true,
        ),
      ));
    } else if (word == null || word == "" || word == "null") {
      check = "1";
    } else {
      check = "0";
    }
    onLoad();
  }

  onLoad() {
    setState(() {
      if (check == "1") {
        Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              )),
        );
      } else {
        print("Mano");
        Timer(
          const Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const Welcome_Details(),
              )),
        );
      }

      // checkDeviceID(deviceData['device_id'].toString());
    });

    //   UnderMaintenance(),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              CustomTheme.of(context).primaryColorDark, // For iOS: (dark icons)
          statusBarIconBrightness:
              Brightness.light, // For Android: (dark icons)
        ),
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png",
                  height: 180.0, width: 180.0, fit: BoxFit.contain),
              // const SizedBox(height: 10.0,),
              // SvgPicture.asset("assets/images/logocont.svg",height: 70.0,width: 100.0,fit: BoxFit.contain),
              Image.asset("assets/images/logocont.png",
                  height: 70.0, width: 200.0, fit: BoxFit.contain),
            ],
          ),
        ],
      ),
    );
  }
}
