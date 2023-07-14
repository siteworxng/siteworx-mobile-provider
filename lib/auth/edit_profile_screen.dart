import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/components/add_known_languages_component.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/city_list_response.dart';
import 'package:provider/models/country_list_response.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:provider/models/state_list_response.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/add_skill_component.dart';
import '../models/user_update_response.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  File? imageFile;
  XFile? pickedFile;

  List<CountryListResponse> countryList = [];
  List<StateListResponse> stateList = [];
  List<CityListResponse> cityList = [];
  List<String> knownLanguages = [];
  List<String> skills = [];

  List<AddressResponse> serviceAddressList = [];
  AddressResponse? selectedAddress;

  CountryListResponse? selectedCountry;
  StateListResponse? selectedState;
  CityListResponse? selectedCity;

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();
  TextEditingController knownLangCont = TextEditingController();
  TextEditingController skillsCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode designationFocus = FocusNode();
  FocusNode knownLangFocus = FocusNode();
  FocusNode skillsFocus = FocusNode();

  int countryId = 0;
  int stateId = 0;
  int cityId = 0;
  int? serviceAddressId;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
      appStore.setLoading(true);
    });

    if (isUserTypeHandyman) await getAddressList();

    countryId = getIntAsync(COUNTRY_ID).validate();
    stateId = getIntAsync(STATE_ID).validate();
    cityId = getIntAsync(CITY_ID).validate();

    fNameCont.text = appStore.userFirstName.validate();
    lNameCont.text = appStore.userLastName.validate();
    emailCont.text = appStore.userEmail.validate();
    userNameCont.text = appStore.userName.validate();
    mobileCont.text = '${appStore.userContactNumber.validate()}';
    countryId = appStore.countryId.validate();
    stateId = appStore.stateId.validate();
    cityId = appStore.cityId.validate();
    addressCont.text = appStore.address.validate();
    serviceAddressId = appStore.serviceAddressId.validate();
    designationCont.text = appStore.designation.validate();

    getUserDetail(appStore.userId!).then((value) {
      String tempLanguages = value.data!.knownLanguages.validate();

      if (tempLanguages.isNotEmpty && tempLanguages.isJson()) {
        Iterable it = jsonDecode(tempLanguages);
        knownLanguages.addAll(it.map((e) => e.toString()).toList());
      }

      String tempSkills = value.data!.skills.validate();

      if (tempSkills.isNotEmpty && tempSkills.isJson()) {
        Iterable it = jsonDecode(tempSkills);
        skills.addAll(it.map((e) => e.toString()).toList());
      }
      descriptionCont.text = value.data!.description.validate();
      addressCont.text = value.data!.address.validate();

      setState(() {});
    }).catchError(onError);

    if (getIntAsync(COUNTRY_ID) != 0) {
      await getCountry();
      await getStates(getIntAsync(COUNTRY_ID));
      if (getIntAsync(STATE_ID) != 0) {
        await getCity(getIntAsync(STATE_ID));
      }

      setState(() {});
    } else {
      await getCountry();
    }
  }

  Future<void> getAddressList() async {
    await getAddresses(providerId: appStore.providerId).then((value) {
      serviceAddressList.addAll(value.addressResponse!);
      value.addressResponse!.forEach((e) {
        if (e.id == getIntAsync(SERVICE_ADDRESS_ID)) {
          selectedAddress = e;
        }
      });
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  Future<void> getCountry() async {
    await getCountryList().then((value) async {
      countryList.clear();
      countryList.addAll(value);
      setState(() {});
      value.forEach((e) {
        if (e.id == getIntAsync(COUNTRY_ID)) {
          selectedCountry = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getStates(int countryId) async {
    appStore.setLoading(true);
    await getStateList({'country_id': countryId}).then((value) async {
      stateList.clear();
      stateList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(STATE_ID)) {
          selectedState = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> getCity(int stateId) async {
    appStore.setLoading(true);

    await getCityList({'state_id': stateId}).then((value) async {
      cityList.clear();
      cityList.addAll(value);
      value.forEach((e) {
        if (e.id == getIntAsync(CITY_ID)) {
          selectedCity = e;
        }
      });
    }).catchError((e) {
      toast('$e', print: true);
    });
    appStore.setLoading(false);
  }

  Future<void> update() async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
    multiPartRequest.fields[UserKeys.firstName] = fNameCont.text;
    multiPartRequest.fields[UserKeys.lastName] = lNameCont.text;
    multiPartRequest.fields[UserKeys.userName] = userNameCont.text;
    multiPartRequest.fields[UserKeys.userType] = getStringAsync(USER_TYPE);
    multiPartRequest.fields[UserKeys.contactNumber] = mobileCont.text;
    multiPartRequest.fields[UserKeys.email] = emailCont.text;
    multiPartRequest.fields[UserKeys.countryId] = countryId.toString();
    multiPartRequest.fields[UserKeys.stateId] = stateId.toString();
    multiPartRequest.fields[UserKeys.cityId] = cityId.toString();
    multiPartRequest.fields[CommonKeys.address] = addressCont.text.validate();
    multiPartRequest.fields[UserKeys.designation] = designationCont.text.validate();
    multiPartRequest.fields[UserKeys.knownLanguages] = jsonEncode(knownLanguages);
    multiPartRequest.fields[UserKeys.skills] = jsonEncode(skills);
    multiPartRequest.fields[UserKeys.description] = descriptionCont.text.validate();
    multiPartRequest.fields[UserKeys.displayName] = '${fNameCont.text.validate() + " " + lNameCont.text.validate()}';

    if (isUserTypeHandyman && serviceAddressId != null) multiPartRequest.fields[UserKeys.serviceAddressId] = serviceAddressId.toString();
    if (imageFile != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(UserKeys.profileImage, imageFile!.path));
    } else {
      Image.asset(ic_home, fit: BoxFit.cover);
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());

    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        if (data != null) {
          if ((data as String).isJson()) {
            UserUpdateResponse res = UserUpdateResponse.fromJson(jsonDecode(data));
            saveUserData(res.data!);
            finish(context);
            snackBar(context, title: res.message!);

            finish(context);
          }
        }
      },
      onError: (error) {
        toast(error.toString(), print: true);
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void _getFromGallery() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      _showSelectionDialog(context);
    }
  }

  _getFromCamera() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.camera, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      _showSelectionDialog(context);
    }
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showConfirmDialogCustom(
      context,
      title: languages.confirmationRequestTxt,
      positiveText: languages.lblOk,
      negativeText: languages.lblNo,
      primaryColor: context.primaryColor,
      onAccept: (BuildContext context) async {
        imageFile = File(pickedFile!.path);
        setState(() {});
      },
      onCancel: (BuildContext context) {
        imageFile = null;
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: context.cardColor,
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SettingItemWidget(
              title: languages.lblGallery,
              leading: Icon(Icons.image, color: context.iconColor),
              onTap: () async {
                _getFromGallery();
                finish(context);
              },
            ),
            SettingItemWidget(
              title: languages.camera,
              leading: Icon(Icons.camera, color: context.iconColor),
              onTap: () {
                _getFromCamera();
                finish(context);
              },
            ),
          ],
        ).paddingAll(16.0);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => SafeArea(
        child: Scaffold(
          appBar: appBarWidget(
            languages.editProfile,
            textColor: white,
            color: context.primaryColor,
            backWidget: BackWidget(),
            showBack: true,
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Stack(
                          children: [
                            Container(
                              decoration: boxDecorationDefault(
                                border: Border.all(color: context.scaffoldBackgroundColor, width: 4),
                                shape: BoxShape.circle,
                              ),
                              child: imageFile != null
                                  ? Image.file(imageFile!, width: 90, height: 90, fit: BoxFit.cover).cornerRadiusWithClipRRect(45)
                                  : Observer(
                                      builder: (_) => CachedImageWidget(
                                        url: appStore.userProfileImage,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        radius: 64,
                                      ),
                                    ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 2,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  backgroundColor: primaryColor,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Icon(AntDesign.camera, color: Colors.white, size: 16).paddingAll(4.0),
                              ).onTap(() async {
                                _showBottomSheet(context);
                              }),
                            )
                          ],
                        ),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: fNameCont,
                        focus: fNameFocus,
                        nextFocus: lNameFocus,
                        decoration: inputDecoration(context, hint: languages.hintFirstNameTxt),
                        suffix: profile.iconImage(size: 10).paddingAll(14),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: lNameCont,
                        focus: lNameFocus,
                        nextFocus: userNameFocus,
                        decoration: inputDecoration(context, hint: languages.hintLastNameTxt),
                        suffix: profile.iconImage(size: 10).paddingAll(14),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: userNameCont,
                        focus: userNameFocus,
                        nextFocus: emailFocus,
                        decoration: inputDecoration(context, hint: languages.hintUserNameTxt),
                        suffix: profile.iconImage(size: 10).paddingAll(14),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.EMAIL_ENHANCED,
                        controller: emailCont,
                        focus: emailFocus,
                        nextFocus: mobileFocus,
                        decoration: inputDecoration(context, hint: languages.hintEmailAddressTxt),
                        suffix: ic_message.iconImage(size: 10).paddingAll(14),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: isAndroid ? TextFieldType.PHONE : TextFieldType.NAME,
                        controller: mobileCont,
                        focus: mobileFocus,
                        decoration: inputDecoration(context, hint: languages.hintContactNumberTxt),
                        suffix: calling.iconImage(size: 10).paddingAll(14),
                        validator: (mobileCont) {
                          if (mobileCont!.isEmpty) return languages.lblPleaseEnterMobileNumber;
                          if (isIOS && !RegExp(r"^([0-9]{1,5})-([0-9]{1,10})$").hasMatch(mobileCont)) {
                            return languages.inputMustBeNumberOrDigit;
                          }
                          if (!mobileCont.trim().contains('-')) return '"-" ${languages.requiredAfterCountryCode}';
                          return null;
                        },
                      ),
                      12.height,
                      Align(
                        alignment: Alignment.centerRight,
                        child: mobileNumberInfoWidget(context),
                      ),
                      16.height,
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        controller: designationCont,
                        isValidationRequired: false,
                        focus: designationFocus,
                        decoration: inputDecoration(context, hint: languages.lblDesignation),
                      ),
                      16.height,
                      Row(
                        children: [
                          DropdownButtonFormField<CountryListResponse>(
                            decoration: inputDecoration(context, hint: languages.selectCountry),
                            isExpanded: true,
                            menuMaxHeight: 300,
                            value: selectedCountry,
                            dropdownColor: context.cardColor,
                            items: countryList.map((CountryListResponse e) {
                              return DropdownMenuItem<CountryListResponse>(
                                value: e,
                                child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                              );
                            }).toList(),
                            onChanged: (CountryListResponse? value) async {
                              countryId = value!.id!;
                              selectedCountry = value;
                              selectedState = null;
                              selectedCity = null;
                              setState(() {});

                              getStates(value.id!);
                            },
                          ).expand(),
                          8.width.visible(stateList.isNotEmpty),
                          if (stateList.isNotEmpty)
                            DropdownButtonFormField<StateListResponse>(
                              decoration: inputDecoration(context, hint: languages.selectState),
                              isExpanded: true,
                              dropdownColor: context.cardColor,
                              menuMaxHeight: 300,
                              value: selectedState,
                              items: stateList.map((StateListResponse e) {
                                return DropdownMenuItem<StateListResponse>(
                                  value: e,
                                  child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                );
                              }).toList(),
                              onChanged: (StateListResponse? value) async {
                                selectedCity = null;
                                selectedState = value;
                                stateId = value!.id!;
                                setState(() {});

                                getCity(value.id!);
                              },
                            ).expand(),
                        ],
                      ),
                      16.height,
                      if (cityList.isNotEmpty)
                        Column(
                          children: [
                            DropdownButtonFormField<CityListResponse>(
                              decoration: inputDecoration(context),
                              hint: Text(languages.selectCity, style: primaryTextStyle()),
                              isExpanded: true,
                              menuMaxHeight: 400,
                              value: selectedCity,
                              dropdownColor: context.cardColor,
                              items: cityList.map(
                                (CityListResponse e) {
                                  return DropdownMenuItem<CityListResponse>(
                                    value: e,
                                    child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  );
                                },
                              ).toList(),
                              onChanged: (CityListResponse? value) async {
                                selectedCity = value;
                                cityId = value!.id!;

                                setState(() {});
                              },
                            ),
                            16.height,
                          ],
                        ),
                      if (isUserTypeHandyman && serviceAddressList.isNotEmpty)
                        DropdownButtonFormField<AddressResponse>(
                          decoration: inputDecoration(context, hint: languages.lblSelectAddress),
                          isExpanded: true,
                          value: selectedAddress != null ? selectedAddress : null,
                          dropdownColor: context.cardColor,
                          items: serviceAddressList.map((AddressResponse data) {
                            return DropdownMenuItem<AddressResponse>(
                              value: data,
                              child: Text(data.address.validate(), style: primaryTextStyle()),
                            );
                          }).toList(),
                          onChanged: (AddressResponse? value) async {
                            selectedAddress = value;
                            serviceAddressId = selectedAddress!.id.validate();
                            setState(() {});
                          },
                        ).paddingTop(16),
                      if (isUserTypeHandyman && serviceAddressList.isNotEmpty) 16.height,
                      AppTextField(
                        controller: addressCont,
                        textFieldType: TextFieldType.MULTILINE,
                        maxLines: 5,
                        minLines: 3,
                        decoration: inputDecoration(context, hint: languages.hintAddress),
                      ),
                      16.height,
                      Text(languages.knownLanguages, style: secondaryTextStyle()),
                      8.height,
                      Wrap(
                        children: knownLanguages.map((e) {
                          return Stack(
                            children: [
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                margin: EdgeInsets.all(4),
                                child: Text(e, style: primaryTextStyle()),
                              ),
                              Positioned(
                                right: 1,
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ).onTap(() {
                                  knownLanguages.remove(e);
                                  setState(() {});
                                }),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () async {
                          String? res = await showInDialog(
                            context,
                            contentPadding: EdgeInsets.zero,
                            builder: (p0) {
                              return AddKnownLanguagesComponent();
                            },
                          );

                          if (res != null) {
                            knownLanguages.add(res);
                            setState(() {});
                          }
                        },
                        child: Text(languages.addKnownLanguage, style: primaryTextStyle(color: context.primaryColor)),
                      ),
                      16.height,
                      Text(languages.essentialSkills, style: secondaryTextStyle()),
                      8.height,
                      Wrap(
                        children: skills.map((e) {
                          return Stack(
                            children: [
                              Container(
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                                  backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                margin: EdgeInsets.all(4),
                                child: Text(e, style: primaryTextStyle()),
                              ),
                              Positioned(
                                right: 1,
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ).onTap(() {
                                  skills.remove(e);
                                  setState(() {});
                                }),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () async {
                          String? res = await showInDialog(
                            context,
                            contentPadding: EdgeInsets.all(0),
                            builder: (p0) {
                              return AddSkillComponent();
                            },
                          );

                          if (res != null) {
                            skills.add(res);
                            setState(() {});
                          }
                        },
                        child: Text(languages.addEssentialSkill, style: primaryTextStyle(color: context.primaryColor)),
                      ),
                      16.height,
                      AppTextField(
                        controller: descriptionCont,
                        textFieldType: TextFieldType.MULTILINE,
                        maxLines: 5,
                        minLines: 3,
                        decoration: inputDecoration(context, hint: languages.aboutYou),
                        isValidationRequired: false,
                      ),
                      28.height,
                      AppButton(
                        text: languages.saveChanges,
                        height: 40,
                        color: primaryColor,
                        textStyle: primaryTextStyle(color: white),
                        width: context.width() - context.navigationBarHeight,
                        onTap: () {
                          ifNotTester(context, () {
                            update();
                          });
                        },
                      ),
                      24.height,
                    ],
                  ),
                ),
              ),
              Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
            ],
          ),
        ),
      ),
    );
  }
}
