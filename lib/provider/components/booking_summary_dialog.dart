import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingSummaryDialog extends StatefulWidget {
  final BookingData? bookingDataList;
  final int? bookingId;
  final Function? onUpdate;

  BookingSummaryDialog({this.bookingDataList, this.onUpdate, this.bookingId});

  @override
  _BookingSummaryDialogState createState() => _BookingSummaryDialogState();
}

class _BookingSummaryDialogState extends State<BookingSummaryDialog> {
  void updateBooking() {
    var request = {
      CommonKeys.id: widget.bookingId.validate(),
      BookingUpdateKeys.status: BookingStatusKeys.accept,
      BookingUpdateKeys.paymentStatus: widget.bookingDataList!.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : widget.bookingDataList!.paymentStatus.validate(),
    };
    appStore.setLoading(true);

    bookingUpdate(request).then((res) async {
      finish(context, true);

      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);

      appStore.setLoading(false);
    }).catchError((e) {
      if (mounted) {
        finish(context);
      }
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Widget buildTimeWidget({required BookingData bookingDetail}) {
    if (bookingDetail.bookingSlot == null) {
      return Text(formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_3), style: boldTextStyle(size: 14));
    }
    return Text(
        TimeOfDay(hour: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").first.toInt(), minute: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").last.toInt())
            .format(context),
        style: boldTextStyle(size: 14));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.8,
      width: context.width(),
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            decoration: boxDecorationDefault(
              color: context.cardColor,
              borderRadius: radius(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    backgroundColor: primaryColor,
                  ),
                  padding: EdgeInsets.only(left: 16, right: 8, bottom: 8, top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages.lblBookingSummary, style: boldTextStyle(color: white, size: 18)),
                      IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: Icon(Icons.close, size: 22, color: white),
                      ),
                    ],
                  ),
                ),
                AnimatedScrollView(
                  padding: EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 74),
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 1.seconds),
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.bookingDataList!.isPackageBooking && widget.bookingDataList!.bookingPackage != null)
                      Column(
                        children: [
                          CachedImageWidget(
                            url: widget.bookingDataList!.bookingPackage!.imageAttachments.validate().isNotEmpty
                                ? widget.bookingDataList!.bookingPackage!.imageAttachments.validate().first.validate()
                                : "",
                            height: 150,
                            width: context.width(),
                            fit: BoxFit.cover,
                            radius: defaultRadius,
                          ),
                          24.height,
                        ],
                      )
                    else
                      Column(
                        children: [
                          CachedImageWidget(
                            url: widget.bookingDataList!.imageAttachments.validate().isNotEmpty ? widget.bookingDataList!.imageAttachments!.first.validate() : '',
                            fit: BoxFit.cover,
                            height: 150,
                            width: context.width(),
                            radius: defaultRadius,
                          ),
                          24.height,
                        ],
                      ),
                    Text(widget.bookingDataList!.isPackageBooking ? widget.bookingDataList!.bookingPackage!.name.validate() : widget.bookingDataList!.serviceName.validate(),
                        style: boldTextStyle(size: 18)),
                    8.height,
                    if (widget.bookingDataList!.bookingPackage != null)
                      PriceWidget(
                        price: widget.bookingDataList!.amount.validate(),
                        color: primaryColor,
                        size: 18,
                      )
                    else
                      Row(
                        children: [
                          PriceWidget(
                            price: calculateTotalAmount(
                              servicePrice: widget.bookingDataList!.price.validate(),
                              qty: widget.bookingDataList!.quantity.validate(),
                              couponData: widget.bookingDataList!.couponData != null ? widget.bookingDataList!.couponData : null,
                              taxes: widget.bookingDataList!.taxes.validate(),
                              serviceDiscountPercent: widget.bookingDataList!.discount.validate(),
                              extraCharges: widget.bookingDataList!.extraCharges,
                            ),
                            isHourlyService: widget.bookingDataList!.isHourlyService,
                            color: context.primaryColor,
                            size: 18,
                            isFreeService: widget.bookingDataList!.isFreeService,
                          ),
                          8.width,
                          if (widget.bookingDataList!.discount.validate() != 0)
                            Row(
                              children: [
                                Text('(${widget.bookingDataList!.discount}%', style: boldTextStyle(size: 14, color: Colors.green)),
                                Text(' ${languages.lblOff})', style: boldTextStyle(size: 14, color: Colors.green)),
                              ],
                            ),
                        ],
                      ),
                    24.height,
                    if (widget.bookingDataList!.date.validate().isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.lblDate, style: secondaryTextStyle(size: 14)),
                          Text(
                            formatDate(widget.bookingDataList!.date.validate(), format: DATE_FORMAT_2),
                            style: boldTextStyle(size: 14),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    8.height,
                    Divider(thickness: 1, color: context.dividerColor),
                    8.height,
                    if (widget.bookingDataList!.date.validate().isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.lblTime, style: secondaryTextStyle(size: 14)),
                          buildTimeWidget(bookingDetail: widget.bookingDataList!),
                        ],
                      ),
                    8.height,
                    Divider(thickness: 1, color: context.dividerColor),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages.lblAddress, style: secondaryTextStyle(size: 14)).expand(),
                        Text(
                          widget.bookingDataList!.address.validate(),
                          style: boldTextStyle(size: 14),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ).expand(),
                      ],
                    ),
                    8.height,
                    Divider(thickness: 1, color: context.dividerColor),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.lblServiceStatus, style: secondaryTextStyle(size: 14)),
                        Text(widget.bookingDataList!.status.validate().toBookingStatus(), style: boldTextStyle(size: 14)),
                      ],
                    ),
                    8.height,
                    Divider(thickness: 1, color: context.dividerColor),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages.quantity, style: secondaryTextStyle(size: 14)),
                        Text(
                          widget.bookingDataList!.quantity.validate().toString().isNotEmpty ? '*' + widget.bookingDataList!.quantity.validate().toString() : languages.notAvailable,
                          style: boldTextStyle(size: 14),
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ).expand(),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: AppButton(
              color: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              onTap: () {
                updateBooking();
              },
              child: Text(languages.confirm, style: boldTextStyle(color: white)),
            ),
          ),
          Observer(
            builder: (context) {
              return LoaderWidget().withSize(height: 60, width: 60).center().visible(appStore.isLoading);
            },
          )
        ],
      ),
    );
  }
}
