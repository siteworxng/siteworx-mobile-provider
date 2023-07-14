import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TotalWidget extends StatelessWidget {
  final String title;
  final String total;
  final String icon;
  final Color? color;

  TotalWidget({required this.title, required this.total, required this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: boxDecorationDefault(color: context.primaryColor),
      width: context.width() / 2 - 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: context.width() / 2 - 94,
                child: Marquee(
                  child: Marquee(child: Text(total.validate(), style: boldTextStyle(color: Colors.white, size: 16), maxLines: 1)),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Image.asset(icon, width: 18, height: 18, color: context.primaryColor),
              ),
            ],
          ),
          8.height,
          Marquee(child: Text(title, style: secondaryTextStyle(size: 14, color: Colors.white))),
        ],
      ),
    );
  }
}
