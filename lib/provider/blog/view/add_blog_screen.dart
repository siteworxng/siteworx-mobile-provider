import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/components/custom_image_picker.dart';
import 'package:provider/main.dart';
import 'package:provider/models/attachment_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/blog/blog_repository.dart';
import 'package:provider/provider/blog/model/blog_response_model.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/static_data_model.dart';
import '../../../utils/constant.dart';

class AddBlogScreen extends StatefulWidget {
  final BlogData? data;

  AddBlogScreen({this.data});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  UniqueKey uniqueKey = UniqueKey();

  TextEditingController titleCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();

  FocusNode titleFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  bool isFeature = true;
  bool isUpdate = false;
  String blogStatus = '';

  List<File> imageFiles = [];
  List<Attachments> tempAttachments = [];

  List<StaticDataModel> statusListStaticData = [
    StaticDataModel(key: ACTIVE, value: languages.active),
    StaticDataModel(key: INACTIVE, value: languages.inactive),
  ];

  StaticDataModel? blogStatusModel;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    isUpdate = widget.data != null;

    if (isUpdate) {
      imageFiles = widget.data!.attachment.validate().map((e) => File(e.url.toString())).toList();
      tempAttachments = widget.data!.attachment.validate();
      isFeature = widget.data!.isFeatured.validate() == 1 ? true : false;
      titleCont.text = widget.data!.title.validate();
      descriptionCont.text = widget.data!.description.validate();
      blogStatus = widget.data!.status.validate() == 1 ? ACTIVE : INACTIVE;
      if (blogStatus == ACTIVE) {
        blogStatusModel = statusListStaticData.first;
      } else {
        blogStatusModel = statusListStaticData[1];
      }
    } else {
      appStore.setLoading(false);
      blogStatus = ACTIVE;
    }
    setState(() {});
  }

  //region Add Blog
  Future<void> checkValidation() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      if (imageFiles.isEmpty) {
        return toast(languages.pleaseSelectImages);
      }

      Map<String, dynamic> req = {
        CommonKeys.id: widget.data != null ? widget.data!.id.validate() : '',
        AddBlogKey.title: titleCont.text.validate(),
        AddBlogKey.description: descriptionCont.text.validate(),
        AddBlogKey.isFeatured: isFeature ? '1' : '0',
        AddBlogKey.providerId: appStore.userId.validate(),
        AddBlogKey.authorId: appStore.userId.validate(),
        AddBlogKey.status: blogStatus.validate() == ACTIVE ? '1' : '0',
      };

      log("request: $req");

      addBlogMultiPart(value: req, imageFile: imageFiles.where((element) => !element.path.contains('http')).toList()).then((value) {
        //
        log("blogStatus");
        log(blogStatus);
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
      CommonKeys.type: BLOG_ATTACHMENT,
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

  // region form Widget
  Widget buildFormWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.cardColor,
      ),
      child: Form(
        key: formKey,
        child: Wrap(
          runSpacing: 16,
          children: [
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: titleCont,
              focus: titleFocus,
              nextFocus: descriptionFocus,
              isValidationRequired: true,
              errorThisFieldRequired: languages.hintRequired,
              decoration: inputDecoration(context, hint: languages.enterBlogTitle, fillColor: context.scaffoldBackgroundColor),
            ),
            16.height,
            AppTextField(
              textFieldType: TextFieldType.MULTILINE,
              minLines: 5,
              maxLines: 10,
              controller: descriptionCont,
              focus: descriptionFocus,
              isValidationRequired: true,
              errorThisFieldRequired: languages.hintRequired,
              decoration: inputDecoration(
                context,
                hint: languages.hintDescription,
                fillColor: context.scaffoldBackgroundColor,
              ),
            ),
            DropdownButtonFormField<StaticDataModel>(
              isExpanded: true,
              dropdownColor: context.cardColor,
              value: blogStatusModel != null ? blogStatusModel : statusListStaticData.first,
              items: statusListStaticData.map((StaticDataModel data) {
                return DropdownMenuItem<StaticDataModel>(
                  value: data,
                  child: Text(data.value.validate(), style: primaryTextStyle()),
                );
              }).toList(),
              decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor, hint: languages.lblStatus),
              onChanged: (StaticDataModel? value) async {
                blogStatus = value!.key.validate();
                setState(() {});
              },
              validator: (value) {
                if (value == null) return errorThisFieldRequired;
                return null;
              },
            ),
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
              ).paddingSymmetric(horizontal: 16),
            ),
          ],
        ),
      ),
    );
  }

  //endregion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        isUpdate ? languages.updateBlog : languages.addBlog,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
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
