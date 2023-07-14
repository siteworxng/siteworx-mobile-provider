import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/caregory_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

class CategorySubCatDropDown extends StatefulWidget {
  final int? categoryId;
  final int? subCategoryId;
  final Function(int? val) onCategorySelect;
  final Function(int? val) onSubCategorySelect;
  final bool? isCategoryValidate;
  final bool? isSubCategoryValidate;
  final Color? fillColor;

  CategorySubCatDropDown({this.categoryId, this.subCategoryId, required this.onSubCategorySelect, required this.onCategorySelect, this.isSubCategoryValidate, this.isCategoryValidate, this.fillColor});

  @override
  State<CategorySubCatDropDown> createState() => _CategorySubCatDropDownState();
}

class _CategorySubCatDropDownState extends State<CategorySubCatDropDown> {
  List<CategoryData> categoryList = [];
  List<CategoryData> subCategoryList = [];

  CategoryData? selectedCategory;
  CategoryData? selectedSubCategory;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    getCategory();
  }

  Future<void> getSubCategory({required int categoryId}) async {
    await getSubCategoryList(catId: categoryId.toInt()).then((value) {
      subCategoryList = value.data.validate();

      if (widget.subCategoryId != null) {
        selectedSubCategory = value.data!.firstWhere((element) => element.id == widget.subCategoryId);
        widget.onSubCategorySelect.call(selectedSubCategory?.id.validate());
      }

      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> getCategory() async {
    appStore.setLoading(true);

    await getCategoryList(perPage: 'all').then((value) {
      categoryList = value.data!;

      ///
      if (widget.categoryId != null) {
        ///
        selectedCategory = value.data!.firstWhere((element) => element.id == widget.categoryId);
        widget.onCategorySelect.call(selectedCategory?.id.validate());

        ///
        if (widget.subCategoryId != null) {
          getSubCategory(categoryId: selectedCategory!.id.validate());
        }
      }
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String getStringValue() {
    if (selectedCategory == null) {
      return languages.hintSelectCategory;
    } else {
      return languages.lblSelectSubCategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          DropdownButtonFormField<CategoryData>(
            decoration: inputDecoration(context, fillColor: widget.fillColor ?? context.scaffoldBackgroundColor, hint: languages.hintSelectCategory),
            value: selectedCategory,
            dropdownColor: context.scaffoldBackgroundColor,
            items: categoryList.map((data) {
              return DropdownMenuItem<CategoryData>(
                value: data,
                child: Text(data.name.validate(), style: primaryTextStyle()),
              );
            }).toList(),
            validator: widget.isCategoryValidate.validate(value: true)
                ? (value) {
                    if (value == null) return errorThisFieldRequired;

                    return null;
                  }
                : null,
            onChanged: (CategoryData? value) async {
              selectedCategory = value!;
              widget.onCategorySelect.call(selectedCategory!.id.validate());

              if (selectedSubCategory != null) {
                selectedSubCategory = null;
                subCategoryList.clear();
                widget.onSubCategorySelect.call(null);
              }
              getSubCategory(categoryId: value.id.validate());
              setState(() {});
            },
          ),
          16.height,
          DropdownButtonFormField<CategoryData>(
            decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor, hint: getStringValue()),
            value: selectedSubCategory,
            dropdownColor: context.scaffoldBackgroundColor,
            validator: widget.isSubCategoryValidate.validate(value: false)
                ? (value) {
                    if (value == null) return errorThisFieldRequired;

                    return null;
                  }
                : null,
            items: subCategoryList.map((data) {
              return DropdownMenuItem<CategoryData>(
                value: data,
                child: Text(data.name.validate(), style: primaryTextStyle()),
              );
            }).toList(),
            onChanged: (CategoryData? value) async {
              selectedSubCategory = value!;
              widget.onSubCategorySelect.call(selectedSubCategory!.id.validate());
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
