import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/empty_error_state_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/packages/components/selected_service_component.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../models/caregory_response.dart';

class SelectServiceScreen extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;
  final bool isUpdate;
  final PackageData? packageData;

  SelectServiceScreen({this.categoryId, this.subCategoryId, this.isUpdate = false, this.packageData});

  @override
  _SelectServiceScreenState createState() => _SelectServiceScreenState();
}

class _SelectServiceScreenState extends State<SelectServiceScreen> {
  ScrollController scrollController = ScrollController();

  TextEditingController searchCont = TextEditingController();

  List<ServiceData> serviceList = [];
  List<CategoryData> categoryList = [];
  List<CategoryData> subCategoryList = [];

  CategoryData? selectedCategory;
  CategoryData? selectedSubCategory;

  int page = 1;
  int? categoryId = -1;
  int? subCategoryId = -1;

  bool isApiCalled = false;
  bool isLastPage = false;
  bool? isPackageTypeSingle;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    if (widget.isUpdate) {
      categoryId = widget.categoryId == null ? -1 : widget.categoryId;
      subCategoryId = widget.subCategoryId == null ? -1 : widget.subCategoryId;
      if (widget.packageData != null) {
        isPackageTypeSingle = widget.packageData!.packageType.validate() == PACKAGE_TYPE_SINGLE ? true : false;
      }
    } else {
      appStore.selectedServiceList.clear();
      isPackageTypeSingle = appStore.isCategoryWisePackageService;
    }

    getCategory();
  }

  //region Get Services List
  Future<void> fetchAllServices({String? searchText = "", int? categoryId = -1, int? subCategoryId = -1}) async {
    appStore.setLoading(true);
    await getServicesList(page, search: searchText, categoryId: categoryId, subCategoryId: subCategoryId, providerId: appStore.userId, type: SERVICE_TYPE_FIXED).then((value) {
      isApiCalled = true;

      if (page == 1) serviceList.clear();

      isLastPage = value.data!.length != PER_PAGE_ITEM;

      serviceList.addAll(value.data!);

      if (appStore.selectedServiceList.validate().isNotEmpty) {
        //appStore.selectedServiceList.any((e1) => serviceList.any((e2) => e2.id == e1.id));
        appStore.selectedServiceList.validate().forEach((e1) {
          serviceList.forEach((e2) {
            if (e2.id == e1.id) {
              e2.isSelected = true;
            }
          });
        });
      }

      appStore.setLoading(false);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      isApiCalled = false;

      toast(e.toString());
    });
  }

  //endregion

  // region Get Category List
  Future<void> getCategory() async {
    appStore.setLoading(true);

    await getCategoryList(perPage: CATEGORY_TYPE_ALL).then((value) async {
      categoryList = value.data.validate();
      if (widget.isUpdate && categoryId != -1) selectedCategory = value.data!.firstWhere((element) => element.id == widget.categoryId);

      if (selectedCategory != null) {
        selectedCategory = value.data!.firstWhere((element) => element.id == widget.categoryId);
        categoryId = selectedCategory!.id.validate();

        if (categoryId != -1) {
          await getSubCategory(categoryId: categoryId.validate());
        } else {
          await fetchAllServices(categoryId: categoryId, searchText: '');
        }
      } else {
        await fetchAllServices(categoryId: categoryId, searchText: '');
      }

      if (!widget.isUpdate) setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  //endregion

  // region Get Sub Category List
  Future<void> getSubCategory({required int categoryId}) async {
    getSubCategoryList(catId: categoryId.toInt()).then((value) async {
      subCategoryList = value.data.validate();
      CategoryData allValue = CategoryData(id: -1, name: 'All');
      subCategoryList.insert(0, allValue);

      if (widget.isUpdate) {
        if (subCategoryId != -1) {
          selectedSubCategory = value.data!.firstWhere((element) => element.id == subCategoryId);
        }
      } else {
        selectedSubCategory = subCategoryList.first;
      }

      if (subCategoryId != -1) {
        selectedSubCategory = value.data!.firstWhere((element) => element.id == subCategoryId);
        await fetchAllServices(categoryId: categoryId.validate(), subCategoryId: selectedSubCategory!.id.validate(), searchText: '');
      } else {
        selectedSubCategory = subCategoryList.first;
        subCategoryId = selectedSubCategory!.id.validate();
        await fetchAllServices(categoryId: categoryId.validate(), subCategoryId: subCategoryId, searchText: '');
      }

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  // endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.selectService,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        children: [
          AnimatedScrollView(
            controller: scrollController,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            crossAxisAlignment: CrossAxisAlignment.start,
            physics: AlwaysScrollableScrollPhysics(),
            onNextPage: () {
              if (!isLastPage) {
                page++;
                fetchAllServices();
                setState(() {});
              }
            },
            children: [
              24.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${languages.categoryBasedPackage} ${appStore.isCategoryWisePackageService ? languages.enabled : languages.disabled}', style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                      4.height,
                      Text(languages.subTitleOfSelectService, style: secondaryTextStyle()),
                    ],
                  ).expand(),
                  Transform.scale(
                    scale: 0.8,
                    child: Switch.adaptive(
                      value: isPackageTypeSingle.validate(),
                      activeColor: context.primaryColor,
                      inactiveTrackColor: Color(0xFF848B9B),
                      onChanged: (v) {
                        showConfirmDialogCustom(
                          context,
                          dialogType: DialogType.CONFIRMATION,
                          primaryColor: context.primaryColor,
                          title: '${languages.doYouWantTo} ${!appStore.isCategoryWisePackageService ? languages.enable : languages.disable} ${languages.categoryBasedPackage}?',
                          positiveText: context.translate.lblYes,
                          negativeText: context.translate.lblNo,
                          onAccept: (p0) {
                            if (appStore.isCategoryWisePackageService) {
                              appStore.selectedServiceList.clear();
                              appStore.setLoading(true);
                              searchCont.text = '';

                              fetchAllServices(categoryId: -1);
                            } else {
                              appStore.selectedServiceList.clear();
                              categoryId = -1;
                              searchCont.text = '';

                              appStore.setLoading(true);

                              fetchAllServices(categoryId: categoryId);
                              serviceList.clear();
                            }
                            isPackageTypeSingle = v;
                            appStore.setCategoryBasedPackageService(isPackageTypeSingle.validate());
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
              24.height,
              // Category and subCategory Dropdown
              if (isPackageTypeSingle.validate())
                Column(
                  children: [
                    DropdownButtonFormField<CategoryData>(
                      decoration: inputDecoration(context, fillColor: context.cardColor, hint: languages.hintSelectCategory),
                      value: selectedCategory,
                      dropdownColor: context.cardColor,
                      items: categoryList.map((data) {
                        return DropdownMenuItem<CategoryData>(
                          value: data,
                          child: Text(data.name.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: (CategoryData? value) async {
                        selectedCategory = value!;
                        categoryId = value.id;

                        serviceList.clear();
                        subCategoryList.clear();
                        appStore.selectedServiceList.clear();
                        subCategoryId = -1;

                        appStore.setLoading(true);
                        getSubCategory(categoryId: categoryId.validate());
                      },
                    ),
                    16.height,
                    DropdownButtonFormField<CategoryData>(
                      decoration: inputDecoration(context, fillColor: context.cardColor, hint: languages.lblSelectSubCategory),
                      value: selectedSubCategory,
                      dropdownColor: context.cardColor,
                      items: subCategoryList.map((data) {
                        return DropdownMenuItem<CategoryData>(
                          value: data,
                          child: Text(data.name.validate(), style: primaryTextStyle()),
                        );
                      }).toList(),
                      onChanged: (CategoryData? value) async {
                        selectedSubCategory = value!;
                        subCategoryId = value.id;

                        if (selectedSubCategory != null) {
                          appStore.setLoading(true);
                          fetchAllServices(categoryId: categoryId.validate(), subCategoryId: subCategoryId, searchText: '');
                        }
                      },
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),

              // Search Service TextField
              if (!isPackageTypeSingle.validate())
                AppTextField(
                  controller: searchCont,
                  textFieldType: TextFieldType.NAME,
                  decoration: inputDecoration(context, hint: languages.lblSearchHere),
                  onFieldSubmitted: (s) {
                    appStore.setLoading(true);

                    fetchAllServices(searchText: s);
                  },
                ).paddingSymmetric(horizontal: 16),

              // Selected Service Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  Text(languages.includedInThisPackage, style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingSymmetric(horizontal: 16),
                  16.height,
                  if (!appStore.isLoading && appStore.selectedServiceList.isNotEmpty)
                    SelectedServiceComponent(
                      onItemRemove: (data) {
                        int index = serviceList.indexOf(serviceList.firstWhere((element) => element.id == data.id));
                        serviceList[index].isSelected = false;
                        setState(() {});
                      },
                    )
                  else
                    Container(
                      height: 120,
                      width: context.width(),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                      child: Text(languages.packageServicesWillAppearHere, style: secondaryTextStyle()).center(),
                    ),
                  16.height,
                ],
              ),
              //
              if (appStore.selectedServiceList.isEmpty) 16.height,

              // Service List Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblServices, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                  Text(languages.showingFixPriceServices, style: secondaryTextStyle()),
                  8.height,
                ],
              ).paddingSymmetric(horizontal: 16),
              if ((serviceList.isNotEmpty) && (categoryId != -1 || !isPackageTypeSingle.validate()))
                AnimatedListView(
                  itemCount: serviceList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 70),
                  disposeScrollController: false,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    ServiceData data = serviceList[i];
                    bool isSelected = data.isSelected.validate();

                    return Container(
                      width: context.width(),
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CachedImageWidget(
                                url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                                height: 50,
                                fit: BoxFit.cover,
                                radius: defaultRadius,
                              ),
                              16.width,
                              Text(data.name.validate(), style: secondaryTextStyle(color: context.iconColor)).expand(),
                            ],
                          ).expand(),
                          16.width,
                          Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, size: 28, color: isSelected ? primaryColor : context.iconColor),
                          8.width,
                        ],
                      ).onTap(
                        () {
                          if (data.isSelected.validate()) {
                            appStore.removeSelectedPackageService(data);
                          } else {
                            appStore.addSelectedPackageService(data);
                          }
                          data.isSelected = !data.isSelected.validate();

                          setState(() {});
                        },
                      ),
                    );
                  },
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      fetchAllServices();
                      setState(() {});
                    }
                  },
                )
              else
                Observer(
                  builder: (context) {
                    return NoDataWidget(
                      imageWidget: EmptyStateWidget(),
                      title: context.translate.noServiceFound,
                      imageSize: Size(150, 150),
                      subTitle: "",
                    ).visible((!appStore.isLoading && serviceList.isEmpty));
                  },
                ),
              16.height,
              Observer(builder: (context) {
                return NoDataWidget(
                  imageWidget: EmptyStateWidget(),
                  title: languages.pleaseSelectTheCategory,
                  imageSize: Size(150, 150),
                  subTitle: "",
                ).center().visible(!appStore.isLoading && categoryId == -1 && isPackageTypeSingle.validate());
              }),
            ],
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check,color: Colors.white),
        backgroundColor: context.primaryColor,
        onPressed: () {
          Map res = {
            "categoryId": categoryId,
            "subCategoryId": subCategoryId,
            "packageType": isPackageTypeSingle! ? PACKAGE_TYPE_SINGLE : PACKAGE_TYPE_MULTIPLE,
          };
          finish(context, res);
        },
      ),
    );
  }
}
