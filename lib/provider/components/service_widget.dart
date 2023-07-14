import 'package:flutter/material.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/disabled_rating_bar_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceComponent extends StatelessWidget {
  final ServiceData data;
  final double width;

  ServiceComponent({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 400.milliseconds,
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
      ),
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 205,
            width: context.width(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CachedImageWidget(
                  url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                  fit: BoxFit.cover,
                  height: 180,
                  width: context.width(),
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    constraints: BoxConstraints(maxWidth: context.width() * 0.3),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: context.cardColor.withOpacity(0.9),
                      borderRadius: radius(24),
                    ),
                    child: Marquee(
                      directionMarguee: DirectionMarguee.oneDirection,
                      child: Text(
                        "${data.subCategoryName.validate().isNotEmpty ? data.subCategoryName.validate() : data.categoryName.validate()}".toUpperCase(),
                        style: boldTextStyle(color: appStore.isDarkMode ? white : primaryColor, size: 12),
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: boxDecorationWithShadow(
                      backgroundColor: primaryColor,
                      borderRadius: radius(24),
                      border: Border.all(color: context.cardColor, width: 2),
                    ),
                    child: PriceWidget(
                      price: data.price.validate(),
                      isHourlyService: data.type.validate() == SERVICE_TYPE_HOURLY,
                      color: Colors.white,
                      hourlyTextColor: Colors.white,
                      size: 14,
                      isFreeService: data.isFreeService,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 16,
                  child: DisabledRatingBarWidget(rating: data.totalRating.validate(), size: 14),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              Marquee(
                directionMarguee: DirectionMarguee.oneDirection,
                child: Text(data.name.validate(), style: boldTextStyle()).paddingSymmetric(horizontal: 16),
              ),
              16.height,
            ],
          ),
        ],
      ),
    );
  }
}
