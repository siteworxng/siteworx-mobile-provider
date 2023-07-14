import 'package:flutter/material.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/components/disabled_rating_bar_widget.dart';
import 'package:provider/components/image_border_component.dart';
import 'package:provider/components/review_list_view_component.dart';
import 'package:provider/components/view_all_label_component.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_info_model.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/screens/rating_view_all_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/configs.dart';
import '../utils/images.dart';

class HandymanInfoScreen extends StatefulWidget {
  final int? handymanId;
  final ServiceData? service;

  HandymanInfoScreen({this.handymanId, this.service});

  @override
  HandymanInfoScreenState createState() => HandymanInfoScreenState();
}

class HandymanInfoScreenState extends State<HandymanInfoScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget handymanWidget({required HandymanInfoResponse data}) {
    return SizedBox(
      child: Stack(
        children: [
          Container(
            height: 95,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: radiusCircular()),
              color: context.primaryColor,
            ),
          ),
          Positioned(
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: boxDecorationDefault(
                color: context.scaffoldBackgroundColor,
                border: Border.all(color: context.dividerColor, width: 1),
                borderRadius: radius(),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (data.handymanData!.profileImage.validate().isNotEmpty)
                        ImageBorder(
                          src: data.handymanData!.profileImage.validate(),
                          height: 90,
                        ),
                      16.width,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.height,
                          Text(data.handymanData!.displayName.validate(), style: boldTextStyle(size: 16)),
                          if (data.handymanData!.designation.validate().isNotEmpty)
                            Column(
                              children: [
                                4.height,
                                Marquee(child: Text(data.handymanData!.designation.validate(), style: secondaryTextStyle(weight: FontWeight.bold))),
                                4.height,
                              ],
                            ),
                          4.height,
                          if (data.handymanData!.createdAt != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languages.lblMemberSince, style: secondaryTextStyle(weight: FontWeight.bold)),
                                Text(" ${DateTime.parse(data.handymanData!.createdAt.validate()).year}", style: secondaryTextStyle(weight: FontWeight.bold)),
                              ],
                            ),
                          10.height,
                          DisabledRatingBarWidget(rating: data.handymanData!.handymanRating.validate().toDouble()),
                        ],
                      ).expand(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildBodyWidget(AsyncSnapshot<HandymanInfoResponse> snap) {
      if (snap.hasError) {
        return Text(snap.error.toString()).center();
      } else if (snap.hasData) {
        log(snap.data!.toJson());
        return Stack(
          children: [
            AnimatedScrollView(
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: context.statusBarHeight),
                      color: context.primaryColor,
                      child: Row(
                        children: [
                          BackWidget(),
                          16.width,
                          Text(languages.lblAboutHandyman, style: boldTextStyle(color: Colors.white, size: 18)),
                        ],
                      ),
                    ),
                    handymanWidget(data: snap.data!),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snap.data!.handymanData!.knownLanguagesArray.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(languages.knownLanguages, style: boldTextStyle()),
                                  8.height,
                                  Wrap(
                                    children: snap.data!.handymanData!.knownLanguagesArray.map((e) {
                                      return Container(
                                        decoration: boxDecorationWithRoundedCorners(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        margin: EdgeInsets.all(4),
                                        child: Text(e, style: secondaryTextStyle(weight: FontWeight.bold)),
                                      );
                                    }).toList(),
                                  ),
                                  16.height,
                                ],
                              ),
                            if (snap.data!.handymanData!.skillsArray.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(languages.essentialSkills, style: boldTextStyle()),
                                  8.height,
                                  Wrap(
                                    children: snap.data!.handymanData!.skillsArray.map((e) {
                                      return Container(
                                        decoration: boxDecorationWithRoundedCorners(
                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                          backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        margin: EdgeInsets.all(4),
                                        child: Text(e, style: secondaryTextStyle(weight: FontWeight.bold)),
                                      );
                                    }).toList(),
                                  ),
                                  16.height,
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(languages.personalInfo, style: boldTextStyle()),
                                8.height,
                                TextIcon(
                                  spacing: 10,
                                  onTap: () {
                                    launchMail("${snap.data!.handymanData!.email.validate()}");
                                  },
                                  prefix: Image.asset(ic_message, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                                  text: snap.data!.handymanData!.email.validate(),
                                  textStyle: secondaryTextStyle(size: 14),
                                  expandedText: true,
                                ),
                                4.height,
                                TextIcon(
                                  spacing: 10,
                                  onTap: () {
                                    launchCall("${snap.data!.handymanData!.contactNumber.validate()}");
                                  },
                                  prefix: Image.asset(calling, width: 16, height: 16, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                                  text: snap.data!.handymanData!.contactNumber.validate(),
                                  textStyle: secondaryTextStyle(size: 14),
                                  expandedText: true,
                                ),
                                8.height,
                              ],
                            ),
                          ],
                        ),
                        ViewAllLabel(
                          label: languages.review,
                          list: snap.data!.handymanRatingReview!,
                          onTap: () {
                            RatingViewAllScreen(handymanId: snap.data!.handymanData!.id).launch(context);
                          },
                        ),
                        snap.data!.handymanRatingReview.validate().isNotEmpty
                            ? ReviewListViewComponent(
                                ratings: snap.data!.handymanRatingReview!,
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(vertical: 6),
                                isCustomer: true,
                              )
                            : Text(languages.lblNoReviewYet, style: secondaryTextStyle()).center().paddingOnly(top: 16),
                      ],
                    ).paddingAll(16),
                  ],
                ),
              ],
            ),
          ],
        );
      }
      return LoaderWidget().center();
    }

    return FutureBuilder<HandymanInfoResponse>(
      future: getProviderDetail(widget.handymanId.validate()),
      builder: (context, snap) {
        return Scaffold(
          body: buildBodyWidget(snap),
        );
      },
    );
  }
}
