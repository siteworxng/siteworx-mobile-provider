import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import '../utils/common.dart';
import '../utils/configs.dart';

class AddSkillComponent extends StatefulWidget {
  const AddSkillComponent({Key? key}) : super(key: key);

  @override
  State<AddSkillComponent> createState() => _AddSkillComponentState();
}

class _AddSkillComponentState extends State<AddSkillComponent> {
  TextEditingController skillsCont = TextEditingController();

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
                Text(languages.addEssentialSkill, style: boldTextStyle(color: white)).expand(),
                CloseButton(color: Colors.white),
              ],
            ),
          ),
          AppTextField(
            textFieldType: TextFieldType.NAME,
            controller: skillsCont,
            decoration: inputDecoration(context, hint: languages.essentialSkills),
          ).paddingAll(16),
          16.height,
          AppButton(
            text: languages.btnSave,
            color: primaryColor,
            textStyle: primaryTextStyle(color: white),
            width: context.width() - context.navigationBarHeight,
            onTap: () {
              if (skillsCont.text.isNotEmpty) {
                finish(context, skillsCont.text);
              } else {
                toast(languages.pleaseAddEssentialSkill);
              }
            },
          ).paddingAll(16),
        ],
      ),
    );
  }
}
