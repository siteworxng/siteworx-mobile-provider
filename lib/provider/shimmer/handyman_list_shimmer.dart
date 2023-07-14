import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/main.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
      child: AnimatedWrap(
        spacing: 16,
        runSpacing: 16,
        listAnimationType: ListAnimationType.Scale,
        scaleConfiguration: ScaleConfiguration(duration: 300.milliseconds, delay: 50.milliseconds),
        itemCount: 20,
        itemBuilder: (_, index) {
          return Container(
            height: 200,
            width: context.width() * 0.5 - 26,
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
            child: Column(
              children: [
                ShimmerWidget(height: 120, width: context.width(), backgroundColor: context.cardColor),
                16.height,
                ShimmerWidget(height: 10, width: context.width() * 0.23),
                16.height,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerWidget(
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                      ),
                    ),
                    16.width,
                    ShimmerWidget(
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
