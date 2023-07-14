import 'package:flutter/material.dart';
import 'package:provider/components/image_border_component.dart';
import 'package:provider/main.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/provider/services/service_detail_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewWidget extends StatelessWidget {
  final RatingData data;
  final bool isCustomer;
  final bool showServiceName;

  ReviewWidget({required this.data, this.isCustomer = false, this.showServiceName = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (showServiceName) {
          ServiceDetailScreen(serviceId: data.serviceId.validate().toInt()).launch(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 8),
        width: context.width(),
        decoration: boxDecorationDefault(color: context.cardColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageBorder(
                    src: data.profileImage.validate().isNotEmpty ? data.profileImage.validate() : (isCustomer ? data.customerProfileImage.validate() : data.handymanProfileImage.validate()),
                    height: 50),
                16.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${data.customerName.validate()}', style: boldTextStyle(size: 14), maxLines: 1, overflow: TextOverflow.ellipsis).flexible(),
                        Row(
                          children: [
                            Image.asset(ic_star_fill, height: 16, color: getRatingBarColor(data.rating.validate().toInt())),
                            4.width,
                            Text('${data.rating.validate().toStringAsFixed(1).toString()}', style: boldTextStyle(color: getRatingBarColor(data.rating.validate().toInt()), size: 14)),
                          ],
                        ),
                      ],
                    ),
                    data.createdAt.validate().isNotEmpty ? Text(formatDate('${DateTime.parse(data.createdAt.validate())}', format: DATE_FORMAT_4), style: secondaryTextStyle()) : SizedBox(),
                    if (showServiceName) Text('${languages.lblService}: ${data.serviceName.validate()}', style: primaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis).paddingTop(8),
                    if (data.review != null) ReadMoreText(data.review.validate(), style: secondaryTextStyle(), trimLength: 100).paddingTop(8),
                  ],
                ).flexible(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
