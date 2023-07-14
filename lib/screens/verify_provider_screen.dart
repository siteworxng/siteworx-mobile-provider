import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/document_list_response.dart';
import 'package:provider/models/provider_document_list_response.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/empty_error_state_widget.dart';

class VerifyProviderScreen extends StatefulWidget {
  @override
  _VerifyProviderScreenState createState() => _VerifyProviderScreenState();
}

class _VerifyProviderScreenState extends State<VerifyProviderScreen> {
  DocumentListResponse? documentListResponse;
  List<Documents> documents = [];
  FilePickerResult? filePickerResult;
  List<ProviderDocuments> providerDocuments = [];
  List<File>? imageFiles;
  PickedFile? pickedFile;
  List<String> eAttachments = [];
  int? updateDocId;
  List<int>? uploadedDocList = [];
  Documents? selectedDoc;
  int docId = 0;

  @override
  void initState() {
    super.initState();

    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    appStore.setLoading(true);

    getDocumentList();
    getProviderDocList();
  }

//get Document list
  void getDocumentList() {
    getDocList().then((res) {
      log(res.documents);
      documents.addAll(res.documents!);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
  }

  //SelectImage
  void getMultipleFile(int? docId, {int? updateId}) async {
    filePickerResult = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.custom, allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf']);

    if (filePickerResult != null) {
      showConfirmDialogCustom(
        context,
        title: languages.confirmationUpload,
        onAccept: (BuildContext context) {
          setState(() {
            imageFiles = filePickerResult!.paths.map((path) => File(path!)).toList();
            eAttachments = [];
          });

          ifNotTester(context, () {
            addDocument(docId, updateId: updateId);
          });
        },
        positiveText: languages.lblYes,
        negativeText: languages.lblNo,
        primaryColor: primaryColor,
      );
    } else {}
  }

  //Add Documents
  void addDocument(int? docId, {int? updateId}) async {
    MultipartRequest multiPartRequest = await getMultiPartRequest('provider-document-save');
    multiPartRequest.fields[CommonKeys.id] = updateId != null ? updateId.toString() : '';
    multiPartRequest.fields[CommonKeys.providerId] = appStore.userId.toString();
    multiPartRequest.fields[AddDocument.documentId] = docId.toString();
    multiPartRequest.fields[AddDocument.isVerified] = '0';

    if (imageFiles != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(AddDocument.providerDocument, imageFiles!.first.path));
    }
    log(multiPartRequest);

    multiPartRequest.headers.addAll(buildHeaderTokens());
    appStore.setLoading(true);

    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);

        toast(languages.toastSuccess, print: true);
        providerDocuments.clear();
        getProviderDocList();
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

  //Get Uploaded Documents List
  void getProviderDocList() {
    getProviderDoc().then((res) {
      appStore.setLoading(false);
      providerDocuments.addAll(res.providerDocuments!);
      providerDocuments.forEach((element) {
        uploadedDocList!.add(element.documentId!);
        updateDocId = element.id;
      });
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  //Delete Documents
  void deleteDoc(int? id) {
    appStore.setLoading(true);
    deleteProviderDoc(id).then((value) {
      toast(value.message, print: true);
      uploadedDocList!.clear();
      providerDocuments.clear();

      getProviderDocList();
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.btnVerifyId, textColor: white, color: context.primaryColor),
      body: Stack(
        children: [
          AnimatedScrollView(
            padding: EdgeInsets.all(12),
            children: [
              8.height,
              Row(
                children: [
                  if (documents.isNotEmpty)
                    DropdownButtonFormField<Documents>(
                      isExpanded: true,
                      decoration: inputDecoration(context),
                      hint: Text(languages.lblSelectDoc, style: primaryTextStyle()),
                      value: selectedDoc,
                      dropdownColor: context.cardColor,
                      items: documents.map((Documents e) {
                        return DropdownMenuItem<Documents>(
                          value: e,
                          child: Text(e.name!, style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (Documents? value) async {
                        selectedDoc = value;
                        docId = value!.id!;
                        setState(() {});
                      },
                    ).expand(),
                  8.width.visible(!uploadedDocList!.contains(docId)),
                  8.width,
                  if (docId != 0)
                    AppButton(
                      onTap: () {
                        getMultipleFile(docId);
                      },
                      color: Colors.green.withOpacity(0.1),
                      elevation: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.green, size: 24),
                          Text(languages.lblAddDoc, style: secondaryTextStyle()),
                        ],
                      ),
                    ),
                ],
              ),
              16.height,
              Observer(builder: (context) {
                return AnimatedListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: providerDocuments.length,
                  physics: NeverScrollableScrollPhysics(),
                  emptyWidget: !appStore.isLoading
                      ? NoDataWidget(
                          title: languages.noDocumentFound,
                          subTitle: languages.noDocumentSubTitle,
                          imageWidget: EmptyStateWidget(),
                        )
                      : null,
                  itemBuilder: (context, index) {
                    return providerDocuments[index].providerDocument!.contains('.pdf')
                        ? Container(
                            padding: EdgeInsets.all(8),
                            alignment: Alignment.bottomCenter,
                            width: context.width(),
                            decoration: boxDecorationWithRoundedCorners(
                              border: Border.all(width: 0.1),
                              gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [Colors.transparent, Colors.black26],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(providerDocuments[index].providerDocument!, style: primaryTextStyle()),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      providerDocuments[index].documentName!,
                                      style: boldTextStyle(size: 16, color: white),
                                    ).expand(),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: boxDecorationWithRoundedCorners(backgroundColor: white.withOpacity(0.5)),
                                      child: Icon(AntDesign.edit, color: primaryColor, size: 18),
                                    ).onTap(() {
                                      getMultipleFile(providerDocuments[index].documentId, updateId: providerDocuments[index].id.validate());
                                    }).visible(providerDocuments[index].isVerified == 0),
                                    6.width,
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: Colors.white.withOpacity(0.5),
                                      ),
                                      child: Icon(Icons.delete_forever, color: Colors.red, size: 18),
                                    ).onTap(() {
                                      deleteDoc(providerDocuments[index].id);
                                    }).visible(providerDocuments[index].isVerified == 0),
                                    Icon(
                                      MaterialIcons.verified_user,
                                      color: Colors.green,
                                    ).visible(providerDocuments[index].isVerified == 1),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CachedImageWidget(
                                url: providerDocuments[index].providerDocument.validate(),
                                height: 200,
                                width: context.width(),
                                fit: BoxFit.cover,
                                radius: 8,
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.bottomCenter,
                                height: 200,
                                width: context.width(),
                                decoration: boxDecorationWithRoundedCorners(
                                  border: Border.all(width: 0.1),
                                  gradient: LinearGradient(
                                    begin: FractionalOffset.topCenter,
                                    end: FractionalOffset.bottomCenter,
                                    colors: [Colors.transparent, Colors.black26],
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(providerDocuments[index].documentName.validate(), style: boldTextStyle(size: 16, color: white)).expand(),
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: boxDecorationWithRoundedCorners(backgroundColor: white.withOpacity(0.5)),
                                      child: Icon(AntDesign.edit, color: primaryColor, size: 20),
                                    ).onTap(() {
                                      getMultipleFile(providerDocuments[index].documentId, updateId: providerDocuments[index].id.validate());
                                    }).visible(providerDocuments[index].isVerified == 0),
                                    6.width,
                                    Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: boxDecorationWithRoundedCorners(
                                        backgroundColor: Colors.white.withOpacity(0.5),
                                      ),
                                      child: Icon(Icons.delete_forever, color: Colors.red, size: 20),
                                    ).onTap(() {
                                      showConfirmDialogCustom(context, dialogType: DialogType.DELETE, positiveText: languages.lblDelete, negativeText: languages.lblNo, onAccept: (_) {
                                        ifNotTester(context, () {
                                          deleteDoc(providerDocuments[index].id);
                                        });
                                      });
                                    }).visible(providerDocuments[index].isVerified == 0),
                                    Icon(
                                      MaterialIcons.verified_user,
                                      color: Colors.green,
                                    ).visible(providerDocuments[index].isVerified == 1),
                                  ],
                                ),
                              )
                            ],
                          ).paddingSymmetric(vertical: 8);
                  },
                );
              }),
            ],
          ),
          Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
