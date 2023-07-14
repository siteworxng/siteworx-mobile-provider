import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/about_model.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/data_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../components/base_scaffold_widget.dart';
import '../utils/constant.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<AboutModel> aboutList = getAboutDataModel(context: context);

    return AppScaffold(
      appBarTitle: languages.lblAbout,
      body: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        itemCount: aboutList.length,
        listAnimationType: ListAnimationType.FadeIn,
        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
        scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
        itemBuilder: (context, index) {
          return Container(
            width: context.width() * 0.5 - 26,
            padding: EdgeInsets.all(16),
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(),
              backgroundColor: context.cardColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(aboutList[index].image.toString(), height: 22, width: 22, color: context.iconColor),
                8.height,
                Text(aboutList[index].title.toString(), style: boldTextStyle(size: LABEL_TEXT_SIZE)),
              ],
            ),
          ).onTap(
            () async {
              if (index == 0) {
                log(appStore.termConditions.validate());
                checkIfLink(context, appStore.termConditions.validate(), title: languages.lblTermsAndConditions);
              } else if (index == 1) {
                checkIfLink(context, appStore.privacyPolicy.validate(), title: languages.lblPrivacyPolicy);
              } else if (index == 2) {
                checkIfLink(context, appStore.inquiryEmail.validate(), title: languages.lblHelpAndSupport);
              } else if (index == 3) {
                checkIfLink(context, appStore.helplineNumber.validate(), title: languages.lblHelpLineNum);
              } else if (index == 4) {
                {
                  if (isAndroid) {
                    if (getStringAsync(PROVIDER_PLAY_STORE_URL).isNotEmpty) {
                      commonLaunchUrl(getStringAsync(PROVIDER_PLAY_STORE_URL), launchMode: LaunchMode.externalApplication);
                    } else {
                      commonLaunchUrl('${getSocialMediaLink(LinkProvider.PLAY_STORE)}${await getPackageName()}', launchMode: LaunchMode.externalApplication);
                    }
                  } else if (isIOS) {
                    if (getStringAsync(PROVIDER_APPSTORE_URL).isNotEmpty) {
                      commonLaunchUrl(getStringAsync(PROVIDER_APPSTORE_URL), launchMode: LaunchMode.externalApplication);
                    } else {
                      commonLaunchUrl(IOS_LINK_FOR_PARTNER, launchMode: LaunchMode.externalApplication);
                    }
                  }
                }
              }
            },
            borderRadius: radius(),
          );
        },
      ).paddingAll(16),
    );
  }
}
