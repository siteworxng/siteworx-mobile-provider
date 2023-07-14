import 'package:flutter/material.dart';
import 'package:provider/screens/cash_management/model/cash_filter_model.dart';
import 'package:nb_utils/nb_utils.dart';

class StatusWidget extends StatelessWidget {
  final CashFilterModel data;
  final bool isSelected;

  StatusWidget({Key? key, required this.data, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4, left: 4),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: boxDecorationDefault(border: Border.all(color: context.dividerColor), color: isSelected ? context.primaryColor : context.cardColor),
      child: Text(data.name.validate(), style: primaryTextStyle(color: isSelected ? Colors.white : textPrimaryColorGlobal)),
    );
  }
}
