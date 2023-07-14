import 'package:flutter/material.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/screens/cash_management/view/cash_balance_detail_screen.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TodayCashComponent extends StatelessWidget {
  final num todayCashAmount;

  const TodayCashComponent({Key? key, required this.todayCashAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        CashBalanceDetailScreen().launch(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 16),
        decoration: boxDecorationDefault(borderRadius: radius(), color: context.cardColor),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: boxDecorationDefault(color: context.primaryColor, shape: BoxShape.circle),
                  padding: EdgeInsets.all(8),
                  child: Image.asset(un_fill_wallet, color: Colors.white, height: 24),
                ),
                16.width,
                Text(languages.todayCash, style: boldTextStyle()).expand(),
                16.width,
                PriceWidget(price: todayCashAmount, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
