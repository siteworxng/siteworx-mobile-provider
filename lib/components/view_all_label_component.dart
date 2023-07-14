import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewAllLabel extends StatelessWidget {
  final String label;
  final String? subLabel;
  final List list;
  final VoidCallback? onTap;
  final int? labelSize;

  ViewAllLabel({required this.label, this.subLabel, this.onTap, this.labelSize, required this.list});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: boldTextStyle(size: labelSize ?? LABEL_TEXT_SIZE)),
            if (subLabel.validate().isNotEmpty) Text(subLabel!, style: secondaryTextStyle(size: 12)).paddingTop(4),
          ],
        ),
        TextButton(
          onPressed: isViewAllVisible(list)
              ? () {
                  onTap?.call();
                }
              : null,
          child: isViewAllVisible(list) ? Text(languages.viewAll, style: secondaryTextStyle()) : SizedBox(),
        )
      ],
    );
  }
}

bool isViewAllVisible(List list) => list.length >= 4;
