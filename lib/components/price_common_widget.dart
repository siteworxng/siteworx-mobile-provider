import 'package:flutter/material.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/components/view_all_label_component.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../models/tax_list_response.dart';
import '../provider/payment/components/payment_info_component.dart';
import '../utils/colors.dart';
import '../utils/images.dart';

class PriceCommonWidget extends StatelessWidget {
  final BookingData bookingDetail;
  final ServiceData serviceDetail;
  final CouponData? couponData;
  final List<TaxData> taxes;
  final PackageData? bookingPackage;

  const PriceCommonWidget({
    Key? key,
    required this.bookingDetail,
    required this.serviceDetail,
    required this.taxes,
    required this.couponData,
    required this.bookingPackage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //price details
        ViewAllLabel(
          label: languages.lblPriceDetail,
          list: [],
        ),
        8.height,
        if (bookingPackage != null)
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationDefault(color: context.cardColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(languages.lblTotalAmount, style: secondaryTextStyle(size: 14)).expand(),
                    PriceWidget(price: bookingDetail.amount.validate(), color: primaryColor, size: 16),
                  ],
                ),
              ],
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(16),
            width: context.width(),
            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor, borderRadius: radius()),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.hintPrice, style: secondaryTextStyle(size: 14)).expand(),
                    PriceWidget(price: bookingDetail.amount.validate(), color: textPrimaryColorGlobal, isBoldText: true, size: 16).flexible(),
                  ],
                ),
                if (bookingDetail.type == SERVICE_TYPE_FIXED)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.lblSubTotal, style: secondaryTextStyle(size: 14)),
                          8.width,
                          Marquee(
                            child: Row(
                              children: [
                                PriceWidget(price: bookingDetail.amount.validate(), size: 12, isBoldText: false, color: appTextSecondaryColor),
                                Text(' * ${bookingDetail.quantity != 0 ? bookingDetail.quantity : 1}  = ', style: secondaryTextStyle()),
                                PriceWidget(price: bookingDetail.amount.validate(), size: 16, isBoldText: true, color: textPrimaryColorGlobal),
                              ],
                            ),
                          ).flexible(flex: 2),
                        ],
                      ),
                    ],
                  ),
                if (taxes.isNotEmpty) Divider(height: 26, color: context.dividerColor),
                if (taxes.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages.lblTax, style: secondaryTextStyle(size: 14)).expand(),
                      PriceWidget(price: serviceDetail.taxAmount.validate(), color: Colors.red, isBoldText: true, size: 16).flexible(),
                    ],
                  ),
                if (serviceDetail.discountPrice.validate() != 0 && serviceDetail.discount.validate() != 0)
                  Column(
                    children: [
                      Divider(height: 26, color: context.dividerColor),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: languages.hintDiscount, style: secondaryTextStyle(size: 14)),
                                TextSpan(
                                  text: " (${serviceDetail.discount.validate()}% ${languages.lblOff.toLowerCase()}) ",
                                  style: boldTextStyle(color: Colors.green),
                                ),
                              ],
                            ),
                          ).expand(),
                          PriceWidget(
                            price: serviceDetail.discountPrice.validate(),
                            size: 16,
                            color: Colors.green,
                            isBoldText: true,
                            isDiscountedPrice: true,
                          ).flexible(),
                        ],
                      ),
                    ],
                  ),
                if (couponData != null) Divider(height: 26, color: context.dividerColor),
                if (couponData != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(languages.lblCoupon, style: secondaryTextStyle(size: 14)),
                          Text(" (${couponData!.code})", style: secondaryTextStyle(size: 14, color: primaryColor)),
                        ],
                      ),
                      PriceWidget(
                        price: serviceDetail.couponDiscountAmount.validate(),
                        size: 16,
                        color: Colors.green,
                        isBoldText: true,
                      ).flexible(),
                    ],
                  ),
                if (bookingDetail.extraCharges.validate().isNotEmpty) Divider(height: 26, color: context.dividerColor),
                if (bookingDetail.extraCharges.validate().isNotEmpty)
                  Row(
                    children: [
                      Text(languages.lblTotalCharges, style: secondaryTextStyle(size: 14)).expand(),
                      PriceWidget(price: bookingDetail.extraCharges.sumByDouble((e) => e.total.validate()), color: textPrimaryColorGlobal, size: 16),
                    ],
                  ),
                Divider(height: 26, color: context.dividerColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextIcon(
                      text: '${languages.lblTotalAmount}',
                      textStyle: secondaryTextStyle(size: 14),
                      edgeInsets: EdgeInsets.zero,
                      suffix: bookingDetail.extraCharges.validate().isNotEmpty ? ic_info.iconImage(size: 16).withTooltip(msg: languages.withExtraCharge) : Offstage(),
                      expandedText: true,
                      maxLine: 2,
                    ).expand(flex: 2),
                    Marquee(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          16.width,
                          if (bookingDetail.isHourlyService)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text('('),
                                PriceWidget(price: bookingDetail.price.validate(), color: appTextSecondaryColor, size: 12, isBoldText: false),
                                Text('/${languages.lblHr})', style: secondaryTextStyle()),
                              ],
                            ),
                          8.width,
                          PriceWidget(price: getTotalValue, color: primaryColor, size: 16),
                        ],
                      ),
                    ).flexible(flex: 3),
                  ],
                ),
                if (serviceDetail.isAdvancePayment) Divider(height: 26, color: context.dividerColor),
                if (serviceDetail.isAdvancePayment)
                  Row(
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: languages.advancePayment, style: secondaryTextStyle(size: 14)),
                            TextSpan(
                              text: " (${serviceDetail.advancePaymentPercentage.validate().toString()}%)  ",
                              style: boldTextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ).expand(),
                      PriceWidget(price: getAdvancePaymentAmount, color: primaryColor, size: 18),
                    ],
                  ),
                if (serviceDetail.isAdvancePayment) Divider(height: 16, color: context.dividerColor),
                if (serviceDetail.isAdvancePayment)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextIcon(
                            text: '${languages.remainingAmount}',
                            textStyle: secondaryTextStyle(size: 14),
                            edgeInsets: EdgeInsets.zero,
                            suffix: ic_info.iconImage(size: 16).withTooltip(msg: languages.withExtraAndAdvanceCharge),
                            expandedText: true,
                            maxLine: 3,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (_) {
                                  return PaymentInfoComponent(bookingDetail.id!);
                                },
                              );
                            },
                          ).expand(),
                          8.width,
                          bookingDetail.status == BookingStatusKeys.complete && bookingDetail.paymentStatus == PAID
                              ? PriceWidget(price: 0, color: primaryColor, size: 16)
                              : PriceWidget(price: getRemainingAmount, color: primaryColor, size: 16),
                        ],
                      ),
                    ],
                  ),
                if (bookingDetail.type == SERVICE_TYPE_HOURLY && bookingDetail.status == BookingStatusKeys.complete)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      children: [
                        6.height,
                        Text(
                          "${languages.lblOnBasisOf} ${calculateTimer(bookingDetail.durationDiff.validate().toInt())} ${getMinHour(durationDiff: bookingDetail.durationDiff.validate())}",
                          style: secondaryTextStyle(),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }

  num get getAdvancePaymentAmount {
    if (bookingDetail.paidAmount.validate() != 0) {
      return bookingDetail.paidAmount!;
    } else {
      return serviceDetail.totalAmount.validate() * serviceDetail.advancePaymentPercentage.validate() / 100;
    }
  }

  num get getRemainingAmount {
    return serviceDetail.totalAmount! - getAdvancePaymentAmount;
  }

  num get getTotalValue {
    num totalAmount = calculateTotalAmount(
      serviceDiscountPercent: serviceDetail.discount.validate(),
      qty: bookingDetail.quantity.validate(value: 1).toInt(),
      detail: serviceDetail,
      servicePrice: bookingDetail.amount.validate(),
      taxes: taxes,
      couponData: couponData,
      extraCharges: bookingDetail.extraCharges.validate(),
    );

    if (bookingDetail.isHourlyService && bookingDetail.status == BookingStatusKeys.complete) {
      return calculateTotalAmount(
        serviceDiscountPercent: serviceDetail.discount.validate(),
        qty: bookingDetail.quantity.validate(value: 1).toInt(),
        detail: serviceDetail,
        servicePrice: getHourlyPrice(
          price: bookingDetail.amount.validate(),
          secTime: bookingDetail.durationDiff.validate().toInt(),
          date: bookingDetail.date.validate(),
        ),
        taxes: taxes,
        couponData: couponData,
        extraCharges: bookingDetail.extraCharges.validate(),
      );
    }

    return totalAmount;
  }

  String getMinHour({required String durationDiff}) {
    String totalTime = calculateTimer(durationDiff.toInt());
    List<String> totalHours = totalTime.split(":");
    if (totalHours.first == "00") {
      return languages.min;
    } else {
      return languages.hour;
    }
  }
}
