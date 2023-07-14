import 'package:flutter/material.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/screens/booking_detail_screen.dart';
import 'package:provider/screens/cash_management/cash_constant.dart';
import 'package:provider/screens/cash_management/cash_repository.dart';
import 'package:provider/screens/cash_management/model/payment_history_model.dart';
import 'package:provider/screens/cash_management/view/pay_to_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/color_extension.dart';
import 'package:nb_utils/nb_utils.dart';

class CashListWidget extends StatefulWidget {
  final PaymentHistoryData data;
  final Function() onRefresh;

  const CashListWidget({Key? key, required this.data, required this.onRefresh}) : super(key: key);

  @override
  State<CashListWidget> createState() => _CashListWidgetState();
}

class _CashListWidgetState extends State<CashListWidget> {
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

  Widget _buildActionWidget({required String status}) {
    if (status == APPROVED_BY_HANDYMAN) {
      return AppButton(
        width: context.width(),
        color: context.primaryColor,
        text: languages.sendCashToProvider,
        onTap: () async {
          await PayToScreen(paymentData: widget.data, totalNumberOfBookings: 1).launch(context);
          widget.onRefresh.call();
        },
      );
    } else if (isUserTypeProvider && status == APPROVED_BY_PROVIDER) {
      return AppButton(
        width: context.width(),
        color: context.primaryColor,
        text: languages.sendCashToAdmin,
        onTap: () async {
          await PayToScreen(paymentData: widget.data, totalNumberOfBookings: 1).launch(context);
          widget.onRefresh.call();
        },
      );
    } else if (status == PENDING_BY_PROVIDER) {
      return AppButton(
        width: context.width(),
        color: context.primaryColor,
        text: languages.cashPaymentApproval,
        onTap: () {
          transferAmountAPI(
            context,
            isFinishRequired: false,
            paymentData: widget.data,
            status: APPROVED_BY_PROVIDER,
            action: PROVIDER_APPROVED_CASH,
            onTap: () {
              widget.onRefresh.call();
            },
          );
        },
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BookingDetailScreen(
          bookingId: widget.data.bookingId.validate().toInt(),
        ).launch(context);
      },
      child: Container(
        decoration: boxDecorationDefault(color: context.cardColor),
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Marquee(
                      child: PriceWidget(price: widget.data.totalAmount.validate(), size: 18, color: appStore.isDarkMode ? Colors.white : context.primaryColor),
                    ).expand(),
                    if (widget.data.status.validate() != APPROVED_BY_HANDYMAN)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: radius(8),
                        ),
                        child: Marquee(
                          child: Text(
                            handleBankText(status: widget.data.type.validate()),
                            style: boldTextStyle(color: primaryColor, size: 12),
                          ),
                        ),
                      ),
                    4.width,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.data.status.validate().getCashPaymentStatusBackgroundColor.withOpacity(0.1),
                        borderRadius: radius(8),
                      ),
                      child: Marquee(
                        child: Text(
                          handleStatusText(status: widget.data.status.validate()),
                          style: boldTextStyle(color: widget.data.status.validate().getCashPaymentStatusBackgroundColor, size: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${languages.lblBookingID}', style: secondaryTextStyle()),
                    8.width,
                    Text(
                      widget.data.bookingId.toString().suffixText(value: "#"),
                      style: boldTextStyle(size: 12),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ).expand(),
                  ],
                ).paddingAll(8),
                Divider(color: context.dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${languages.lblDate} ${languages.ofTransfer}', style: secondaryTextStyle()),
                    8.width,
                    Text(
                      "${formatDate(widget.data.datetime.toString(), format: DATE_FORMAT_9)}",
                      style: boldTextStyle(size: 12),
                      maxLines: 2,
                      textAlign: TextAlign.right,
                    ).expand(),
                  ],
                ).paddingAll(8),
                Divider(color: context.dividerColor),
                Text(
                  "${widget.data.text.validate()}",
                  style: secondaryTextStyle(size: 12),
                  maxLines: 2,
                ).paddingAll(8),
                if (widget.data.isTypeBank)
                  Column(
                    children: [
                      Divider(color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('${languages.refNumber}: ', style: secondaryTextStyle()),
                          8.width,
                          Text(
                            "${widget.data.txnId.validate()}",
                            style: boldTextStyle(size: 12),
                            maxLines: 2,
                            textAlign: TextAlign.right,
                          ).expand(),
                          16.height,
                        ],
                      ).paddingAll(8),
                    ],
                  ),
              ],
            ),
            _buildActionWidget(status: widget.data.status.validate()),
          ],
        ),
      ),
    );
  }
}
