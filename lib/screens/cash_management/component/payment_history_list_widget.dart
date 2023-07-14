import 'package:flutter/material.dart';
import 'package:provider/screens/cash_management/model/payment_history_model.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/dashed_rect.dart';
import 'package:provider/utils/extensions/color_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class PaymentHistoryListWidget extends StatelessWidget {
  const PaymentHistoryListWidget({Key? key, required this.data, required this.index, required this.length}) : super(key: key);

  final PaymentHistoryData data;
  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            data.datetime.toString().validate().isNotEmpty ? Text(formatDate(data.datetime.toString().validate(), format: DATE_FORMAT_3), style: secondaryTextStyle()).fit() : SizedBox(),
            8.height,
            data.datetime.toString().validate().isNotEmpty ? Text(formatDate(data.datetime.toString().validate(), format: DATE_FORMAT_4), style: primaryTextStyle(size: 12)) : SizedBox(),
          ],
        ).withWidth(55),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: data.status.validate().getCashPaymentStatusBackgroundColor,
                borderRadius: radius(16),
              ),
            ),
            SizedBox(
              height: 65,
              child: DashedRect(gap: 3, color: data.status.validate().getCashPaymentStatusBackgroundColor, strokeWidth: 1.5),
            ).visible(index != length - 1),
          ],
        ),
        16.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextIcon(
              expandedText: true,
              edgeInsets: EdgeInsets.only(right: 4, left: 4, bottom: 4),
              text: data.action.validate().replaceAll('_', ' ').capitalizeFirstLetter(),
              textStyle: boldTextStyle(),
            ),
            Text(
              data.text.validate().replaceAll('_', ' '),
              style: secondaryTextStyle(),
            ).paddingOnly(left: 4),
          ],
        ).paddingOnly(bottom: 18).expand()
      ],
    );
  }
}
