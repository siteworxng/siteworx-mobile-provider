import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/main.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListShimmer extends StatelessWidget {
  final double? width;

  ServiceListShimmer({this.width});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// AppTextField
          ShimmerWidget(height: 50, width: context.width()).paddingOnly(left: 16, right: 16, top: 24, bottom: 8),

          /// Service list
          Container(
            alignment: Alignment.topLeft,
            child: AnimatedWrap(
              spacing: 16.0,
              runSpacing: 16.0,
              scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
              listAnimationType: ListAnimationType.Scale,
              alignment: WrapAlignment.start,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  width: context.width() / 2 - 24,
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: radius(),
                    backgroundColor: context.cardColor,
                    border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWidget(
                        height: 205,
                        width: context.width() / 2 - 24,
                      ),
                      16.height,
                      ShimmerWidget(
                        height: 10,
                        width: 100,
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                      Row(
                        children: [
                          ShimmerWidget(
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: boxDecorationDefault(shape: BoxShape.circle, color: context.cardColor),
                            ),
                          ),
                          8.width,
                          ShimmerWidget(height: 10, width: context.width() * 0.15).expand()
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ),
                );
              },
            ).paddingSymmetric(horizontal: 16, vertical: 24),
          ),
        ],
      ),
    );
  }
}
