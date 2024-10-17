import 'package:flutter/material.dart';

enum MyThemeKeys {
  LIGHT,
  DARK,
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
      primaryColor:Color(0xFF5C4392),
      primaryColorDark: Color(0xFFFFFFFF),
      brightness: Brightness.light,
      disabledColor: Color(0xFF5C4392),
      dialogBackgroundColor: Color(0xFFB3B3B3),
      primaryColorLight: Color(0xFFFFFFFF),
      canvasColor: Color(0xFFF2F1F1),
      cardColor: Color(0xFF136E82),
      dividerColor: Color(0xFF233446),
      shadowColor: Color(0xFF136E82),
      // cursorColor: Color(0xFFFFFFFF),
      splashColor: Color(0xFF032621),
      focusColor: Color(0xFFFFFFFF),
      highlightColor: Color(0xFFD9D9D9),
      // errorColor: Color(0xFF5968B1),
      hintColor: Color(0xFF1B232A),
      hoverColor: Color(0xFF8B9CAE),
      secondaryHeaderColor:Color(0xFFFFFFFF),
      indicatorColor: Color(0xFF1B9368),
      unselectedWidgetColor: Color(0xFFE9E6F1),
      scaffoldBackgroundColor: Color(0xFFDD2942)
  );


  static final ThemeData darkTheme = ThemeData(
      primaryColor: Color(0xFF009FD4),
      primaryColorDark: Color(0xFF2F3462),
      brightness: Brightness.dark,
      dividerColor: Color(0xFF757575),
      focusColor: Color(0xFFFFFFFF),
      canvasColor: Color(0xFF1E1F20),


      dialogBackgroundColor: Color(0xFF1E1F20),
      primaryColorLight: Color(0xFF795BF2),
      cardColor: Color(0xFF000000),
      disabledColor: Color(0xFFFFFFFF),
      // cursorColor: Color(0xFF0e1839),
      shadowColor: Colors.black,
      secondaryHeaderColor: Color(0xFFE8E8E8),
      splashColor: Color(0xFFFFFFFF),
      highlightColor: Color(0xFFD9D9D9),
      // errorColor: Color(0xFF5968B1),
      hintColor: Color(0xFF1B232A),
      hoverColor:  Color(0xFFDD2942),
      indicatorColor: Color(0xFF1B9368),
      unselectedWidgetColor: Color(0xFFE9E6F1),
      scaffoldBackgroundColor: Color(0xFF848484)
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return lightTheme;
    }
  }
}
