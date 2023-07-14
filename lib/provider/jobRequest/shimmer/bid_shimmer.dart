import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class BidShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedListView(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(8),
      listAnimationType: ListAnimationType.None,
      itemBuilder: (_, i) => Container(
        width: context.width(),
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: boxDecorationDefault(color: context.cardColor, borderRadius: radius()),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerWidget(height: 60, width: 60),
            16.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                8.height,
                ShimmerWidget(height: 10, width: context.width()),
                4.height,
                ShimmerWidget(height: 10, width: context.width() * 0.25),
                4.height,
                ShimmerWidget(height: 10, width: context.width() * 0.25),
              ],
            ).expand(),
            16.width,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: context.scaffoldBackgroundColor, borderRadius: radius(8)),
              child: ShimmerWidget(height: 10, width: context.width() * 0.12),
            ),
          ],
        ),
      ),
    );
  }
}
