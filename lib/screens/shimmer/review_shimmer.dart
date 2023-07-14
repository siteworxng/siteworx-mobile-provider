import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ReviewShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      physics: AlwaysScrollableScrollPhysics(),
      slideConfiguration: SlideConfiguration(delay: 50.milliseconds),
      listAnimationType: ListAnimationType.None,
      itemBuilder: (context, index) {
        return Container(
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
                  ShimmerWidget(height: 50, width: 50),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerWidget(height: 10, width: context.width()).flexible(),
                          8.width,
                          Row(
                            children: [
                              Image.asset(ic_star_fill, height: 16, color: getRatingBarColor(5)),
                              4.width,
                              Text('5', style: boldTextStyle(color: getRatingBarColor(5))),
                            ],
                          ),
                        ],
                      ),
                      8.height,
                      ShimmerWidget(height: 10, width: context.width() * 0.15),
                      ShimmerWidget(height: 10, width: context.width()).paddingTop(8),
                      ShimmerWidget(height: 10, width: context.width()).paddingTop(8),
                    ],
                  ).flexible(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
