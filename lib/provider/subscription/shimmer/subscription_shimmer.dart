import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class SubscriptionShimmer extends StatelessWidget {
  const SubscriptionShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      listAnimationType: ListAnimationType.None,
      slideConfiguration: SlideConfiguration(verticalOffset: 400),
      disposeScrollController: false,
      itemBuilder: (BuildContext context, index) {
        return Container(
          width: context.width(),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: radius(),
            border: Border.all(width: 1, color: context.dividerColor),
          ),
          child: Column(
            children: [
              ShimmerWidget(width: context.width() * 0.35, height: 10),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(width: context.width() * 0.15, height: 10),
                  ShimmerWidget(width: context.width() * 0.15, height: 10),
                ],
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(width: context.width() * 0.15, height: 10),
                  ShimmerWidget(width: context.width() * 0.15, height: 10),
                ],
              ),
              Column(
                children: [
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerWidget(width: context.width() * 0.15, height: 10),
                      16.width,
                      ShimmerWidget(width: context.width() * 0.15, height: 10),
                    ],
                  ),
                ],
              ),
              16.height,
              ShimmerWidget(height: 45, width: context.width()).cornerRadiusWithClipRRect(defaultRadius)
            ],
          ),
        );
      },
    );
  }
}
