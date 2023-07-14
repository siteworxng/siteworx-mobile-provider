import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CashConfirmDialog extends StatefulWidget {
  final int bookingId;
  final num bookingAmount;
  final Function(String remarks) onAccept;

  CashConfirmDialog({required this.bookingId, Key? key, required this.bookingAmount, required this.onAccept}) : super(key: key);

  @override
  State<CashConfirmDialog> createState() => _CashConfirmDialogState();
}

class _CashConfirmDialogState extends State<CashConfirmDialog> {
  TextEditingController remarkCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: context.width(),
          padding: EdgeInsets.all(16),
          color: context.cardColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichTextWidget(
                textAlign: TextAlign.center,
                list: [
                  TextSpan(text: languages.yourCashPaymentForBookingId, style: primaryTextStyle()),
                  TextSpan(text: " #${widget.bookingId}", style: boldTextStyle()),
                  TextSpan(text: " ${languages.isAcceptedAsOn}", style: primaryTextStyle()),
                  TextSpan(text: " ${formatDate(DateTime.now().toString(), format: DATE_FORMAT_9, isLanguageNeeded: true)}", style: boldTextStyle()),
                ],
              ),
              26.height,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('${languages.amountToBeReceived}:  ', style: secondaryTextStyle()),
                  PriceWidget(price: widget.bookingAmount.validate(), size: 16),
                ],
              ).center(),
              26.height,
              AppTextField(
                textFieldType: TextFieldType.MULTILINE,
                controller: remarkCont,
                decoration: inputDecoration(
                  context,
                  hint: languages.remark,
                  fillColor: context.scaffoldBackgroundColor,
                ),
                minLines: 4,
              ),
              32.height,
              Row(
                children: [
                  AppButton(
                    text: languages.lblCancel,
                    onTap: () {
                      finish(context);
                    },
                    color: context.scaffoldBackgroundColor,
                    shapeBorder: RoundedRectangleBorder(side: BorderSide(color: context.primaryColor), borderRadius: radius()),
                    textColor: context.primaryColor,
                  ).expand(),
                  16.width,
                  AppButton(
                    text: languages.confirm,
                    color: context.primaryColor,
                    onTap: () {
                      widget.onAccept.call(remarkCont.text);
                    },
                  ).expand(),
                ],
              ),
            ],
          ),
        ),
        Observer(
          builder: (BuildContext context) {
            return LoaderWidget().visible(appStore.isLoading);
          },
        ),
      ],
    );
  }
}
