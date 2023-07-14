import 'package:flutter/cupertino.dart';
import 'package:provider/main.dart';
import 'package:provider/models/about_model.dart';
import 'package:provider/utils/extensions/context_ext.dart';
import 'package:provider/utils/images.dart';

List<AboutModel> getAboutDataModel({BuildContext? context}) {
  List<AboutModel> aboutList = [];

  aboutList.add(AboutModel(title: context!.translate.lblTermsAndConditions, image: termCondition));
  aboutList.add(AboutModel(title: languages.lblPrivacyPolicy, image: privacy_policy));
  aboutList.add(AboutModel(title: languages.lblHelpAndSupport, image: termCondition));
  aboutList.add(AboutModel(title: languages.lblHelpLineNum, image: calling));
  aboutList.add(AboutModel(title: languages.lblRateUs, image: rateUs));

  return aboutList;
}
