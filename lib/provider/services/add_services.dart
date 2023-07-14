import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/components/custom_image_picker.dart';
import 'package:provider/main.dart';
import 'package:provider/models/attachment_model.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/services/components/category_sub_cat_drop_down.dart';
import 'package:provider/provider/services/components/service_address_component.dart';
import 'package:provider/provider/timeSlots/my_time_slots_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/static_data_model.dart';

class AddServices extends StatefulWidget {
  final ServiceData? data;

  AddServices({this.data});

  @override
  State<AddServices> createState() => _AddServicesState();
}

class _AddServicesState extends State<AddServices> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  /// TextEditingController
  TextEditingController serviceNameCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController discountCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController durationContHr = TextEditingController();
  TextEditingController durationContMin = TextEditingController();
  TextEditingController prePayAmountController = TextEditingController();

  /// FocusNode
  FocusNode serviceNameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  FocusNode discountFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  FocusNode durationHrFocus = FocusNode();
  FocusNode durationMinFocus = FocusNode();
  FocusNode prePayAmountFocus = FocusNode();

  String serviceType = '';
  String serviceStatus = '';
  int? categoryId = -1;
  int? subCategoryId = -1;
  TimeOfDay? currentTime;

  bool isUpdate = false;
  bool isFeature = false;
  bool isTimeSlotAvailable = false;
  bool isAdvancePayment = false;
  bool isAdvancePaymentAllowedBySystem = getBoolAsync(IS_ADVANCE_PAYMENT_ALLOWED);

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];

  List<StaticDataModel> typeStaticData = [
    StaticDataModel(key: SERVICE_TYPE_FREE, value: languages.lblFree),
    StaticDataModel(key: SERVICE_TYPE_FIXED, value: languages.lblFixed),
    StaticDataModel(key: SERVICE_TYPE_HOURLY, value: languages.lblHourly),
  ];

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];

  StaticDataModel? serviceStatusModel;

  List<int> serviceAddressList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      tempAttachments = widget.data!.attchments.validate();
      imageFiles = widget.data!.attchments.validate().map((e) => File(e.url.toString())).toList();
      serviceNameCont.text = widget.data!.name.validate();
      priceCont.text = widget.data!.price.toString().validate();
      discountCont.text = widget.data!.discount.toString().validate();
      descriptionCont.text = widget.data!.description.validate();
      categoryId = widget.data!.categoryId.validate();
      subCategoryId = widget.data!.subCategoryId.validate();
      isFeature = widget.data!.isFeatured.validate() == 1 ? true : false;
      serviceType = widget.data!.type.validate();
      serviceStatus = widget.data!.status.validate() == 1 ? ACTIVE : INACTIVE;
      if (serviceStatus == ACTIVE) {
        serviceStatusModel = statusListStaticData.first;
      } else {
        serviceStatusModel = statusListStaticData[1];
      }
      currentTime = TimeOfDay(hour: widget.data!.duration.validate().splitBefore(':').toInt(), minute: widget.data!.duration.validate().splitAfter(':').toInt());
      durationContHr.text = "${currentTime!.hour}:${currentTime!.minute}";
      isTimeSlotAvailable = widget.data!.isSlot.validate() == 1 ? true : false;
      //isAdvancePaymentAllowedBySystem = widget.data!.isAdvancePaymentSetting;
      isAdvancePayment = widget.data!.isAdvancePayment;
      if (widget.data!.advancePaymentAmount != null) {
        prePayAmountController.text = widget.data!.advancePaymentAmount.validate().toString();
      }
      timeSlotStore.initializeSlots(value: widget.data!.providerSlotData.validate());
    }

    setState(() {});
    await timeSlotStore.timeSlotForProvider();
  }

  //region Add Service
  Future checkValidation() async {
    if ((!isUpdate && imageFiles.isEmpty) || (isUpdate && imageFiles.isEmpty)) {
      toast(languages.pleaseSelectImages);
      return;
    }

    if ((!isUpdate && serviceAddressList.validate().isEmpty) || (isUpdate && serviceAddressList.validate().isEmpty)) {
      toast(languages.pleaseSelectServiceAddresses);
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map<String, dynamic> req = {
        AddServiceKey.name: serviceNameCont.text,
        AddServiceKey.providerId: appStore.userId.validate(),
        AddServiceKey.categoryId: categoryId,
        AddServiceKey.type: serviceType.validate(),
        AddServiceKey.price: priceCont.text,
        AddServiceKey.discountPrice: discountCont.text,
        AddServiceKey.description: descriptionCont.text,
        AddServiceKey.isFeatured: isFeature ? '1' : '0',
        AddServiceKey.isSlot: isTimeSlotAvailable ? '1' : '0',
        AddServiceKey.status: serviceStatus.validate() == ACTIVE ? '1' : '0',
        AddServiceKey.duration: "${currentTime!.hour}:${currentTime!.minute}",
      };

      if (subCategoryId != -1) {
        req.putIfAbsent(AddServiceKey.subCategoryId, () => subCategoryId);
      }

      if (isUpdate) {
        req.putIfAbsent(AddServiceKey.id, () => widget.data!.id.validate());
      }
      if (isAdvancePaymentAllowedBySystem && isAdvancePayment) {
        req.putIfAbsent(AdvancePaymentKey.isEnableAdvancePayment, () => isAdvancePayment ? 1 : 0);
        req.putIfAbsent(AdvancePaymentKey.advancePaymentAmount, () => prePayAmountController.text.validate().toDouble());
      }
      log("Service Add Request: $req");
      addServiceMultiPart(value: req, serviceAddressList: serviceAddressList, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        //
      }).catchError((e) {
        toast(e.toString());
      });
    }
  }

  //endregion

  //region Remove Attachment
  Future<void> removeAttachment({required int id}) async {
    appStore.setLoading(true);

    Map req = {
      CommonKeys.type: 'service_attachment',
      CommonKeys.id: id,
    };

    await deleteImage(req).then((value) {
      tempAttachments.validate().removeWhere((element) => element.id == id);
      setState(() {});

      uniqueKey = UniqueKey();

      appStore.setLoading(false);
      toast(value.message.validate(), print: true);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  //endregion

  //region Build Widget
  Widget buildFormWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Wrap(
          runSpacing: 16,
          children: [
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: serviceNameCont,
              focus: serviceNameFocus,
              nextFocus: priceFocus,
              errorThisFieldRequired: languages.hintRequired,
              decoration: inputDecoration(context, hint: languages.hintServiceName, fillColor: context.scaffoldBackgroundColor),
            ),
            16.height,
            CategorySubCatDropDown(
              categoryId: categoryId == -1 ? null : categoryId,
              subCategoryId: subCategoryId == -1 ? null : subCategoryId,
              isCategoryValidate: true,
              onCategorySelect: (int? val) {
                log("Category: $val");
                categoryId = val!;
                setState(() {});
              },
              onSubCategorySelect: (int? val) {
                subCategoryId = val!;
                setState(() {});
              },
            ),
            ServiceAddressComponent(
              selectedList: widget.data?.serviceAddressMapping.validate().map((e) => e.providerAddressMapping!.id.validate()).toList(),
              onSelectedList: (val) {
                serviceAddressList = val;
              },
            ),
            Row(
              children: [
                DropdownButtonFormField<StaticDataModel>(
                  decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor, hint: languages.lblType),
                  isExpanded: true,
                  value: serviceType.isNotEmpty ? getServiceType : null,
                  dropdownColor: context.cardColor,
                  items: typeStaticData.map((StaticDataModel data) {
                    return DropdownMenuItem<StaticDataModel>(
                      value: data,
                      child: Text(data.value.validate(), style: primaryTextStyle()),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  },
                  onChanged: (StaticDataModel? value) async {
                    serviceType = value!.key.validate();

                    if (serviceType == SERVICE_TYPE_FREE) {
                      priceCont.text = '0';
                      discountCont.text = '0';
                    } else if (widget.data != null) {
                      priceCont.text = widget.data!.price.validate().toString();
                      discountCont.text = widget.data!.discount.validate().toString();
                    } else {
                      priceCont.text = '';
                      discountCont.text = '';
                    }
                    setState(() {});
                  },
                ).expand(),
                16.width,
                DropdownButtonFormField<StaticDataModel>(
                  isExpanded: true,
                  dropdownColor: context.cardColor,
                  value: serviceStatusModel != null ? serviceStatusModel : statusListStaticData.first,
                  items: statusListStaticData.map((StaticDataModel data) {
                    return DropdownMenuItem<StaticDataModel>(
                      value: data,
                      child: Text(data.value.validate(), style: primaryTextStyle()),
                    );
                  }).toList(),
                  decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor, hint: languages.lblStatus),
                  onChanged: (StaticDataModel? value) async {
                    serviceStatus = value!.key.validate();
                    setState(() {});
                  },
                  validator: (value) {
                    if (value == null) return errorThisFieldRequired;
                    return null;
                  },
                ).expand(),
              ],
            ),
            Row(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  controller: priceCont,
                  focus: priceFocus,
                  nextFocus: discountFocus,
                  enabled: serviceType != SERVICE_TYPE_FREE,
                  errorThisFieldRequired: languages.hintRequired,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: inputDecoration(
                    context,
                    hint: languages.hintPrice,
                    fillColor: context.scaffoldBackgroundColor,
                  ),
                  validator: (s) {
                    if (s!.isEmpty) return errorThisFieldRequired;

                    if (s.toInt() <= 0 && serviceType != SERVICE_TYPE_FREE) return languages.priceAmountValidationMessage;
                    return null;
                  },
                ).expand(),
                16.width,
                AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  controller: discountCont,
                  focus: discountFocus,
                  nextFocus: durationHrFocus,
                  enabled: serviceType != SERVICE_TYPE_FREE,
                  errorThisFieldRequired: languages.hintRequired,
                  decoration: inputDecoration(
                    context,
                    hint: languages.hintDiscount.capitalizeFirstLetter(),
                    fillColor: context.scaffoldBackgroundColor,
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (s) {
                    if (s!.isEmpty) return errorThisFieldRequired;

                    if (s.toInt() < 0 || s.toInt() > 99) return '${discountCont.text}% ${languages.isNotValid}';
                    return null;
                  },
                ).expand(),
              ],
            ),
            AppTextField(
              textFieldType: TextFieldType.PHONE,
              controller: durationContHr,
              focus: durationHrFocus,
              nextFocus: durationMinFocus,
              maxLength: 2,
              readOnly: true,
              onTap: () async {
                currentTime = await showTimePicker(
                  context: context,
                  initialTime: currentTime ?? TimeOfDay.now(),
                  helpText: languages.selectDuration,
                );

                if (currentTime != null) {
                  durationContHr.text = "${languages.thisServiceMayTake} ${currentTime!.hour}:${currentTime!.minute} ${languages.hour}";
                }
              },
              errorThisFieldRequired: languages.hintRequired,
              decoration: inputDecoration(
                context,
                hint: languages.lblDurationHr,
                fillColor: context.scaffoldBackgroundColor,
                counterText: '',
              ),
            ),
            /* Row(
              children: [
                AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  controller: durationContHr,
                  focus: durationHrFocus,
                  nextFocus: durationMinFocus,
                  maxLength: 2,
                  errorThisFieldRequired: languages.hintRequired,
                  decoration: inputDecoration(
                    context,
                    hint: languages.lblDurationHr,
                    fillColor: context.scaffoldBackgroundColor,
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (s) {
                    if (s!.isEmpty) return errorThisFieldRequired;

                    if (s.toInt() > 24) return languages.lblEnterHours;
                    if (s.toInt() == 0) return errorThisFieldRequired;
                    return null;
                  },
                ).expand(),
                16.width,
                AppTextField(
                  textFieldType: TextFieldType.PHONE,
                  controller: durationContMin,
                  focus: durationMinFocus,
                  nextFocus: descriptionFocus,
                  maxLength: 2,
                  errorThisFieldRequired: languages.hintRequired,
                  decoration: inputDecoration(
                    context,
                    hint: languages.lblDurationMin,
                    fillColor: context.scaffoldBackgroundColor,
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (s) {
                    if (s!.isEmpty) return errorThisFieldRequired;

                    if (s.toInt() > 60) return languages.lblEnterMinute;
                    return null;
                  },
                ).expand(),
              ],
            ),*/
            AppTextField(
              textFieldType: TextFieldType.MULTILINE,
              minLines: 5,
              controller: descriptionCont,
              focus: descriptionFocus,
              errorThisFieldRequired: languages.hintRequired,
              decoration: inputDecoration(
                context,
                hint: languages.hintDescription,
                fillColor: context.scaffoldBackgroundColor,
              ),
            ),
            Container(
              decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
              child: CheckboxListTile(
                value: isFeature,
                contentPadding: EdgeInsets.zero,
                checkboxShape: RoundedRectangleBorder(side: BorderSide(color: primaryColor), borderRadius: radius(4)),
                shape: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: primaryColor)),
                title: Text(languages.hintSetAsFeature, style: secondaryTextStyle()),
                onChanged: (bool? v) {
                  isFeature = v.validate();
                  setState(() {});
                },
              ).paddingSymmetric(horizontal: 16),
            ),
            Container(
              decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
              child: SettingItemWidget(
                title: languages.timeSlotAvailable,
                subTitle: languages.doesThisServicesContainsTimeslot,
                trailing: Observer(builder: (context) {
                  return CupertinoSwitch(
                    activeColor: primaryColor,
                    value: isTimeSlotAvailable,
                    onChanged: (v) async {
                      if (!v) {
                        isTimeSlotAvailable = v;
                        setState(() {});
                        return;
                      }
                      if (timeSlotStore.isTimeSlotAvailable) {
                        isTimeSlotAvailable = v;
                        setState(() {});
                      } else {
                        toast(languages.pleaseEnterTheDefaultTimeslotsFirst);
                        MyTimeSlotsScreen(isFromService: true).launch(context).then((value) {
                          if (value != null) {
                            if (value) {
                              isTimeSlotAvailable = v;
                              setState(() {});
                              ifNotTester(context, () {
                                showConfirmDialogCustom(
                                  context,
                                  dialogAnimation: DialogAnimation.SCALE,
                                  title: languages.addService,
                                  onAccept: (p0) {
                                    showConfirmDialogCustom(
                                      context,
                                      dialogAnimation: DialogAnimation.SCALE,
                                      title: languages.addService,
                                      onAccept: (p0) {
                                        checkValidation();
                                      },
                                    );
                                  },
                                );
                              });
                            }
                          }
                        });
                      }
                    },
                  ).visible(!timeSlotStore.isLoading, defaultWidget: LoaderWidget(size: 26));
                }),
              ),
            ),
            if (isAdvancePaymentAllowedBySystem && serviceType == SERVICE_TYPE_FIXED)
              Container(
                decoration: boxDecorationDefault(color: context.scaffoldBackgroundColor, borderRadius: radius()),
                child: SettingItemWidget(
                  title: languages.enablePrePayment,
                  subTitle: languages.enablePrePaymentMessage,
                  trailing: CupertinoSwitch(
                    activeColor: primaryColor,
                    value: isAdvancePayment,
                    onChanged: (v) async {
                      isAdvancePayment = !isAdvancePayment;
                      setState(() {});
                    },
                  ),
                ),
              ),
            if (isAdvancePaymentAllowedBySystem && isAdvancePayment)
              AppTextField(
                textFieldType: TextFieldType.PHONE,
                controller: prePayAmountController,
                focus: prePayAmountFocus,
                maxLength: 3,
                errorThisFieldRequired: languages.hintRequired,
                decoration: inputDecoration(
                  context,
                  hint: languages.advancePayAmountPer,
                  fillColor: context.scaffoldBackgroundColor,
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                validator: (s) {
                  if (s!.isEmpty) return errorThisFieldRequired;

                  if (s.toInt() <= 0 || s.toInt() >= 100) return languages.valueConditionMessage;
                  return null;
                },
              ),
          ],
        ),
      ),
    );
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(Colors.transparent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? languages.lblEditService : languages.hintAddService,
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 90),
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
                          removeAttachment(id: tempAttachments.validate().firstWhere((element) => element.url == value).id.validate());
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
                buildFormWidget(),
              ],
            ),
          ),
          Positioned(
            right: 16,
            left: 16,
            bottom: 16,
            child: AppButton(
              text: languages.btnSave,
              height: 40,
              color: primaryColor,
              textStyle: primaryTextStyle(color: white),
              width: context.width() - context.navigationBarHeight,
              onTap: () {
                ifNotTester(context, () {
                  showConfirmDialogCustom(
                    context,
                    dialogAnimation: DialogAnimation.SCALE,
                    primaryColor: context.primaryColor,
                    negativeText: languages.lblCancel,
                    positiveText: languages.lblYes,
                    title: "${languages.areYouSureYouWantTo} ${isUpdate ? "${languages.lblUpdate}" : "${languages.hintAdd}"} ${languages.theService}?",
                    onAccept: (p0) {
                      checkValidation();
                    },
                  );
                });
              },
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }

  StaticDataModel get getServiceType => serviceType == SERVICE_TYPE_FREE
      ? typeStaticData[0]
      : serviceType == SERVICE_TYPE_FIXED
          ? typeStaticData[1]
          : typeStaticData[2];
}
