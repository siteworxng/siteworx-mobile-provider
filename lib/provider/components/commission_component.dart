import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/dashboard_response.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class CommissionComponent extends StatelessWidget {
  final Commission commission;

  CommissionComponent({required this.commission});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      margin: EdgeInsets.only(top: 24, left: 16, right: 16),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(8),
        backgroundColor: context.cardColor,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(text: '${languages.lblProviderType}: ', style: secondaryTextStyle(size: 12)),
                  TextSpan(text: '${commission.name.validate()}', style: boldTextStyle(size: 12)),
                ],
              ),
              8.height,
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(text: '${languages.lblMyCommission}: ', style: secondaryTextStyle(size: 12)),
                  TextSpan(
                    text: isCommissionTypePercent(commission.type)
                        ? '${commission.commission.validate()}%'
                        : '${isCurrencyPositionLeft ? appStore.currencySymbol : ""}${commission.commission.validate()}${isCurrencyPositionRight ? appStore.currencySymbol : ""}',
                    style: boldTextStyle(size: 12),
                  ),
                  if (isCommissionTypePercent(commission.type)) TextSpan(text: ' (${languages.lblFixed})', style: secondaryTextStyle(size: 12)),
                ],
              ),
            ],
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
            child: Image.asset(percent_line, height: 18, width: 18, color: white),
          ),
        ],
      ),
    );
  }
}
