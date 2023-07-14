import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/screens/cash_management/cash_constant.dart';
import 'package:provider/screens/cash_management/model/cash_filter_model.dart';
import 'package:provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class CashInfoWidget extends StatelessWidget {
  const CashInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CashFilterModel> statusInfoList = getStatusInfo();
    return Container(
      width: context.width(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          8.height,
          Text('Status', style: boldTextStyle(size: 18)).paddingSymmetric(horizontal: 16, vertical: 16).center(),
          ...List.generate(
            statusInfoList.length,
            (index) {
              CashFilterModel data = statusInfoList[index];
              return Container(
                margin: EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: boxDecorationDefault(color: data.color, shape: BoxShape.circle),
                    ),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(handleStatusText(status: data.type.validate()), style: boldTextStyle()),
                        0.height,
                        Text(data.name.validate(), style: primaryTextStyle()),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          32.height,
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                finish(context);
              },
              child: Text(languages.close, style: primaryTextStyle(color: primaryColor, size: 14)),
            ),
          ).paddingRight(8),
          8.height,
        ],
      ),
    );
  }
}
