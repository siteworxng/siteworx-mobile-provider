import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/main.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderDashboardShimmer extends StatelessWidget {
  final List totalList = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16),
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Plan Banner
          Container(
            color: context.cardColor,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    ShimmerWidget(height: 10, width: context.width()),
                    8.height,
                    ShimmerWidget(height: 10, width: context.width()),
                  ],
                ).flexible(),
                16.width,
                Container(
                  decoration: BoxDecoration(borderRadius: radius(defaultRadius)),
                  child: ShimmerWidget(height: 45, width: 70),
                ),
              ],
            ),
          ),

          /// Build Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingLeft(16),
              8.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25).paddingLeft(16),
            ],
          ),

          /// Commission Widget
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            margin: EdgeInsets.only(top: 24, left: 16, right: 16),
            decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8), backgroundColor: context.cardColor),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(height: 10, width: context.width()),
                    8.height,
                    ShimmerWidget(height: 10, width: context.width()),
                  ],
                ).expand(),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.scaffoldBackgroundColor),
                  child: ShimmerWidget(width: 22, height: 22).cornerRadiusWithClipRRect(11),
                ),
              ],
            ),
          ),

          /// Total Widget
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: totalList.map((e) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: boxDecorationDefault(color: context.cardColor),
                width: context.width() / 2 - 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: context.width() / 2 - 94, child: ShimmerWidget(height: 10, width: context.width() * 0.12)),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor),
                          child: ShimmerWidget(height: 18, width: 18),
                        ),
                      ],
                    ),
                    8.height,
                    ShimmerWidget(height: 10, width: context.width() * 0.25),
                  ],
                ),
              );
            }).toList(),
          ).paddingSymmetric(horizontal: 16, vertical: 16),

          /// Chart widget
          Container(
            height: 250,
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ShimmerWidget(height: 250, width: context.width()),
          ),

          /// Handyman List
          Container(
            color: context.cardColor,
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(height: 10, width: context.width() * 0.25),
                16.height,
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: List.generate(
                    4,
                    (index) {
                      return Container(
                        height: 200,
                        width: context.width() * 0.48 - 20,
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
                ),
              ],
            ),
          ),

          /// Upcoming Booking
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              AnimatedListView(
                itemCount: 3,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.None,
                itemBuilder: (_, i) => Container(
                  width: context.width(),
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: context.scaffoldBackgroundColor, border: Border.all(color: context.dividerColor), borderRadius: radius()),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(height: 80, width: 80),
                          16.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(borderRadius: radius(8), color: Colors.transparent),
                                    child: ShimmerWidget(height: 20, width: context.width() * 0.24),
                                  ).flexible(),
                                  8.width,
                                  ShimmerWidget(height: 20, width: 50),
                                ],
                              ),
                              4.height,
                              ShimmerWidget(height: 20, width: context.width()),
                              4.height,
                              ShimmerWidget(height: 20, width: context.width()),
                            ],
                          ).expand(),
                        ],
                      ).paddingAll(8),
                    ],
                  ),
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),

          /// Post Job List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              AnimatedListView(
                itemCount: 3,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.None,
                itemBuilder: (_, i) {
                  return Container(
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
                  );
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 16),

          /// Service List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.height,
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: List.generate(
                  4,
                  (index) {
                    return Container(
                      width: context.width() * 0.5 - 24,
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(),
                        backgroundColor: context.cardColor,
                        border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerWidget(height: 205, width: context.width() / 2 - 24),
                          16.height,
                          ShimmerWidget(height: 10, width: context.width()).paddingSymmetric(horizontal: 16),
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
                              ShimmerWidget(height: 10, width: context.width()).expand()
                            ],
                          ).paddingSymmetric(horizontal: 16),
                          16.height,
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
        ],
      ),
    );
  }
}
