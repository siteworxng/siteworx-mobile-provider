import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderPaymentShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      itemCount: 15,
      listAnimationType: ListAnimationType.None,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(8),
          width: context.width(),
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(),
            backgroundColor: context.scaffoldBackgroundColor,
            border: Border.all(color: context.dividerColor, width: 1.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: boxDecorationWithRoundedCorners(
                  backgroundColor: primaryColor.withOpacity(0.2),
                  borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                ),
                width: context.width(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerWidget(height: 20, width: context.width() * 0.25),
                    ShimmerWidget(height: 10, width: context.width() * 0.15),
                  ],
                ),
              ),
              4.height,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                    ],
                  ).paddingSymmetric(vertical: 4),
                  Divider(thickness: 0.9, color: context.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                    ],
                  ).paddingSymmetric(vertical: 4),
                  Divider(thickness: 0.9, color: context.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                    ],
                  ).paddingSymmetric(vertical: 4),
                  Divider(thickness: 0.9, color: context.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                    ],
                  ).paddingSymmetric(vertical: 4),
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 10),
              8.height,
            ],
          ),
        );
      },
    );
  }
}
