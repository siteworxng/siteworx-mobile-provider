import 'package:flutter/material.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/models/wallet_history_list_response.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

///Remove unused widget
class WalletWidget extends StatefulWidget {
  final WalletHistory data;

  WalletWidget(this.data);

  @override
  WalletWidgetState createState() => WalletWidgetState();
}

class WalletWidgetState extends State<WalletWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: EdgeInsets.all(8),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: viewLineColor),
        backgroundColor: context.scaffoldBackgroundColor,
      ),
      width: context.width(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.data.activityData!.title.validate(), style: boldTextStyle()),
              8.height,
              Text(formatDate(widget.data.datetime.validate(), format: DATE_FORMAT_2), style: secondaryTextStyle()),
            ],
          ),
          PriceWidget(price: widget.data.activityData!.amount.validate(), color: primaryColor, isBoldText: true)
        ],
      ),
    );
  }
}
