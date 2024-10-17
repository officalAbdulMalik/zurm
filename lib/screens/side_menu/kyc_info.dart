import 'dart:convert';

import 'package:country_calling_code_picker/picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zurumi/common/colors.dart';
import 'package:zurumi/common/country.dart';
import 'package:zurumi/common/localization/app_localizations.dart';
import 'package:zurumi/data/api_utils.dart';
import 'package:zurumi/data/crypt_model/common_model.dart';
import 'package:zurumi/data/crypt_model/country_code.dart';
import 'package:zurumi/data/crypt_model/kyc_update_model.dart';
import 'dart:io' as Io;
import 'dart:convert';

import '../../../../common/custom_button.dart';
import '../../../../common/custom_widget.dart';
import '../../../../common/theme/custom_theme.dart';

class KYCPage extends StatefulWidget {
  const KYCPage({Key? key}) : super(key: key);

  @override
  State<KYCPage> createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> {
  Country? _selectedCountry;
  DateTime? selectedDateOfBirth;
  DateTime? selectedExpiryDate;
  DateTime? selectedExDate;
  bool verify = false;
  String selectedTime = "";

  var documentUri = "";
  final _formKey = GlobalKey<FormState>();
  String imagePath = "assets/others/banner.png";
  var faceUri = "";
  ImagePicker picker = ImagePicker();

  APIUtils apiUtils = APIUtils();
  bool loading = false;
  bool imageCapture = true;

  // bool _autoValidate = true;
  bool mobileVerify = true;
  bool frontStatus = false;
  bool backStatus = false;

  FocusNode mobileFocus = FocusNode();
  TextEditingController mobile = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController statesController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  TextEditingController addressController = TextEditingController();
  TextEditingController addressLineController = TextEditingController();
  TextEditingController expController = TextEditingController();

  List<String> genderType = [
    "Male",
    "Female",
  ];
  List<CountryCodeResult> countryList = [];
  List<String> idProofType = [
    "Passport",
    "Driving Licence",
    "SSN",
  ];
  String selectedGender = "";
  String selectedIdProof = "";
  CountryCodeResult? selectedCountryType;

  String panUrl = "";
  String aadharUrl = "";
  String faceUrl = "";
  bool countryB = false;

  String AadharImg = "img64";

  String PanImg = "img65";
  String kycID = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDateOfBirth = DateTime((DateTime.now()).year - 18,
        (DateTime.now()).month, (DateTime.now()).day); //DateTime.now();
    selectedExDate = DateTime.now();
    initCountry();
    selectedExpiryDate = DateTime(
        (DateTime.now()).year, (DateTime.now()).month, (DateTime.now()).day);

    selectedGender = genderType.first;
    selectedIdProof = idProofType.first;
    getCountryCodeDetils();
  }

  /// Opens QR scanner screen

  void initCountry() async {
    final country = await getDefaultCountry(context);
    setState(() {
      _selectedCountry = country;
      countryB = true;
    });
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

  Future<Null> _selectExpiryDate(BuildContext context, bool isExpDate,
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
        if (isExpDate) {
          selectedExpiryDate = picked;
          expController =
              TextEditingController(text: picked.toString().split(' ')[0]);
        } else {
          selectedExDate = picked;
        }
      });
  }

  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            elevation: 0.0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: Icon(
                  Icons.arrow_back,
                  size: 25.0,
                  color: CustomTheme.of(context).shadowColor,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.translate("loc_kyc_head").toString(),
              style: CustomWidget(context: context).CustomSizedTextStyle(16.0,
                  Theme.of(context).cardColor, FontWeight.w500, 'FontRegular'),
            ),
          ),
          body: Container(
              margin: EdgeInsets.only(left: 0, right: 0, bottom: 0.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).secondaryHeaderColor,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: SafeArea(
                      child: frontStatus
                          ? frontID()
                          : backStatus
                              ? backID()
                              : detailsUI(),
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

  Widget detailsUI() {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 10.0, right: 15.0, left: 15.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: firstNameController,
              // focusNode: emailFocus,
              maxLines: 1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // autocorrect: _autoValidate,
              // enabled: emailVerify,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style: CustomWidget(context: context).CustomTextStyle(
                  Theme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 0, top: 2, bottom: 2),
                hintText: AppLocalizations.of(context)!.translate("loc_first_name"),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w300,
                    'FontRegular'),
                filled: true,
                fillColor: CustomTheme.of(context).canvasColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color:
                          CustomTheme.of(context).canvasColor.withOpacity(0.5),
                      width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color:
                          CustomTheme.of(context).canvasColor.withOpacity(0.5),
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter FirstName";
                } else {
                  return value.length < 4
                      ? 'Minimum character length is 4'
                      : null;
                }
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: lastNameController,
              // focusNode: emailFocus,
              maxLines: 1,
              // autocorrect: _autoValidate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // enabled: emailVerify,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style: CustomWidget(context: context).CustomTextStyle(
                  Theme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 0, top: 2, bottom: 2),
                hintText: AppLocalizations.of(context)!.translate("loc_last_name"),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w300,
                    'FontRegular'),
                filled: true,
                fillColor: CustomTheme.of(context).canvasColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color:
                          CustomTheme.of(context).canvasColor.withOpacity(0.5),
                      width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color:
                          CustomTheme.of(context).canvasColor.withOpacity(0.5),
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter LastName";
                }

                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            // Row(
            //   children: [
            //     Container(
            //           padding: const EdgeInsets.only(
            //               left: 7.0,
            //               right: 10.0,
            //               top: 14.0,
            //               bottom: 14.0),
            //           decoration: BoxDecoration(
            //             color:
            //                 CustomTheme.of(context).canvasColor,
            //             borderRadius: BorderRadius.only(
            //               topLeft: Radius.circular(5.0),
            //               bottomLeft: Radius.circular(5.0),
            //             ),
            //           ),
            //           child: Row(
            //             children: [
            //               InkWell(
            //                 onTap: _onPressedShowBottomSheet,
            //                 child: Row(
            //                   children: [
            //                     countryB
            //                         ? Image.asset(
            //                             _selectedCountry!.flag
            //                                 .toString(),
            //                             package:
            //                                 "country_calling_code_picker",
            //                             height: 20.0,
            //                             width: 25.0,
            //                           )
            //                         : Container(
            //                             width: 0.0,
            //                           ),
            //                     const SizedBox(
            //                       width: 5.0,
            //                     ),
            //                     Text(
            //                       countryB
            //                           ? _selectedCountry!
            //                               .callingCode
            //                               .toString()
            //                           : "+1",
            //                       style: TextStyle(
            //                           color:
            //                               CustomTheme.of(context)
            //                                   .dividerColor,
            //                           fontFamily: 'UberMove',
            //                           fontSize: 16.0),
            //                     ),
            //                     const SizedBox(
            //                       width: 3.0,
            //                     ),
            //                     const Icon(
            //                       Icons
            //                           .keyboard_arrow_down_outlined,
            //                       size: 15.0,
            //                       color: Colors.white,
            //                     )
            //                   ],
            //                 ),
            //               ),
            //               const SizedBox(
            //                 width: 10.0,
            //               ),
            //               Container(
            //                 height: 20.0,
            //                 width: 1.0,
            //                 color: CustomTheme.of(context)
            //                     .dividerColor,
            //               )
            //             ],
            //           ),
            //         ),
            //     Flexible(
            //       child: TextFormField(
            //         controller: mobile,
            //         focusNode: mobileFocus,
            //         maxLines: 1,
            //         enabled: mobileVerify,
            //         textInputAction: TextInputAction.next,
            //         inputFormatters: [
            //           FilteringTextInputFormatter.allow(
            //               RegExp(r'[0-9]')),
            //         ],
            //         keyboardType: TextInputType.number,
            //         style: CustomWidget(context: context)
            //             .CustomTextStyle(Theme.of(context).primaryColor,
            //             FontWeight.w500, 'FontRegular'),
            //         decoration: InputDecoration(
            //           contentPadding: const EdgeInsets.only(
            //               left: 12, right: 0, top: 2, bottom: 2),
            //           hintText: "Please enter Mobile",
            //           suffixIcon: Container(
            //             // padding: const EdgeInsets.all(15.0),
            //             // child: SvgPicture.asset(
            //             //   'assets/icon/mobile.svg',
            //             //   height: 15.0,
            //             //   width: 15.0,
            //             //   allowDrawingOutsideViewBox: true,
            //             //   color: CustomTheme.of(context)
            //             //       .splashColor
            //             //       .withOpacity(0.5),
            //             // ),
            //             width: 0.0,
            //           ),
            //           hintStyle: CustomWidget(context: context)
            //               .CustomTextStyle(
            //               Theme.of(context)
            //                   .dividerColor,
            //               FontWeight.w300,
            //               'FontRegular'),
            //           filled: true,
            //           fillColor: CustomTheme.of(context)
            //               .canvasColor,
            //           border: OutlineInputBorder(
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(5.0),
            //               bottomRight: Radius.circular(5.0),
            //             ),
            //             borderSide: BorderSide(
            //                 color: CustomTheme.of(context)
            //                     .canvasColor,
            //                 width: 1.0),
            //           ),
            //           enabledBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(5.0),
            //               bottomRight: Radius.circular(5.0),
            //             ),
            //             borderSide: BorderSide(
            //                 color: CustomTheme.of(context)
            //                     .canvasColor,
            //                 width: 1.0),
            //           ),
            //           focusedBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(5.0),
            //               bottomRight: Radius.circular(5.0),
            //             ),
            //             borderSide: BorderSide(
            //                 color: CustomTheme.of(context).canvasColor,
            //                 width: 1.0),
            //           ),
            //           errorBorder: OutlineInputBorder(
            //             borderRadius: BorderRadius.only(
            //               topRight: Radius.circular(5.0),
            //               bottomRight: Radius.circular(5.0),
            //             ),
            //             borderSide: BorderSide(
            //                 color: CustomTheme.of(context).canvasColor,
            //                 width: 1.0),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //         color: CustomTheme.of(context)
            //             .canvasColor,
            //         width: 1.0),
            //     borderRadius: BorderRadius.circular(5.0),
            //     color: CustomTheme.of(context).canvasColor,
            //   ),
            //   child: Theme(
            //     data: Theme.of(context).copyWith(
            //       canvasColor: CustomTheme.of(context).canvasColor,
            //     ),
            //     child: DropdownButtonHideUnderline(
            //       child: DropdownButton(
            //         menuMaxHeight:
            //         MediaQuery.of(context).size.height * 0.7,
            //         items: genderType
            //             .map((value) => DropdownMenuItem(
            //           child: Text(
            //             value.toString(),
            //             style: CustomWidget(context: context)
            //                 .CustomSizedTextStyle(
            //                 14.0,
            //                 Theme.of(context).primaryColor,
            //                 FontWeight.w500,
            //                 'FontRegular'),
            //           ),
            //           value: value,
            //         ))
            //             .toList(),
            //         onChanged: (value) async {
            //           setState(() {
            //             selectedGender = value.toString();
            //           });
            //         },
            //         hint: Text(
            //           "Select Category",
            //           style: CustomWidget(context: context)
            //               .CustomSizedTextStyle(
            //               14.0,
            //               Theme.of(context).primaryColor,
            //               FontWeight.w500,
            //               'FontRegular'),
            //         ),
            //         isExpanded: true,
            //         value: selectedGender,
            //         icon: const Icon(
            //           Icons.arrow_drop_down,
            //           // color: AppColors.otherTextColor,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10.0,
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
                          FontWeight.w300,
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
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).canvasColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: CustomTheme.of(context).canvasColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                    items: countryList
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.name!.toString(),
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
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    isExpanded: true,
                    value: selectedCountryType,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      // color: AppColors.otherTextColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: cityController,
              // autocorrect: _autoValidate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // focusNode: emailFocus,
              maxLines: 1,
              // enabled: emailVerify,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style: CustomWidget(context: context).CustomTextStyle(
                  Theme.of(context).primaryColor,
                  FontWeight.w500,
                  'FontRegular'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 0, top: 2, bottom: 2),
                hintText: AppLocalizations.of(context)!.translate("loc_city"),
                hintStyle: CustomWidget(context: context)
                    .CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w300,
                    'FontRegular'),
                filled: true,
                fillColor: CustomTheme.of(context).canvasColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context)
                          .canvasColor,
                      width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context)
                          .canvasColor,
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor,
                      width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter City";
                }
                return null;
              },
            ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // TextFormField(
            //   controller: statesController,
            //   // autocorrect: _autoValidate,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   // focusNode: emailFocus,
            //   maxLines: 1,
            //   // enabled: emailVerify,
            //   textInputAction: TextInputAction.next,
            //   keyboardType: TextInputType.text,
            //   style: CustomWidget(context: context).CustomTextStyle(
            //       Theme.of(context).primaryColor,
            //       FontWeight.w500,
            //       'FontRegular'),
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.only(
            //         left: 12, right: 0, top: 2, bottom: 2),
            //     hintText: "State",
            //     hintStyle: CustomWidget(context: context)
            //         .CustomSizedTextStyle(
            //         14.0,
            //         Theme.of(context).dividerColor,
            //         FontWeight.w300,
            //         'FontRegular'),
            //     filled: true,
            //     fillColor: CustomTheme.of(context).canvasColor,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context).canvasColor,
            //           width: 1.0),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(color: Colors.red, width: 1.0),
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return "Please enter State";
            //     }
            //     return null;
            //   },
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // TextFormField(
            //   controller: zipController,
            //   // autocorrect: _autoValidate,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   // focusNode: emailFocus,
            //   maxLines: 1,
            //   // enabled: emailVerify,
            //   textInputAction: TextInputAction.next,
            //   keyboardType: TextInputType.number,
            //   style: CustomWidget(context: context).CustomTextStyle(
            //       Theme.of(context).primaryColor,
            //       FontWeight.w500,
            //       'FontRegular'),
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.only(
            //         left: 12, right: 0, top: 2, bottom: 2),
            //     hintText: "Zip / Postal Code",
            //     hintStyle: CustomWidget(context: context)
            //         .CustomSizedTextStyle(
            //         14.0,
            //         Theme.of(context).dividerColor,
            //         FontWeight.w300,
            //         'FontRegular'),
            //     filled: true,
            //     fillColor: CustomTheme.of(context).canvasColor,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1.0),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(color: Colors.red, width: 1.0),
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return "Please enter Zip code";
            //     }
            //     return null;
            //   },
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // TextFormField(
            //   controller: addressController,
            //   // autocorrect: _autoValidate,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   // focusNode: emailFocus,
            //   maxLines: 5,
            //   // enabled: emailVerify,
            //   textInputAction: TextInputAction.next,
            //   keyboardType: TextInputType.streetAddress,
            //   style: CustomWidget(context: context).CustomTextStyle(
            //       Theme.of(context).primaryColor,
            //       FontWeight.w500,
            //       'FontRegular'),
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.only(
            //         left: 12, right: 0, top: 2, bottom: 2),
            //     hintText: "Address Line 1",
            //     hintStyle: CustomWidget(context: context)
            //         .CustomSizedTextStyle(
            //         14.0,
            //         Theme.of(context).dividerColor,
            //         FontWeight.w300,
            //         'FontRegular'),
            //     filled: true,
            //     fillColor: CustomTheme.of(context).canvasColor,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context).canvasColor,
            //           width: 1.0),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(color: Colors.red, width: 1.0),
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return "Please enter Address Line1 ";
            //     }
            //     return null;
            //   },
            // ),
            SizedBox(
              height: 10.0,
            ),
            // TextFormField(
            //   controller: addressLineController,
            //   // autocorrect: _autoValidate,
            //   autovalidateMode: AutovalidateMode.onUserInteraction,
            //   // focusNode: emailFocus,
            //   maxLines: 5,
            //   // enabled: emailVerify,
            //   textInputAction: TextInputAction.next,
            //   keyboardType: TextInputType.streetAddress,
            //   style: CustomWidget(context: context).CustomTextStyle(
            //       Theme.of(context).primaryColor,
            //       FontWeight.w500,
            //       'FontRegular'),
            //   decoration: InputDecoration(
            //     contentPadding: const EdgeInsets.only(
            //         left: 12, right: 0, top: 2, bottom: 2),
            //     hintText: "Address Line 2",
            //     hintStyle: CustomWidget(context: context)
            //         .CustomSizedTextStyle(
            //         14.0,
            //         Theme.of(context).dividerColor,
            //         FontWeight.w300,
            //         'FontRegular'),
            //     filled: true,
            //     fillColor: CustomTheme.of(context).canvasColor,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1.0),
            //     ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context)
            //               .canvasColor,
            //           width: 1),
            //     ),
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(
            //           color: CustomTheme.of(context).canvasColor,
            //           width: 1.0),
            //     ),
            //     errorBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(5),
            //       borderSide: BorderSide(color: Colors.red, width: 1.0),
            //     ),
            //   ),
            //   validator: (value) {
            //     if (value!.isEmpty) {
            //       return "Please enter Address Line 2 ";
            //     }
            //     return null;
            //   },
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(12.0, 0.0, 12, 0.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).canvasColor, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: CustomTheme.of(context).canvasColor,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
                    items: idProofType
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value.toString(),
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
                        selectedIdProof = value.toString();
                      });
                    },
                    hint: Text(
                      "Select Category",
                      style: CustomWidget(context: context)
                          .CustomSizedTextStyle(
                              14.0,
                              Theme.of(context).cardColor,
                              FontWeight.w500,
                              'FontRegular'),
                    ),
                    isExpanded: true,
                    value: selectedIdProof,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      // color: AppColors.otherTextColor,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: idController,
              // focusNode: emailFocus,
              maxLines: 1,
              // autocorrect: _autoValidate,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // enabled: emailVerify,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.text,
              style: CustomWidget(context: context).CustomTextStyle(
                  Theme.of(context).cardColor,
                  FontWeight.w500,
                  'FontRegular'),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(
                    left: 12, right: 0, top: 2, bottom: 2),
                hintText: AppLocalizations.of(context)!.translate("loc_id_num"),
                hintStyle: CustomWidget(context: context).CustomSizedTextStyle(
                    14.0,
                    Theme.of(context).dividerColor,
                    FontWeight.w300,
                    'FontRegular'),
                filled: true,
                fillColor: CustomTheme.of(context).canvasColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: CustomTheme.of(context).canvasColor, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red, width: 1.0),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Please enter Id Number";
                }

                return null;
              },
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap: () {
                selectedExpiryDate = DateTime((DateTime.now()).year,
                    (DateTime.now()).month, (DateTime.now()).day);
                _selectExpiryDate(
                    context,
                    true,
                    DateTime(selectedExpiryDate!.year,
                        selectedExpiryDate!.month, selectedExpiryDate!.day),
                    DateTime(selectedExpiryDate!.year,
                        selectedExpiryDate!.month, selectedExpiryDate!.day),
                    DateTime(selectedExpiryDate!.year + 10,
                        selectedExpiryDate!.month, selectedExpiryDate!.day));
              },
              child: TextFormField(
                controller: expController,
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
                  hintText: AppLocalizations.of(context)!.translate("loc_exp_date"),
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
                        color: CustomTheme.of(context).canvasColor, width: 1.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: CustomTheme.of(context).canvasColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: CustomTheme.of(context).canvasColor, width: 1.0),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: CustomTheme.of(context).canvasColor, width: 1),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.red, width: 1.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate("loc_notes").toString().toUpperCase(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).hoverColor,
                      FontWeight.w600,
                      'FontRegular'),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  AppLocalizations.of(context)!.translate("loc_kyc_dis").toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      13.0,
                      Theme.of(context).cardColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    loading = true;
                    if(dobController.text.isEmpty)
                    {

                      CustomWidget(context: context).showSuccessAlertDialog(
                          "Verify KYC", "Select DOB Date", "error");
                    }
                   else if(expController.text.isEmpty)
                      {

                        CustomWidget(context: context).showSuccessAlertDialog(
                            "Verify KYC", "Select ID Expiry Date", "error");
                      }
                    else
                      {
                        updateKyc();
                      }

                  });
                }
              },
              child: Container(
                padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      CustomTheme.of(context).primaryColorLight,
                      CustomTheme.of(context).primaryColorDark,
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Text(
                  verify
                      ? AppLocalizations.of(context)!.translate("loc_submit").toString()
                      : AppLocalizations.of(context)!.translate("loc_verify_details").toString(),
                  style: CustomWidget(context: context).CustomSizedTextStyle(
                      16.0,
                      CustomTheme.of(context).primaryColor,
                      FontWeight.w500,
                      'FontRegular'),
                ),
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget frontID() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              onRequestPermission(true);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).canvasColor, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    size: 25.0,
                    color: CustomTheme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    PanImg == "img65"
                        ? AppLocalizations.of(context)!.translate("loc_front_document_id").toString()
                        : AppLocalizations.of(context)!.translate("loc_doc_captured").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        13.0,
                        Theme.of(context).primaryColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("loc_notes").toString().toUpperCase(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).unselectedWidgetColor,
                    FontWeight.w600,
                    'FontRegular'),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                AppLocalizations.of(context)!.translate("loc_kyc_dis").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          InkWell(
            onTap: () {
              if (_formKey.currentState!.validate()) {
                if (AadharImg == "img64") {
                  // CustomWidget(context: context)
                  //     .custombar("Verify KYC", "Please Choose the ID Front Document ", false);
                } else if (PanImg == "img65") {
                  // CustomWidget(context: context)
                  //     .custombar("Verify KYC", "Please Choose the ID Back Document ", false);
                } else {
                  setState(() {
                    loading = true;
                    updateKyc();
                  });
                }
              }
            },
            child: Container(
              padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    CustomTheme.of(context).primaryColorLight,
                    CustomTheme.of(context).primaryColorDark,
                  ],
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                verify
                    ? AppLocalizations.of(context)!.translate("loc_submit").toString()
                    : AppLocalizations.of(context)!.translate("loc_verify_details").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    16.0,
                    CustomTheme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget backID() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              onRequestPermission(false);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(10, 50.0, 10, 40.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: CustomTheme.of(context).canvasColor, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
                color: CustomTheme.of(context).canvasColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    size: 25.0,
                    color: CustomTheme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    AadharImg == "img64"
                        ? AppLocalizations.of(context)!.translate("loc_back_document_id").toString()
                        : AppLocalizations.of(context)!.translate("loc_back_doc_cap").toString(),
                    textAlign: TextAlign.center,
                    style: CustomWidget(context: context).CustomSizedTextStyle(
                        13.0,
                        Theme.of(context).primaryColor,
                        FontWeight.w500,
                        'FontRegular'),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.translate("loc_notes").toString().toUpperCase(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).unselectedWidgetColor,
                    FontWeight.w600,
                    'FontRegular'),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                AppLocalizations.of(context)!.translate("loc_kyc_dis").toString(),
                style: CustomWidget(context: context).CustomSizedTextStyle(
                    13.0,
                    Theme.of(context).cardColor,
                    FontWeight.w500,
                    'FontRegular'),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          // InkWell(
          //   onTap: () {
          //     if (_formKey.currentState!.validate()) {
          //       if (AadharImg == "img64") {
          //         // CustomWidget(context: context)
          //         //     .custombar("Verify KYC", "Please Choose the ID Front Document ", false);
          //       } else if (PanImg == "img65") {
          //         // CustomWidget(context: context)
          //         //     .custombar("Verify KYC", "Please Choose the ID Back Document ", false);
          //       } else {
          //         setState(() {
          //           loading = true;
          //           updateKyc();
          //         });
          //       }
          //     }
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          //     alignment: Alignment.center,
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //         colors: <Color>[
          //           CustomTheme.of(context).backgroundColor,
          //           CustomTheme.of(context).bottomAppBarColor,
          //         ],
          //         tileMode: TileMode.mirror,
          //       ),
          //       borderRadius: BorderRadius.circular(5.0),
          //     ),
          //     child: Text(
          //       verify
          //           ? AppLocalizations.of(context)!.translate("loc_submit")
          //           : "Verify Details",
          //       style: CustomWidget(context: context).CustomSizedTextStyle(
          //           17.0,
          //           CustomTheme.of(context).cardColor,
          //           FontWeight.w500,
          //           'FontRegular'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  onRequestPermission(bool type) async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      // You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
        Permission.camera,
      ].request();
      _pickedImageDialog(type);
    } else {
      _pickedImageDialog(type);
    }
  }

  _pickedImageDialog(bool type) {
    showModalBottomSheet<void>(
      //background color for modal bottom screen
      backgroundColor: AppColors.backgroundColor,
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
                          .CustomSizedTextStyle(16.0, AppColors.blackColor,
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
                        Flexible(
                          flex: 4,
                          child: ButtonCustom(
                              text: AppLocalizations.of(context)!.translate("loc_gallery").toString(),
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              shadowColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.gallery, type);
                                });
                              },
                              paddng: const EdgeInsets.symmetric(horizontal: 1,vertical: 8)),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                          flex: 4,
                          child: ButtonCustom(
                              text: AppLocalizations.of(context)!.translate("loc_cam").toString(),
                              iconEnable: false,
                              radius: 5.0,
                              icon: "",
                              textStyle: CustomWidget(context: context)
                                  .CustomSizedTextStyle(
                                      18.0,
                                      AppColors.whiteColor,
                                      FontWeight.w500,
                                      'FontRegular'),
                              iconColor: AppColors.appColor,
                              shadowColor: AppColors.appColor,
                              splashColor: AppColors.appColor,
                              onPressed: () {
                                setState(() {
                                  Navigator.pop(context);
                                  getImage(ImageSource.camera, type);
                                });
                              },
                              paddng: const EdgeInsets.symmetric(horizontal: 1,vertical: 8)),
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

  /// Get from gallery
  getImage(ImageSource type, bool imageType) async {
    var pickedFile = await picker.pickImage(source: type);
    if (pickedFile != null) {
      if (imageType) {
        setState(() {
          PanImg = pickedFile.path;
          loading = true;

          updateKycfront();
        });
      } else {
        setState(() {
          AadharImg = pickedFile.path;
          loading = true;

          updateKycback();
        });
      }
    }
  }

  updateKyc() {
    apiUtils
        .updateKYCDetails(
            firstNameController.text.toString(),
            lastNameController.text.toString(),
            dobController.text.toString(),
            selectedCountryType!.code.toString(),
            cityController.text.toString(),
            selectedIdProof.toString(),
            idController.text.toString(),
            expController.text.toString())
        .then((KycDetailsUpdateModel loginData) {
      if (loginData.success!) {
        setState(() {
          loading = false;

          frontStatus = true;
          kycID = loginData.result!.id.toString();
        });

        CustomWidget(context: context).showSuccessAlertDialog(
            "Verify KYC", loginData.message.toString(), "success");
      } else {
        setState(() {
          loading = false;

          frontStatus = true;
          kycID = loginData.result!.id.toString();
          CustomWidget(context: context).showSuccessAlertDialog(
              "Verify KYC", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  updateKycfront() {
    apiUtils.updateKycFrontUpload(kycID, PanImg).then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;

          frontStatus=false;

          backStatus = true;
        });

        CustomWidget(context: context).showSuccessAlertDialog(
            "Verify KYC", loginData.message.toString(), "success");
      } else {
        setState(() {
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              "Verify KYC", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
    });
  }

  updateKycback() {
    apiUtils
        .updateKycBackUpload(kycID, AadharImg)
        .then((CommonModel loginData) {
      if (loginData.status!) {
        setState(() {
          loading = false;

          backStatus = true;
        });

        CustomWidget(context: context).showSuccessAlertDialog(
            "Verify KYC", loginData.message.toString(), "success");

        Navigator.pop(context);
      } else {
        setState(() {
          loading = false;

          CustomWidget(context: context).showSuccessAlertDialog(
              "Verify KYC", loginData.message.toString(), "error");
        });
      }
    }).catchError((Object error) {
      print(error);
      setState(() {
        loading = false;
      });
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

  getCountryCodeDetils() {
    apiUtils.countryCodeDetils().then((CountryCodeModelDetails loginData) {
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
