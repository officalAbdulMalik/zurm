import 'dart:io';
import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:zurumi/data/crypt_model/user_details_model.dart';

import '../../common/country.dart';
import '../../common/custom_widget.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import '../../common/textformfield_custom.dart';
import '../../common/theme/custom_theme.dart';
import '../../data/api_utils.dart';
import '../../data/crypt_model/country_details_model.dart';
import '../../data/crypt_model/profile_update_model.dart';
import '../../data/crypt_model/upload_image_model.dart';

class Profile_Screen extends StatefulWidget {
  final UserDetails userDetails;
  const Profile_Screen({Key? key, required this.userDetails}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen> {

  bool loading = false;
  bool edit = false;
  FocusNode emailFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode lnameFocus = FocusNode();
  FocusNode nationFocus = FocusNode();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController nationController = TextEditingController();

  String profileImage = "1";
  bool? selectImg = false;
  File? imageFile;
  final ImagePicker picker = ImagePicker();
  UserDetails? details;

  Country? _selectedCountry;
  bool countryB = false;
  FocusNode mobileFocus=new FocusNode();
  TextEditingController mobileController = TextEditingController();
  DateTime? selectedDateOfBirth;
  DateTime? selectedExDate;
  TextEditingController dobController = TextEditingController();

  String selectedTime = "";
  List<CountryDetails> countryList = [ ];
  APIUtils apiUtils = APIUtils();
  CountryDetails? selectedCountryType;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    edit = true;
    details=widget.userDetails;
    selectedDateOfBirth = DateTime((DateTime.now()).year - 18,
        (DateTime.now()).month, (DateTime.now()).day); //DateTime.now();
    selectedExDate = DateTime.now();
    initCountry();

    profileImage=details!.profileimg.toString();



    getCountryCodeDetils();
  }

  Future<Null> _selectDate(BuildContext context, bool isDob,
      DateTime initialDate, DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: CustomTheme.of(context).primaryColor,
            dialogBackgroundColor: CustomTheme.of(context).primaryColor,
            primaryColorDark: CustomTheme.of(context).primaryColorDark,
            colorScheme: ColorScheme.light(
              primary: CustomTheme.of(context).cardColor,
            ),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null)
      setState(() {
        if (isDob) {
          selectedDateOfBirth = picked;
          dobController =
              TextEditingController(text: picked.toString().split(' ')[0]);
        } else {
          selectedExDate = picked;
        }
      });
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: CustomTheme.of(context).primaryColorDark,
      appBar: AppBar(
          backgroundColor: CustomTheme.of(context).secondaryHeaderColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            edit ? AppLocalizations.of(context)!.translate("loc_side_profile").toString() : AppLocalizations.of(context)!.translate("loc_edit_profile").toString(),
            style: CustomWidget(context: context)
                .CustomSizedTextStyle(
                17.0,
                Theme.of(context).cardColor,
                FontWeight.w500,
                'FontRegular'),
          ),
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
          )),
      body: Container(
          
          child: Stack(
            children: [
              SingleChildScrollView(
                child:  Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    children: [
                      edit ? Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0, bottom: 20.0),
                      
                        
                      
                    
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  edit = false;

                                  nameController.text=details!.firstName.toString()=="null"||details!.firstName.toString()==null ?" ":details!.firstName.toString();
                                  lnameController.text=details!.lastName.toString()=="null"||details!.lastName.toString()==null ? " ":details!.lastName.toString();
                                  mobileController.text=details!.phoneNo.toString()=="null" || details!.phoneNo.toString()==null? " ":details!.phoneNo.toString();
                                  dobController.text=details!.dob.toString()=="null"||details!.dob.toString()==null? " ":details!.dob.toString();
                                  nationController.text=details!.nationality.toString()=="null"||details!.nationality.toString()==null? "":details!.nationality.toString();
                                  for(int m=0;m<countryList.length;m++){
                                    if(countryList[m].code.toString().toLowerCase()==details!.phoneCountry.toString().toLowerCase())
                                      {
                                        selectedCountryType=countryList[m];
                                      }
                                  }

                                });
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                    
                                      boxShadow: kElevationToShadow[3]
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("loc_edit").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context).primaryColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  // color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle
                              ),
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).disabledColor,
                                      image: profileImage == "1" || profileImage == "null"
                                          ? DecorationImage(
                                          image:
                                          AssetImage("assets/images/profile.png"),
                                          fit: BoxFit.cover)
                                          : selectImg!
                                          ? DecorationImage(
                                          image: FileImage(File(imageFile!.path)),
                                          fit: BoxFit.cover)
                                          : DecorationImage(
                                          image: NetworkImage(profileImage),
                                          fit: BoxFit.cover)
                                  ),

                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(
                                        AppLocalizations.of(context)!.translate("loc_name").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 1,),
                                      Flexible(child: Text(

                                          details!.firstName.toString()+" "+  details!.lastName.toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 2,)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(
                                        AppLocalizations.of(context)!.translate("loc_email").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 1,),
                                      Flexible(child: Text(
                                        // name,
                                        details!.email.toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 2,)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(child: Text(
                                        AppLocalizations.of(context)!.translate("loc_mobile").toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 1,),
                                      Flexible(child: Text(
                                        // name,
                                          details!.phoneNo.toString()==null || details!.phoneNo.toString()=="null"?"-":details!.phoneNo.toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),flex: 2,)
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ) :
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 15.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[
                              CustomTheme.of(context).disabledColor.withOpacity(0.4),
                              CustomTheme.of(context).primaryColor,
                            ],
                            tileMode: TileMode.mirror,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  edit = true;
                                });
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: <Color>[
                                          CustomTheme.of(context).primaryColorDark,
                                          CustomTheme.of(context).primaryColorLight,
                                        ],
                                        tileMode: TileMode.mirror,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: kElevationToShadow[3]
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("loc_cancel").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        12.0,
                                        Theme.of(context).primaryColor,
                                        FontWeight.w600,
                                        'FontRegular'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0,),
                            Container(
                              padding: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                  // color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle
                              ),
                              child: Center(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 120.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context).disabledColor,
                                      image: profileImage == "1" || profileImage == "null"
                                          ? DecorationImage(
                                          image:
                                          AssetImage("assets/images/profile.png"),
                                          fit: BoxFit.cover)
                                          : selectImg!
                                          ? DecorationImage(
                                          image: FileImage(File(imageFile!.path)),
                                          fit: BoxFit.cover)
                                          : DecorationImage(
                                          image: NetworkImage(profileImage),
                                          fit: BoxFit.cover)
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child:  InkWell(
                                          onTap: (){
                                            onRequestPermission();
                                          },
                                          child: Container(
                                            width: 35.0,
                                            height: 35.0,
                                            padding: EdgeInsets.all(5.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:  Theme.of(context).primaryColorLight,
                                                // borderRadius: BorderRadius.circular(10.0)
                                            ),
                                            child: Icon(
                                              Icons.camera_alt_rounded,
                                              size: 18.0,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),),
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_first_name").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              onEditComplete: () {
                                nameFocus.unfocus();
                                FocusScope.of(context).requestFocus(lnameFocus);
                              },
                              radius: 8.0,
                              error: AppLocalizations.of(context)!.translate("loc_enter_name").toString(),
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: Colors.transparent,
                              fillColor: CustomTheme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  15.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomTextStyle(
                                  CustomTheme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
                              textInputAction: TextInputAction.next,
                              focusNode: nameFocus,
                              maxlines: 1,
                              text: '',
                              hintText: AppLocalizations.of(context)!.translate("loc_first_name").toString(),
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {},
                              onChanged: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Name";
                                }
                                return null;
                              },
                              enabled: true,
                              textInputType: TextInputType.name,
                              controller: nameController,

                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_last_name").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              onEditComplete: () {
                                lnameFocus.unfocus();
                                // FocusScope.of(context).requestFocus(emailFocus);
                              },
                              radius: 8.0,
                              error: AppLocalizations.of(context)!.translate("loc_enter_lname").toString(),
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: Colors.transparent,
                              fillColor: CustomTheme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  15.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomTextStyle(
                                  CustomTheme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
                              textInputAction: TextInputAction.next,
                              focusNode: lnameFocus,
                              maxlines: 1,
                              text: '',
                              hintText: AppLocalizations.of(context)!.translate("loc_last_name").toString(),
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {},
                              onChanged: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Last Name";
                                }
                                return null;
                              },
                              enabled: true,
                              textInputType: TextInputType.name,
                              controller: lnameController,

                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_mobile").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color:  CustomTheme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.only(left: 1.0, right: 3.0,top: 1.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 7.0,
                                        right: 10.0,
                                        top: 14.0,
                                        bottom: 14.0),
                                    decoration: BoxDecoration(
                                      color: CustomTheme.of(context).canvasColor,
                                      borderRadius: BorderRadius.only(
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
                                                _selectedCountry!.flag
                                                    .toString(),
                                                package:
                                                "country_calling_code_picker",
                                                height: 20.0,
                                                width: 25.0,
                                              )
                                                  : Container(
                                                width: 0.0,
                                              ),
                                              const SizedBox(width: 5.0,),
                                              Text(
                                                countryB
                                                    ? _selectedCountry!
                                                    .callingCode
                                                    .toString()
                                                    : "+1",
                                                style:TextStyle(
                                                    color: CustomTheme.of(context).cardColor,
                                                    fontFamily: 'UberMove',
                                                    fontSize: 16.0),
                                              ),
                                              const SizedBox(
                                                width: 3.0,
                                              ),
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_down_outlined,
                                                size: 15.0,
                                                color: CustomTheme.of(context).primaryColor,
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
                                        onEditingComplete: (){
                                          mobileFocus.unfocus();
                                        },
                                        controller:
                                        mobileController,
                                        maxLength: 15,
                                        focusNode: mobileFocus,
                                        enabled: true,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        style: CustomWidget(context: context)
                                            .CustomTextStyle(
                                            // 16.0,
                                            CustomTheme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                        decoration: InputDecoration(
                                          counterText: ""
                                              "",
                                          contentPadding: const EdgeInsets.only(
                                              left: 12,
                                              right: 0,
                                              top: 2,
                                              bottom: 2),
                                          hintText: AppLocalizations.of(context)!.translate("loc_mobile").toString(),
                                          hintStyle: TextStyle(
                                              color: CustomTheme.of(context).dividerColor,
                                              fontFamily: 'UberMoveLight',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0),
                                          border: InputBorder.none,
                                          fillColor: CustomTheme.of(context).canvasColor,
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
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_dob").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            InkWell(
                              onTap: () {
                                selectedDateOfBirth = DateTime((DateTime.now()).year - 18,
                                    (DateTime.now()).month, (DateTime.now()).day);
                                _selectDate(
                                    context,
                                    true,
                                    DateTime(selectedDateOfBirth!.year,
                                        selectedDateOfBirth!.month, selectedDateOfBirth!.day),
                                    DateTime(selectedDateOfBirth!.year - 100,
                                        selectedDateOfBirth!.month, selectedDateOfBirth!.day),
                                    DateTime(selectedDateOfBirth!.year,
                                        selectedDateOfBirth!.month, selectedDateOfBirth!.day));
                              },
                              child: TextFormField(
                                controller: dobController,
                                // focusNode: emailFocus,
                                maxLines: 1,
                                enabled: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                style: CustomWidget(context: context).CustomTextStyle(
                                    Theme.of(context).cardColor,
                                    FontWeight.w500,
                                    'FontRegular'),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 12, right: 0, top: 2, bottom: 2),
                                  hintText: AppLocalizations.of(context)!.translate("loc_dob_hnt"),
                                  hintStyle: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      14.0,
                                      Theme.of(context).dividerColor,
                                      FontWeight.w400,
                                      'FontRegular'),
                                  filled: true,
                                  fillColor: CustomTheme.of(context).canvasColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor
                                            .withOpacity(0.5),
                                        width: 1.0),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: CustomTheme.of(context)
                                            .canvasColor
                                            .withOpacity(0.5),
                                        width: 1),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_nation").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            TextFormFieldCustom(
                              onEditComplete: () {
                                nationFocus.unfocus();
                                // FocusScope.of(context).requestFocus(emailFocus);
                              },
                              radius: 8.0,
                              error: AppLocalizations.of(context)!.translate("loc_enter_nation"),
                              textColor: CustomTheme.of(context).cardColor,
                              borderColor: Colors.transparent,
                              fillColor: CustomTheme.of(context).canvasColor,
                              hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                                  15.0, CustomTheme.of(context).dividerColor, FontWeight.w400, 'FontRegular'),
                              textStyle: CustomWidget(context: context).CustomTextStyle(
                                  CustomTheme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
                              textInputAction: TextInputAction.next,
                              focusNode: nationFocus,
                              maxlines: 1,
                              text: '',
                              hintText: AppLocalizations.of(context)!.translate("loc_nation").toString(),
                              obscureText: false,
                              suffix: Container(
                                width: 0.0,
                              ),
                              textChanged: (value) {},
                              onChanged: () {},
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Nationality";
                                }
                                return null;
                              },
                              enabled: true,
                              textInputType: TextInputType.name,
                              controller: nationController,

                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              AppLocalizations.of(context)!.translate("loc_slct_country").toString(),
                              style: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                  14.0,
                                  Theme.of(context).cardColor,
                                  FontWeight.w500,
                                  'FontRegular'),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width,
                              height: 50.0,
                              padding:
                              EdgeInsets.fromLTRB(10.0, 0.0, 5, 0.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: CustomTheme.of(context)
                                      .canvasColor,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    menuMaxHeight:
                                    MediaQuery.of(context).size.height *
                                        0.5,
                                    items: countryList
                                        .map((value) => DropdownMenuItem(
                                      child: Text(
                                        value.name.toString(),
                                        style: CustomWidget(context: context)
                                            .CustomSizedTextStyle(
                                            14.0,
                                            Theme.of(context).cardColor,
                                            FontWeight.w500,
                                            'FontRegular'),
                                      ),
                                      value: value,
                                    ))
                                        .toList(),
                                    onChanged: (value) async {
                                      setState(() {
                                        selectedCountryType = value;
                                        print(
                                          "hai" + selectedCountryType!.code.toString(),
                                        );
                                      });
                                    },
                                    hint: Text(
                                      AppLocalizations.of(context)!.translate("loc_slct_country").toString(),
                                      style: CustomWidget(context: context)
                                          .CustomSizedTextStyle(
                                          12.0,
                                          Theme.of(context).cardColor,
                                          FontWeight.w500,
                                          'FontRegular'),
                                    ),
                                    isExpanded: true,
                                    value: selectedCountryType,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Theme.of(context).cardColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),

                            InkWell(
                              onTap: (){
                                setState(() {
                                  if(nameController.text.isEmpty){
                                    CustomWidget(context: context).showSuccessAlertDialog("Profile","Please enter first name details", "error");
                                  } else if(lnameController.text.isEmpty){
                                    CustomWidget(context: context).showSuccessAlertDialog("Profile","Please enter last name details", "error");
                                  } else if(mobileController.text.isEmpty){
                                    CustomWidget(context: context).showSuccessAlertDialog("Profile","Please enter mobile number details", "error");
                                  } else if(dobController.text.isEmpty){
                                    CustomWidget(context: context).showSuccessAlertDialog("Profile","Please enter dob details", "error");
                                  } else if(nationController.text.isEmpty){
                                    CustomWidget(context: context).showSuccessAlertDialog("Profile","Please enter nationality details", "error");
                                  } else {
                                    doUpdateDetails();
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
                                      CustomTheme.of(context).primaryColorDark,
                                      CustomTheme.of(context).primaryColorLight,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_save_change").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      17.0,
                                      CustomTheme.of(context).focusColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                          ],
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
                  ? CustomWidget(context: context)
                  .loadingIndicator(CustomTheme.of(context).primaryColor)
                  : Container()
            ],
          )),
    ));
  }


  onRequestPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      _pickedImageDialog();
    } else {
      _pickedImageDialog();
    }
  }

  _pickedImageDialog() {
    showModalBottomSheet<void>(
      //background color for modal bottom screen
      backgroundColor: Theme.of(context).focusColor,
      //elevates modal bottom screen
      elevation: 10,
      isScrollControlled: true,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      // context and builder are
      // required properties in this widget
      context: context,
      builder: (BuildContext context) {
        // we set up a container inside which
        // we create center column and display text

        // Returning SizedBox instead of a Container
        return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate("loc_chose_img").toString(),
                          style: CustomWidget(context: context)
                              .CustomSizedTextStyle(16.0, Theme.of(context).cardColor,
                              FontWeight.w600, 'FontRegular'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: InkWell(
                              onTap: (){
                                setState(() {
                                Navigator.pop(context);
                                getImage(ImageSource.gallery);
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
                                      CustomTheme.of(context).primaryColorDark,
                                      CustomTheme.of(context).primaryColorLight,
                                    ],
                                    tileMode: TileMode.mirror,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("loc_gallery").toString(),
                                  style: CustomWidget(context: context)
                                      .CustomSizedTextStyle(
                                      17.0,
                                      CustomTheme.of(context).cardColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                                ),
                              ),
                            ),flex: 4,),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    Navigator.pop(context);
                                    getImage(ImageSource.camera);
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
                                        CustomTheme.of(context).primaryColorDark,
                                        CustomTheme.of(context).primaryColorLight,
                                      ],
                                      tileMode: TileMode.mirror,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate("loc_cam").toString(),
                                    style: CustomWidget(context: context)
                                        .CustomSizedTextStyle(
                                        17.0,
                                        CustomTheme.of(context).cardColor,
                                        FontWeight.w500,
                                        'FontRegular'),
                                  ),
                                ),
                              ),
                              flex: 4,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  getImage(ImageSource type) async {

    var pickedFile = await picker.pickImage(source: type);
    if (pickedFile != null) {
      setState(() {
        selectImg = true;
        imageFile = File(pickedFile.path);
        doUploadImage(imageFile!);

      });
    }
  }

  doUploadImage(File? img) {

    setState(() {
      loading=true;
    });
    apiUtils.doUpload(img!.path).then((UploadImageModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          setState(() {
            profileImage = loginData.result!.toString();
          });
          CustomWidget(context: context).showSuccessAlertDialog("Profile","Profile Image uploaded successfully", "success");

        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Profile", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
        print("jeeva");
      });
    });
  }

  doUpdateDetails() {

    setState(() {
      loading=true;
    });
    apiUtils.doUpdate( nameController.text.toString(), lnameController.text.toString(),mobileController.text.toString(),nationController.text.toString(), selectedCountryType!.code.toString(),dobController.text.toString()).then((ProfileUpdateModel loginData) {
      if (loginData.success!) {
        setState(() {
          edit= true;
          loading = false;
          setState(() {
            profileImage = loginData.result!.toString();
            Navigator.of(context).pop(true);
          });
          CustomWidget(context: context).showSuccessAlertDialog("Profile","Profile Details uploaded successfully", "success");
        });
      } else {
        setState(() {
          loading = false;
          CustomWidget(context: context).showSuccessAlertDialog("Profile", loginData.message.toString(), "error");

        });
      }
    }).catchError((Object error) {
      setState(() {
        loading = false;
      });
    });
  }

  getCountryCodeDetils() {
    apiUtils.getCountry().then((CountryDetailsModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;
          countryList = loginData.result!;
          selectedCountryType = countryList.first;
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
