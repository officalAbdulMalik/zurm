import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:zurumi/common/alert/elegant_notification.dart';
import 'package:zurumi/common/alert/resources/arrays.dart';
import 'package:zurumi/common/colors.dart';
import 'package:zurumi/common/ring.dart';




class AppTextStyles {


  static TextStyle poppinsRegular(
      {double? fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize ?? 15,
        letterSpacing: letterSpacing ?? 0,
        color: color ?? const Color(0xFF1B232A),
        // fontFamily: "Poppins Regular",
        fontWeight: fontWeight ?? FontWeight.bold);
  }

  static TextStyle poppinsBold(
      {double? fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize ?? 15,
        letterSpacing: letterSpacing ?? 0,
        color: color ?? const Color(0xFF1B232A),
        // fontFamily: "Poppins Bold",
        fontWeight: fontWeight ?? FontWeight.bold);
  }

  static TextStyle poppinsLight(
      {double? fontSize,
        Color? color,
        FontWeight? fontWeight,
        double? letterSpacing}) {
    return TextStyle(
        fontSize: fontSize ?? 15,
        letterSpacing: letterSpacing ?? 0,
        color: color ?? const Color(0xFF1B232A),
        // fontFamily: "Poppins Light",
        fontWeight: fontWeight ?? FontWeight.bold);
  }
}


class CustomWidget {
  final BuildContext context;

  CustomWidget({required this.context});

  //TODO Alert dialog
  showSuccessAlertDialog(String title, String message, String type) {
    type == "error"
        ? ElegantNotification.error(
            notificationPosition: NotificationPosition.topRight,
            animation: AnimationType.fromRight,
            title: Text(
              title,
              style: TextStyle(color: Colors.red),
            ),
            description: Text(message,
                style: TextStyle(color: Colors.black, fontSize: 12.0)),
            onDismiss: () {},
          ).show(context)
        : type == "success"
            ? ElegantNotification.success(
                notificationPosition: NotificationPosition.topRight,
                animation: AnimationType.fromRight,
                title: Text(
                  title,
                  style: TextStyle(color: Colors.red),
                ),
                description: Text(message,
                    style: TextStyle(color: Colors.black, fontSize: 12.0)),
                onDismiss: () {},
              ).show(context)
            : ElegantNotification.info(
                notificationPosition: NotificationPosition.topRight,
                animation: AnimationType.fromRight,
                title: Text(
                  title,
                  style: TextStyle(color: Colors.red),
                ),
                description: Text(message,
                    style: TextStyle(color: Colors.black, fontSize: 12.0)),
                onDismiss: () {},
              ).show(context);
    // show the dialog
  }

  Widget loadingIndicator(Color color) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color:  Color(0xFF1d0068),
      child: Center(
        child: Container(
          child: Center(
              child: Stack(
            children: [
              SpinKitDualRing(
                color: color,
              ),
              // Center(
              //   child: SvgPicture.asset('assets/icons/logo.svg',
              //       height: 25.0, width: 25.0),
              // )
              Center(
                child: Image.asset('assets/images/logo.png',
                    height: 25.0, width: 25.0),
              )
            ],
          )),
        ),
      ),
    );
  }

  CustomTextStyle(Color color, FontWeight weight, String family) {
    return TextStyle(fontWeight: weight, color:  const Color(0xFF1B232A), fontSize: 13.0);
  }

  CustomSizedTextStyle(
      double size, Color? color, FontWeight weight, String family) {
    return TextStyle(
        fontWeight: weight,
        color:  const Color(0xFF1B232A),
        fontSize: size);
  }

  Widget noInternet() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color:  Color(0xFF1d0068),
      child: Center(
        child: Container(
          child: Center(child: Image.asset('assets/image/internet.png')),
        ),
      ),
    );
  }

  Widget noRecordsFound(String data, Color color) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(data,
            style: TextStyle(
              fontFamily: "FontRegular",
              color: color,
            )),
      ),
    );
  }
}
