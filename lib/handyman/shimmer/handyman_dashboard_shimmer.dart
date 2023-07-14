import 'package:flutter/material.dart';
import 'package:provider/components/shimmer_widget.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanDashboardShimmer extends StatelessWidget {
  final List totalList = ["", "", "", ""];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(height: 10, width: context.width() * 0.25).paddingLeft(16),
          8.height,
          ShimmerWidget(height: 10, width: context.width() * 0.25).paddingLeft(16),

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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: context.cardColor),
                  child: ShimmerWidget(width: 22, height: 22).cornerRadiusWithClipRRect(11),
                ),
              ],
            ),
          ),
          8.height,

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
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: ShimmerWidget(height: 250, width: context.width()),
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
          ),
          16.height,

          /// Review List
          Column(
            children: [
              ShimmerWidget(height: 10, width: context.width() * 0.25),
              16.height,
              AnimatedListView(
                itemCount: 3,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.None,
                itemBuilder: (_, i) {
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
                                    ShimmerWidget(height: 10, width: context.width() * 0.25).flexible(),
                                    Row(
                                      children: [
                                        Image.asset(ic_star_fill, height: 16, color: getRatingBarColor(5)),
                                        4.width,
                                        Text('5', style: boldTextStyle(color: getRatingBarColor(5))),
                                      ],
                                    ),
                                  ],
                                ),
                                ShimmerWidget(height: 10, width: context.width() * 0.25),
                                ShimmerWidget(height: 10, width: context.width() * 0.25).paddingTop(8),
                                ShimmerWidget(height: 10, width: context.width() * 0.25).paddingTop(8),
                              ],
                            ).flexible(),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
