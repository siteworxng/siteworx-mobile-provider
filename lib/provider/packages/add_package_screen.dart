import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/app_theme.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/custom_image_picker.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/models/attachment_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/packages/components/selected_service_component.dart';
import 'package:provider/provider/packages/select_service_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/static_data_model.dart';
import '../../utils/model_keys.dart';

class AddPackageScreen extends StatefulWidget {
  final PackageData? data;

  AddPackageScreen({this.data});

  @override
  _AddPackageScreenState createState() => _AddPackageScreenState();
}

class _AddPackageScreenState extends State<AddPackageScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  TextEditingController packageNameCont = TextEditingController();
  TextEditingController packagePriceCont = TextEditingController();
  TextEditingController packageDescriptionCont = TextEditingController();
  TextEditingController startDateCont = TextEditingController();
  TextEditingController endDateCont = TextEditingController();

  FocusNode packagePriceFocus = FocusNode();
  FocusNode packageDescriptionFocus = FocusNode();
  FocusNode startDateFocus = FocusNode();
  FocusNode endDateFocus = FocusNode();

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];
  List<int> selectedService = [];

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];

  StaticDataModel? packageStatusModel;

  String packageStatus = '';
  int? selectedCategoryId = -1;
  int? selectedSubCategoryId = -1;

  DateTime currentDateTime = DateTime.now();
  DateTime? selectedDate;
  DateTime? finalDate;
  TimeOfDay? pickedTime;

  bool isFeature = false;
  bool isUpdate = false;
  String? isPackageTypeSingleCategory;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      appStore.selectedServiceList.clear();
      appStore.addAllSelectedPackageService(widget.data!.serviceList.validate());

      tempAttachments = widget.data!.attchments.validate();
      imageFiles = widget.data!.attchments.validate().map((e) => File(e.url.toString())).toList();
      packageNameCont.text = widget.data!.name.validate();
      packageDescriptionCont.text = widget.data!.description.validate();
      packagePriceCont.text = widget.data!.price.toString().validate();
      startDateCont.text = widget.data!.startDate != null ? formatDate(widget.data!.startDate.validate(), format: DATE_FORMAT_7).toString() : "";
      endDateCont.text = widget.data!.endDate != null ? formatDate(widget.data!.endDate.validate(), format: DATE_FORMAT_7).toString() : "";
      isFeature = widget.data!.isFeatured == 1 ? true : false;
      packageStatus = widget.data!.status.validate() == 1 ? ACTIVE : INACTIVE;
      if (packageStatus == ACTIVE) {
        packageStatusModel = statusListStaticData.first;
      } else {
        packageStatusModel = statusListStaticData[1];
      }
      selectedCategoryId = widget.data!.categoryId != null ? widget.data!.categoryId : selectedCategoryId;
      selectedSubCategoryId = widget.data!.subCategoryId != null ? widget.data!.subCategoryId : selectedSubCategoryId;

      isPackageTypeSingleCategory = widget.data!.packageType.validate() == PACKAGE_TYPE_SINGLE ? PACKAGE_TYPE_SINGLE : PACKAGE_TYPE_MULTIPLE;
    } else {
      appStore.selectedServiceList.clear();
      packageStatus = statusListStaticData.first.key!;
    }

    setState(() {});
  }

  // region Select Start Date and End Date
  void selectDateAndTime(BuildContext context, TextEditingController textEditingController, DateTime? abc) async {
    await showDatePicker(
      context: context,
      initialDate: abc ?? currentDateTime,
      firstDate: abc ?? currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme,
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        finalDate = DateTime(date.year, date.month, date.day);

        selectedDate = date;
        textEditingController.text = "${formatDate(selectedDate.toString(), format: DATE_FORMAT_7)}";
        setState(() {});
      }
    });
  }

  // endregion

  // region Remove Attachment

  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    Map req = {
      CommonKeys.type: PackageKey.removePackageAttachment,
      CommonKeys.id: id,
    };

    await deleteImage(req).then((value) {
      tempAttachments.validate().removeWhere((element) => element.id == id);

      uniqueKey = UniqueKey();

      setState(() {});

      appStore.setLoading(false);
      toast(value.message.validate(), print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      finish(context);
      toast(e.toString(), print: true);
    });
  }

  // endregion

  // region Form Widget
  Widget buildFormWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Wrap(
        runSpacing: 16,
        children: [
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                8.height,
                AppTextField(
                  controller: packageNameCont,
                  textFieldType: TextFieldType.NAME,
                  nextFocus: packageDescriptionFocus,
                  errorThisFieldRequired: context.translate.hintRequired,
                  decoration: inputDecoration(context, hint: languages.packageName, fillColor: context.scaffoldBackgroundColor),
                ),
                24.height,
                Observer(builder: (context) {
                  return Container(
                    width: context.width(),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    decoration: boxDecorationWithRoundedCorners(backgroundColor: context.scaffoldBackgroundColor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(languages.selectService, style: secondaryTextStyle()).paddingSymmetric(horizontal: 16, vertical: 12),
                            TextButton(
                              child: Text(appStore.selectedServiceList.isNotEmpty ? context.translate.lblEdit : languages.addService, style: boldTextStyle()),
                              onPressed: () async {
                                Map? res = await SelectServiceScreen(
                                        categoryId: selectedCategoryId, subCategoryId: selectedSubCategoryId, isUpdate: widget.data != null ? true : false, packageData: widget.data)
                                    .launch(context);

                                if (res != null && res["categoryId"] != null) {
                                  selectedCategoryId = res["categoryId"];

                                  if (res["subCategoryId"] != null) {
                                    selectedSubCategoryId = res["subCategoryId"];
                                  }

                                  if (res["packageType"] != null) {
                                    isPackageTypeSingleCategory = res["packageType"];
                                  }
                                }
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        if (appStore.selectedServiceList.isNotEmpty) SelectedServiceComponent()
                      ],
                    ),
                  );
                }),
                24.height,
                AppTextField(
                  controller: packageDescriptionCont,
                  textFieldType: TextFieldType.MULTILINE,
                  focus: packageDescriptionFocus,
                  nextFocus: packagePriceFocus,
                  minLines: 3,
                  maxLines: 5,
                  errorThisFieldRequired: context.translate.hintRequired,
                  decoration: inputDecoration(context, hint: languages.packageDescription, fillColor: context.scaffoldBackgroundColor),
                  validator: (value) {
                    if (value!.isEmpty) return context.translate.hintRequired;
                    return null;
                  },
                ),
                24.height,
                Row(
                  children: [
                    AppTextField(
                      controller: packagePriceCont,
                      textFieldType: TextFieldType.NUMBER,
                      focus: packagePriceFocus,
                      decoration: inputDecoration(
                        context,
                        hint: languages.packagePrice,
                        fillColor: context.scaffoldBackgroundColor,
                        prefix: Text(appStore.currencySymbol, style: primaryTextStyle(size: LABEL_TEXT_SIZE), textAlign: TextAlign.center),
                      ),
                    ).expand(),
                    16.width,

                    ///StaticDataModel logic : changes in active/ inactive status
                    DropdownButtonFormField<StaticDataModel>(
                      dropdownColor: context.scaffoldBackgroundColor,
                      value: packageStatusModel != null ? packageStatusModel : statusListStaticData.first,
                      items: statusListStaticData.map((StaticDataModel data) {
                        return DropdownMenuItem<StaticDataModel>(
                          value: data,
                          child: Text(data.value.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      decoration: inputDecoration(
                        context,
                        fillColor: context.scaffoldBackgroundColor,
                        hint: context.translate.lblStatus,
                      ),
                      onTap: () {
                        hideKeyboard(context);
                      },
                      onChanged: (StaticDataModel? value) async {
                        packageStatus = value!.key.validate();
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null) return errorThisFieldRequired;
                        return null;
                      },
                    ).expand(),
                  ],
                ),
                24.height,
                Row(
                  children: [
                    AppTextField(
                      controller: startDateCont,
                      textFieldType: TextFieldType.OTHER,
                      focus: startDateFocus,
                      decoration: inputDecoration(context, hint: languages.startDate, fillColor: context.scaffoldBackgroundColor),
                      isValidationRequired: false,
                      onTap: () {
                        hideKeyboard(context);
                        selectDateAndTime(context, startDateCont, currentDateTime);
                        endDateCont.text = "";
                        setState(() {});
                      },
                    ).expand(),
                    16.width,
                    AppTextField(
                      controller: endDateCont,
                      textFieldType: TextFieldType.OTHER,
                      focus: endDateFocus,
                      decoration: inputDecoration(context, hint: languages.endDate, fillColor: context.scaffoldBackgroundColor),
                      isValidationRequired: false,
                      onTap: () {
                        hideKeyboard(context);
                        selectDateAndTime(context, endDateCont, selectedDate);
                      },
                    ).expand(),
                  ],
                ),
                24.height,
                Container(
                  decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
                  child: CheckboxListTile(
                    value: isFeature,
                    contentPadding: EdgeInsets.zero,
                    checkboxShape: RoundedRectangleBorder(side: BorderSide(color: context.primaryColor), borderRadius: radius(4)),
                    shape: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                    title: Text(languages.hintSetAsFeature, style: secondaryTextStyle()),
                    onChanged: (bool? v) {
                      isFeature = v.validate();
                      setState(() {});
                    },
                  ).paddingOnly(left: 16, right: 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // endregion

  // region Action
  Future checkValidation() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      selectedService.clear();

      if (appStore.selectedServiceList.isNotEmpty) {
        appStore.selectedServiceList.forEach((element) {
          selectedService.add(element.id.validate());
        });
      }

      if (imageFiles.isEmpty || selectedService.isEmpty) {
        if (selectedService.isEmpty) {
          return toast(languages.pleaseSelectService);
        } else if (imageFiles.isEmpty) {
          return toast(languages.pleaseSelectImages);
        }
      }

      if (startDateCont.text.validate().isNotEmpty && endDateCont.text.validate().isEmpty) {
        return toast(languages.pleaseEnterTheEndDate);
      }

      String serviceId = "";

      if (selectedService.isNotEmpty) {
        for (var i in selectedService) {
          if (i == selectedService.last) {
            serviceId = serviceId + i.toString();
          } else {
            serviceId = serviceId + i.toString() + ",";
          }
        }
      } else {
        return toast(languages.pleaseSelectService);
      }

      Map<String, dynamic> req = {
        PackageKey.packageId: widget.data != null
            ? widget.data!.id.validate() != 0
                ? widget.data!.id.validate()
                : null
            : null,
        PackageKey.name: packageNameCont.text.validate(),
        PackageKey.description: packageDescriptionCont.text.validate(),
        PackageKey.price: packagePriceCont.text.validate(),
        PackageKey.startDate: startDateCont.text.validate(),
        PackageKey.endDate: endDateCont.text.validate(),
        if (selectedCategoryId != -1) PackageKey.categoryId: selectedCategoryId,
        if (selectedSubCategoryId != -1) PackageKey.subCategoryId: selectedSubCategoryId,
        PackageKey.isFeatured: isFeature ? '1' : '0',
        PackageKey.status: packageStatus.validate() == ACTIVE ? '1' : '0',
        PackageKey.serviceId: serviceId,
        PackageKey.packageType: isPackageTypeSingleCategory,
      };

      addPackageMultiPart(value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        //
      }).catchError((e) {
        toast(e.toString());
      });
    }
  }

  // endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? languages.editPackage : languages.addPackage,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 90),
            child: Column(
              children: [
                CustomImagePicker(
                  key: uniqueKey,
                  onRemoveClick: (value) {
                    if (tempAttachments.validate().isNotEmpty && imageFiles.isNotEmpty) {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.DELETE,
                        positiveText: languages.lblDelete,
                        negativeText: languages.lblCancel,
                        onAccept: (p0) {
                          imageFiles.removeWhere((element) => element.path == value);
                          if (value.startsWith('http')) {
                            removeAttachment(id: tempAttachments.validate().firstWhere((element) => element.url == value).id.validate());
                          }
                        },
                      );
                    } else {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.DELETE,
                        positiveText: languages.lblDelete,
                        negativeText: languages.lblCancel,
                        onAccept: (p0) {
                          imageFiles.removeWhere((element) => element.path == value);
                          if (isUpdate) {
                            uniqueKey = UniqueKey();
                          }
                          setState(() {});
                        },
                      );
                    }
                  },
                  selectedImages: widget.data != null ? imageFiles.validate().map((e) => e.path.validate()).toList() : null,
                  onFileSelected: (List<File> files) async {
                    imageFiles = files;
                    setState(() {});
                  },
                ),
                8.height,
                buildFormWidget(),
              ],
            ),
          ),
          Positioned(
            right: 16,
            left: 16,
            bottom: 16,
            child: AppButton(
              text: context.translate.btnSave,
              height: 40,
              color: context.primaryColor,
              textStyle: primaryTextStyle(color: white),
              width: context.width() - context.navigationBarHeight,
              onTap: () {
                ifNotTester(context, () {
                  checkValidation();
                });
              },
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
