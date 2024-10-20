import 'package:flutter/material.dart';

class BackgroundController extends StatelessWidget {
  final int currentPage;
  final int totalPage;
  final Color? controllerColor;
  final bool indicatorAbove;
  final double indicatorPosition;

  BackgroundController({
    required this.currentPage,
    required this.totalPage,
    required this.controllerColor,
    required this.indicatorAbove,
    required this.indicatorPosition,
  });

  @override
  Widget build(BuildContext context) {
    return indicatorAbove
        ? Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 25.0),
            padding: EdgeInsets.only(bottom: 20, left: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(context),
            ),
          )
        : currentPage == totalPage
            ? SizedBox.shrink()
            : Container(
                padding: EdgeInsets.only(bottom: 10, left: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(context),
                ),
              );
  }

  /// List of the slides Indicators.
  List<Widget> _buildPageIndicator(BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < totalPage; i++) {
      list.add(i == currentPage
          ? _indicator(true, context)
          : _indicator(false, context));
    }
    return list;
  }

  /// Slide Controller / Indicator.
  Widget _indicator(bool isActive, BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 10),
      margin: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          bottom: indicatorAbove ? indicatorPosition : 28),
      height:12.0,
      width: isActive ? 12.0 : 12.0,
      decoration: BoxDecoration(
        color: isActive
            ? controllerColor ?? Colors.white
            : (controllerColor ?? Colors.white).withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
