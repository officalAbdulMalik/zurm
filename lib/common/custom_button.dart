import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/theme/custom_theme.dart';

class ButtonCustom extends StatelessWidget {
  final String text;
  final bool? iconEnable;
  final double? radius;
  final String? icon;
  final TextStyle? textStyle;
  final Color? iconColor;
  final Color? shadowColor;
  final Color? splashColor;
  final EdgeInsets? paddng;

  final VoidCallback onPressed;

  const ButtonCustom(
      {Key? key,
      required this.text,
       this.iconEnable,
       this.radius,
      this.icon,
       this.textStyle,
      this.iconColor,
      this.shadowColor,
      this.splashColor,
      required this.onPressed,
       this.paddng})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CustomTheme.of(context).primaryColor,
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),

        child: Padding(
          padding: paddng?? const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon != null
                  ? SvgPicture.asset(
                      icon ?? '',
                      height: 15.0,
                      width: 15.0,
                    )
                  : const SizedBox(),
              Text(
                text,
                maxLines: 1,
                style: AppTextStyles.poppinsRegular(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
