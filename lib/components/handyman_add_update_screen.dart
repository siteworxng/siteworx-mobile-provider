import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanAddUpdateScreen extends StatefulWidget {
  final String? userType;
  final UserData? data;
  final Function? onUpdate;

  HandymanAddUpdateScreen({this.userType, this.data, this.onUpdate});

  @override
  HandymanAddUpdateScreenState createState() => HandymanAddUpdateScreenState();
}

class HandymanAddUpdateScreenState extends State<HandymanAddUpdateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();
  TextEditingController designationCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();
  FocusNode designationFocus = FocusNode();

  List<AddressResponse> serviceAddressList = [];
  AddressResponse? selectedServiceAddress;

  int? serviceAddressId;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      isUpdate = true;
      fNameCont.text = widget.data!.firstName.validate();
      lNameCont.text = widget.data!.lastName.validate();
      emailCont.text = widget.data!.email.validate();
      userNameCont.text = widget.data!.username.validate();
      mobileCont.text = widget.data!.contactNumber.validate();
      serviceAddressId = widget.data!.serviceAddressId.validate();
      designationCont.text = widget.data!.designation.validate();
    }

    init();
    afterBuildCreated(() {
      appStore.setLoading(true);
    });
  }

  Future<void> init() async {
    getAddressList();
  }

  Future<void> getAddressList() async {
    getAddresses(providerId: appStore.userId).then((value) {
      appStore.setLoading(false);
      serviceAddressList.addAll(value.addressResponse!);

      serviceAddressList.forEach((e) {
        if (e.id == serviceAddressId) {
          selectedServiceAddress = e;
        }
      });
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Register the Handyman
  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      String? type = widget.userType;

      var request = {
        if (isUpdate) CommonKeys.id: widget.data!.id,
        UserKeys.firstName: fNameCont.text,
        UserKeys.lastName: lNameCont.text,
        UserKeys.userName: userNameCont.text,
        UserKeys.userType: type,
        UserKeys.providerId: appStore.userId,
        UserKeys.status: USER_STATUS_CODE,
        UserKeys.contactNumber: mobileCont.text,
        UserKeys.designation: designationCont.text.validate(),
        if (serviceAddressId != null && serviceAddressId != -1) UserKeys.serviceAddressId: serviceAddressId.validate(),
        UserKeys.email: emailCont.text,
        if (!isUpdate) UserKeys.password: passwordCont.text
      };

      appStore.setLoading(true);
      if (isUpdate) {
        await updateProfile(request).then((res) async {
          toast(res.message.validate());
          finish(context, widget.onUpdate!.call());
        }).catchError((e) {
          toast(e.toString());
        });
      } else {
        await registerUser(request).then((res) async {
          toast(res.message.validate());
          finish(context, widget.onUpdate!.call());
        }).catchError((e) {
          toast(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  /// Remove the Handyman
  Future<void> removeHandyman(int? id) async {
    appStore.setLoading(true);
    await deleteHandyman(id.validate()).then((value) {
      appStore.setLoading(false);

      finish(context, widget.onUpdate!.call());

      toast(languages.lblTrashHandyman, print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// Restore the Handyman
  Future<void> restoreHandymanData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: RESTORE,
    };

    await restoreHandyman(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, widget.onUpdate!.call());
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  /// ForceFully Delete the Handyman
  Future<void> forceDeleteHandymanData() async {
    appStore.setLoading(true);
    var req = {
      CommonKeys.id: widget.data!.id,
      type: FORCE_DELETE,
    };

    await restoreHandyman(req).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      finish(context, widget.onUpdate!.call());
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.cardColor,
        appBar: appBarWidget(
          isUpdate ? languages.lblUpdate : languages.lblAddHandyman,
          textColor: white,
          color: context.primaryColor,
          backWidget: BackWidget(),
          showBack: true,
          actions: [
            if (isUpdate)
              PopupMenuButton(
                icon: Icon(Icons.more_vert, size: 24, color: white),
                onSelected: (selection) async {
                  if (selection == 1) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToDelete,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          removeHandyman(widget.data!.id.validate());
                        });
                      },
                    );
                  } else if (selection == 2) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToRestore,
                      positiveText: languages.lblRestore,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          restoreHandymanData();
                        });
                      },
                    );
                  } else if (selection == 3) {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.DELETE,
                      title: languages.lblDoYouWantToDeleteForcefully,
                      positiveText: languages.lblDelete,
                      negativeText: languages.lblCancel,
                      onAccept: (_) {
                        ifNotTester(context, () {
                          forceDeleteHandymanData();
                        });
                      },
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text(languages.lblDelete),
                    value: 1,
                    enabled: widget.data!.deletedAt == null,
                    textStyle: boldTextStyle(color: widget.data!.deletedAt == null ? textPrimaryColorGlobal : null),
                  ),
                  PopupMenuItem(
                    child: Text(languages.lblRestore),
                    value: 2,
                    textStyle: boldTextStyle(color: widget.data!.deletedAt != null ? textPrimaryColorGlobal : null),
                    enabled: widget.data!.deletedAt != null,
                  ),
                  PopupMenuItem(
                    child: Text(languages.lblForceDelete),
                    textStyle: boldTextStyle(),
                    value: 3,
                    enabled: widget.data!.deletedAt != null,
                  ),
                ],
              ),
          ],
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
                    if (isUpdate) CachedImageWidget(url: widget.data!.profileImage.validate(value: profile), height: 100, circle: true, fit: BoxFit.cover).center(),
                    30.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: fNameCont,
                      focus: fNameFocus,
                      nextFocus: lNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintFirstNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.NAME,
                      controller: lNameCont,
                      focus: lNameFocus,
                      nextFocus: userNameFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintLastNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.USERNAME,
                      controller: userNameCont,
                      focus: userNameFocus,
                      nextFocus: emailFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintUserNameTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: profile.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL_ENHANCED,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: mobileFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintEmailAddressTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: ic_message.iconImage(size: 10).paddingAll(14),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: mobileCont,
                      focus: mobileFocus,
                      nextFocus: designationFocus,
                      isValidationRequired: false,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintContactNumberTxt,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      suffix: calling.iconImage(size: 10).paddingAll(14),
                      validator: (mobileCont) {
                        if (mobileCont!.isEmpty) return languages.lblPleaseEnterMobileNumber;
                        if (!mobileCont.trim().contains('-')) return '"-" ${languages.lblRequiredAfterCountryCode}';
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
                      nextFocus: passwordFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.lblDesignation,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                    ),
                    16.height,
                    DropdownButtonFormField<AddressResponse>(
                      decoration: inputDecoration(
                        context,
                        hint: languages.lblAddress,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      value: selectedServiceAddress != null ? selectedServiceAddress : null,
                      items: serviceAddressList.map((data) {
                        return DropdownMenuItem<AddressResponse>(
                          value: data,
                          child: Text(
                            data.address.validate(),
                            style: primaryTextStyle(),
                          ),
                        );
                      }).toList(),
                      onChanged: (AddressResponse? value) async {
                        selectedServiceAddress = value;
                        serviceAddressId = selectedServiceAddress!.id.validate();
                        setState(() {});
                      },
                    ).visible(serviceAddressList.isNotEmpty),
                    16.height.visible(!isUpdate),
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.hintPassword,
                        fillColor: context.scaffoldBackgroundColor,
                      ),
                      onFieldSubmitted: (s) {
                        ifNotTester(context, () {
                          register();
                        });
                      },
                    ).visible(!isUpdate),
                    16.height,
                    if (isUpdate)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.data!.displayName} ${languages.lblRegistered} ${DateTime.parse(widget.data!.createdAt!).timeAgo}\n${formatDate(widget.data!.createdAt!)}',
                              style: secondaryTextStyle()),
                          if (widget.data!.emailVerifiedAt.validate().isNotEmpty)
                            TextIcon(
                              text: '${languages.lblEmailIsVerified}',
                              textStyle: primaryTextStyle(color: Colors.green),
                              prefix: Container(
                                child: Icon(Icons.check, color: Colors.white, size: 14),
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                              ),
                            ).paddingTop(8),
                        ],
                      ),
                    24.height,
                    AppButton(
                      text: languages.btnSave,
                      height: 40,
                      color: primaryColor,
                      textColor: white,
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        ifNotTester(context, () {
                          register();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
          ],
        ),
      ),
    );
  }
}
