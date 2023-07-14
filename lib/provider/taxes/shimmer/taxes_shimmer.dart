import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class TaxesShimmer extends StatelessWidget {
  const TaxesShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
      padding: EdgeInsets.all(8),
      listAnimationType: ListAnimationType.None,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  ShimmerWidget(height: 10, width: context.width() * 0.15),
                ],
              ),
              8.height,
              Row(
                children: [
                  ShimmerWidget(height: 10, width: context.width() * 0.25),
                  4.width,
                  Row(
                    children: [
                      ShimmerWidget(height: 10, width: context.width() * 0.25),
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                    ],
                  ).expand()
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
