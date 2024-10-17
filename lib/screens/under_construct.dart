import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zurumi/common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';

import 'package:zurumi/common/theme/custom_theme.dart';

class UnderMaintenance extends StatefulWidget {
  const UnderMaintenance({Key? key}) : super(key: key);

  @override
  State<UnderMaintenance> createState() => _UnderMaintenanceState();
}

class _UnderMaintenanceState extends State<UnderMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: CustomTheme.of(context).focusColor, // For iOS: (dark icons)
          statusBarIconBrightness: Brightness.dark, // For Android: (dark icons)
        ),
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              CustomTheme.of(context).primaryColor,
              CustomTheme.of(context).primaryColor,
              CustomTheme.of(context).disabledColor,
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png",height: 200.0,width: 200.0,fit: BoxFit.contain),
            const SizedBox(height: 15.0,),
            SvgPicture.asset("assets/images/name.svg",height: 30.0,width: 50.0,fit: BoxFit.contain,color:   CustomTheme.of(context).dialogBackgroundColor,),
            const SizedBox(height: 35.0,),
            Text(
              AppLocalizations.of(context)!.translate("loc_under_mtnc").toString(),
              style: CustomWidget(context: context)
                  .CustomSizedTextStyle(
                  26.0,
                    CustomTheme.of(context).dialogBackgroundColor,
                  FontWeight.w700,
                  'FontRegular'),
            ),
          ],
        )
        
      ),
    );
  }
}
