import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/jobRequest/components/bid_price_dialog.dart';
import 'package:provider/provider/jobRequest/models/post_job_detail_response.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import 'models/bidder_data.dart';
import 'models/post_job_data.dart';

class JobPostDetailScreen extends StatefulWidget {
  final PostJobData postJobData;

  JobPostDetailScreen({required this.postJobData});

  @override
  _JobPostDetailScreenState createState() => _JobPostDetailScreenState();
}

class _JobPostDetailScreenState extends State<JobPostDetailScreen> {
  late Future<PostJobDetailResponse> future;

  int page = 1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPostJobDetail({PostJob.postRequestId: widget.postJobData.id.validate()});
  }

  Widget titleWidget({required String title, required String detail, bool isReadMore = false, required TextStyle detailTextStyle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.validate(), style: secondaryTextStyle()),
        8.height,
        if (isReadMore) ReadMoreText(detail, style: detailTextStyle) else Text(detail.validate(), style: detailTextStyle),
        16.height,
      ],
    );
  }

  Widget postJobDetailWidget({required PostJobData data}) {
    return Container(
      padding: EdgeInsets.all(16),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.title.validate().isNotEmpty)
            titleWidget(
              title: languages.postJobTitle,
              detail: data.title.validate(),
              detailTextStyle: boldTextStyle(),
            ),
          if (data.description.validate().isNotEmpty)
            titleWidget(
              title: languages.postJobDescription,
              detail: data.description.validate(),
              detailTextStyle: primaryTextStyle(),
              isReadMore: true,
            ),
          Text(data.status.validate() == JOB_REQUEST_STATUS_ACCEPTED ? languages.jobPrice : languages.estimatedPrice, style: secondaryTextStyle()),
          8.height,
          PriceWidget(
            price: data.status.validate() == JOB_REQUEST_STATUS_ACCEPTED ? data.jobPrice.validate() : data.price.validate(),
            isHourlyService: false,
            color: textPrimaryColorGlobal,
            isFreeService: false,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget postJobServiceWidget({required List<ServiceData> serviceList}) {
    if (serviceList.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        Text(languages.lblServices, style: boldTextStyle(size: LABEL_TEXT_SIZE)).paddingOnly(left: 16, right: 16),
        AnimatedListView(
          itemCount: serviceList.length,
          padding: EdgeInsets.all(8),
          shrinkWrap: true,
          itemBuilder: (_, i) {
            ServiceData data = serviceList[i];

            return Container(
              width: context.width(),
              margin: EdgeInsets.all(8),
              padding: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Text(data.name.validate(), style: primaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget providerWidget(List<BidderData> bidderList) {
    try {
      if (bidderList.any((element) => element.providerId == appStore.userId)) {
        BidderData? bidderData = bidderList.firstWhere((element) => element.providerId == appStore.userId);
        UserData? user = bidderData.provider;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.height,
            Text(languages.myBid, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
            16.height,
            Container(
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: user!.profileImage.validate(),
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                    circle: true,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Marquee(
                        directionMarguee: DirectionMarguee.oneDirection,
                        child: Text(
                          user.displayName.validate(),
                          style: boldTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      4.height,
                      PriceWidget(price: bidderData.price.validate()),
                    ],
                  ).expand(),
                ],
              ),
            ),
            16.height,
          ],
        ).paddingOnly(left: 16, right: 16);
      }
    } catch (e) {
      print(e);
    }

    return Offstage();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: '${widget.postJobData.title}',
      body: Stack(
        children: [
          SnapHelperWidget<PostJobDetailResponse>(
            future: future,
            onSuccess: (data) {
              return Stack(
                children: [
                  AnimatedScrollView(
                    padding: EdgeInsets.only(bottom: 60),
                    physics: AlwaysScrollableScrollPhysics(),
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    onSwipeRefresh: () async {
                      page = 1;

                      init();
                      setState(() {});

                      return await 2.seconds.delay;
                    },
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          postJobDetailWidget(data: data.postRequestDetail!).paddingAll(16),
                          providerWidget(data.bidderData.validate()),
                          postJobServiceWidget(serviceList: data.postRequestDetail!.service.validate()),
                          24.height,
                        ],
                      ),
                    ],
                  ),
                  if (data.postRequestDetail!.canBid.validate())
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: AppButton(
                        child: Text(languages.bid, style: boldTextStyle(color: white)),
                        color: context.primaryColor,
                        width: context.width(),
                        onTap: () async {
                          bool? res = await showInDialog(
                            context,
                            contentPadding: EdgeInsets.zero,
                            hideSoftKeyboard: true,
                            backgroundColor: context.cardColor,
                            builder: (_) => BidPriceDialog(data: widget.postJobData),
                          );

                          if (res ?? false) {
                            init();
                            setState(() {});
                          }
                        },
                      ),
                    ),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: languages.reload,
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
            loadingWidget: LoaderWidget(),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
