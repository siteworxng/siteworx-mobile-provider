import 'package:flutter/material.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/extensions/color_extension.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/cached_image_widget.dart';
import '../../../components/price_widget.dart';
import '../job_post_detail_screen.dart';
import '../models/post_job_data.dart';

class JobItemWidget extends StatelessWidget {
  final PostJobData? data;

  const JobItemWidget({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) return Offstage();

    return Container(
      width: context.width(),
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            url: data!.service.validate().isNotEmpty && data!.service.validate().first.imageAttachments.validate().isNotEmpty ? data!.service.validate().first.imageAttachments!.first.validate() : "",
            fit: BoxFit.cover,
            height: 60,
            width: 60,
            radius: defaultRadius,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data!.title.validate(), style: primaryTextStyle(), maxLines: 1, overflow: TextOverflow.ellipsis),
              2.height,
              PriceWidget(
                price: data!.price.validate(),
                isHourlyService: false,
                color: textPrimaryColorGlobal,
                isFreeService: false,
                size: 14,
              ),
              2.height,
              Text(formatDate(data!.createdAt.validate()), style: secondaryTextStyle(), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ).expand(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: data!.status.validate().getJobStatusColor.withOpacity(0.1),
              borderRadius: radius(8),
            ),
            child: Text(
              data!.status.validate().toPostJobStatus(),
              style: boldTextStyle(color: data!.status.validate().getJobStatusColor, size: 12),
            ),
          ),
        ],
      ).onTap(() {
        JobPostDetailScreen(postJobData: data!).launch(context);
      }, borderRadius: radius()),
    );
  }
}
