import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/caregory_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

///TODO unused DropdownSubCategoryComponent
class DropdownSubCategoryComponent extends StatefulWidget {
  final int? categoryId;
  final int? selectedValue;
  final Function(CategoryData value) onValueChanged;
  final bool isValidate;

  DropdownSubCategoryComponent({required this.onValueChanged, required this.isValidate, this.categoryId, this.selectedValue});

  @override
  _DropdownUserTypeComponentState createState() => _DropdownUserTypeComponentState();
}

class _DropdownUserTypeComponentState extends State<DropdownSubCategoryComponent> {
  CategoryData? selectedData;
  List<CategoryData> subCategoryList = [];

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(SELECT_SUBCATEGORY, (p0) {
      if (selectedData != null) {
        selectedData = null;
        setState(() {});
      }
      init(subCategory: p0.toString());
    });
  }

  init({String? subCategory}) async {
    await getSubCategoryList(catId: subCategory.toInt()).then((value) {
      subCategoryList = value.data.validate();
      if (widget.selectedValue != null) {
        selectedData = subCategoryList.firstWhere((element) {
          log("===================== ${element.id.validate()} ${widget.selectedValue.validate()} =====================");
          return element.id.validate() == widget.selectedValue.validate();
        });
      }
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<CategoryData>(
      onChanged: (CategoryData? val) {
        widget.onValueChanged.call(val!);
        selectedData = val;
      },
      validator: widget.isValidate
          ? (c) {
              if (c == null) return errorThisFieldRequired;
              return null;
            }
          : null,
      value: selectedData,
      dropdownColor: context.cardColor,
      decoration: inputDecoration(context, fillColor: context.scaffoldBackgroundColor, hint: languages.lblSelectSubCategory),
      items: List.generate(
        subCategoryList.length,
        (index) {
          CategoryData data = subCategoryList[index];

          return DropdownMenuItem<CategoryData>(
            child: Text(data.name.toString(), style: primaryTextStyle()),
            value: data,
          );
        },
      ),
    );
  }
}
