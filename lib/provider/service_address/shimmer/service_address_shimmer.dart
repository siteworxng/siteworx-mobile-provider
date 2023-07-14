import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceAddressShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      listAnimationType: ListAnimationType.None,
      slideConfiguration: SlideConfiguration(verticalOffset: 400),
      disposeScrollController: false,
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      itemBuilder: (_, i) {
        return Container(
          padding: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 16),
          margin: EdgeInsets.only(bottom: 16),
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: context.cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(height: 10, width: context.width()).expand(),
                  ShimmerWidget(height: 35, width: 60).cornerRadiusWithClipRRect(40).paddingLeft(16),
                ],
              ),
              Row(
                children: [
                  ShimmerWidget(height: 10, width: context.width() * 0.15),
                  16.width,
                  ShimmerWidget(height: 10, width: context.width() * 0.15),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
