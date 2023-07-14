import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/common.dart';
import '../utils/configs.dart';

class AddKnownLanguagesComponent extends StatefulWidget {
  const AddKnownLanguagesComponent({Key? key}) : super(key: key);

  @override
  State<AddKnownLanguagesComponent> createState() => _AddKnownLanguagesComponentState();
}

class _AddKnownLanguagesComponentState extends State<AddKnownLanguagesComponent> {
  TextEditingController knownLangCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              backgroundColor: primaryColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.addKnownLanguage, style: boldTextStyle(color: white)).expand(),
                CloseButton(color: Colors.white),
              ],
            ),
          ),
          AppTextField(
            textFieldType: TextFieldType.NAME,
            controller: knownLangCont,
            decoration: inputDecoration(context, hint: languages.knownLanguages),
          ).paddingAll(16),
          AppButton(
            text: languages.btnSave,
            color: primaryColor,
            textStyle: primaryTextStyle(color: white),
            width: context.width() - context.navigationBarHeight,
            onTap: () {
              if (knownLangCont.text.isNotEmpty) {
                finish(context, knownLangCont.text);
              } else {
                toast(languages.pleaseAddKnownLanguage);
              }
            },
          ).paddingAll(16),
        ],
      ),
    ).paddingAll(0);
  }
}
