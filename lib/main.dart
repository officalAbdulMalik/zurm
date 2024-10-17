import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zurumi/common/localization/app_langugage_provider.dart';
import 'package:zurumi/common/localization/app_localizations.dart';


import 'package:zurumi/common/theme/custom_theme.dart';
import 'package:zurumi/common/theme/themes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zurumi/screens/basic/splash_screen.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // navigation bar color
    statusBarColor: Color(0xFF2F3462),
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light, // status bar icon color
    systemNavigationBarIconBrightness: Brightness.dark, // color of navigation controls
  ));

  runApp(
    const CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppLanguageProvider appLanguage = AppLanguageProvider();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>appLanguage,
      child: Consumer<AppLanguageProvider>(builder: (context, model, child) {
        return MaterialApp(
          title: 'Zurumi',
          theme: CustomTheme.of(context),
          themeMode: ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home:const SplashScreen(),
          locale: model.appLocal,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('fr', 'CA'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
        );
      }),
    );
  }
}
//
