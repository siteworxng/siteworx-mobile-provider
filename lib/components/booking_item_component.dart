import 'package:flutter/material.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/components/assign_handyman_screen.dart';
import 'package:provider/provider/components/booking_summary_dialog.dart';
import 'package:provider/screens/booking_detail_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/color_extension.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class BookingItemComponent extends StatefulWidget {
  final String? status;
  final BookingData bookingData;
  final int? index;
  final bool showDescription;

  BookingItemComponent({this.status, required this.bookingData, this.index, this.showDescription = true});

  @override
  BookingItemComponentState createState() => BookingItemComponentState();
}

class BookingItemComponentState extends State<BookingItemComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  String buildTimeWidget({required BookingData bookingDetail}) {
    if (bookingDetail.bookingSlot == null) {
      return formatDate(bookingDetail.date.validate(), format: DATE_FORMAT_3);
    }
    return TimeOfDay(hour: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").first.toInt(), minute: bookingDetail.bookingSlot.validate().splitBefore(':').split(":").last.toInt()).format(context);
  }

  Future<void> updateBooking(BookingData booking, String updatedStatus, int index) async {
    appStore.setLoading(true);
    Map request = {
      CommonKeys.id: booking.id,
      BookingUpdateKeys.status: updatedStatus,
      BookingUpdateKeys.paymentStatus: booking.isAdvancePaymentDone ? SERVICE_PAYMENT_STATUS_ADVANCE_PAID : booking.paymentStatus.validate(),
    };
    await bookingUpdate(request).then((res) async {
      LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
      setState(() {});
      // appStore.setLoading(false);
    }).catchError((e) {
      // appStore.setLoading(false);
    });
  }

  Future<void> confirmationRequestDialog(BuildContext context, int index, String status) async {
    showConfirmDialogCustom(
      context,
      title: languages.confirmationRequestTxt,
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      primaryColor: status == BookingStatusKeys.rejected ? Colors.redAccent : primaryColor,
      onAccept: (context) async {
        updateBooking(widget.bookingData, status, index);
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 16),
      width: context.width(),
      decoration: boxDecorationWithRoundedCorners(
        borderRadius: radius(),
        backgroundColor: context.scaffoldBackgroundColor,
        border: Border.all(color: context.dividerColor, width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.bookingData.isPackageBooking && widget.bookingData.bookingPackage != null)
                CachedImageWidget(
                  url: widget.bookingData.bookingPackage!.imageAttachments.validate().isNotEmpty ? widget.bookingData.bookingPackage!.imageAttachments.validate().first.validate() : "",
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  radius: defaultRadius,
                )
              else
                CachedImageWidget(
                  url: widget.bookingData.imageAttachments.validate().isNotEmpty ? widget.bookingData.imageAttachments!.first.validate() : '',
                  fit: BoxFit.cover,
                  width: 80,
                  height: 80,
                  radius: defaultRadius,
                ),
              16.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.bookingData.status.validate().getPaymentStatusBackgroundColor.withOpacity(0.1),
                              borderRadius: radius(8),
                            ),
                            child: Marquee(
                              child: Text(
                                widget.bookingData.status.validate().toBookingStatus(),
                                style: boldTextStyle(color: widget.bookingData.status.validate().getPaymentStatusBackgroundColor, size: 12),
                              ),
                            ),
                          ).flexible(),
                          if (widget.bookingData.isPostJob)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                languages.postJob,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                          if (widget.bookingData.isPackageBooking)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              margin: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                color: context.primaryColor.withOpacity(0.1),
                                borderRadius: radius(8),
                              ),
                              child: Text(
                                languages.package,
                                style: boldTextStyle(color: context.primaryColor, size: 12),
                              ),
                            ),
                        ],
                      ).flexible(),
                      Text(
                        '#${widget.bookingData.id.validate()}',
                        style: boldTextStyle(color: context.primaryColor),
                      ),
                    ],
                  ),
                  8.height,
                  Marquee(
                    child: Text(
                      widget.bookingData.isPackageBooking ? '${widget.bookingData.bookingPackage!.name.validate()}' : '${widget.bookingData.serviceName.validate()}',
                      style: boldTextStyle(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  8.height,
                  if (widget.bookingData.bookingPackage != null)
                    PriceWidget(
                      price: widget.bookingData.amount.validate(),
                      color: primaryColor,
                      size: 16,
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.bookingData.bookingType == BOOKING_TYPE_SERVICE)
                          PriceWidget(
                            isFreeService: widget.bookingData.isFreeService,
                            price: widget.bookingData.isHourlyService
                                ? widget.bookingData.totalAmountWithExtraCharges.validate()
                                : calculateTotalAmount(
                                    servicePrice: widget.bookingData.amount.validate(),
                                    qty: widget.bookingData.quantity.validate(),
                                    couponData: widget.bookingData.couponData != null ? widget.bookingData.couponData : null,
                                    taxes: widget.bookingData.taxes.validate(),
                                    serviceDiscountPercent: widget.bookingData.discount.validate(),
                                    extraCharges: widget.bookingData.extraCharges,
                                  ),
                            color: primaryColor,
                            //isHourlyService: widget.bookingData.isHourlyService,
                            size: 16,
                          )
                        else
                          PriceWidget(price: widget.bookingData.totalAmount.validate()),
                        if (widget.bookingData.isHourlyService) Text(languages.lblHourly, style: secondaryTextStyle()).paddingSymmetric(horizontal: 4),
                        if (!widget.bookingData.isHourlyService) 4.width,
                        if (widget.bookingData.discount != null && widget.bookingData.discount != 0)
                          Row(
                            children: [
                              Text('(${widget.bookingData.discount.validate()}%', style: boldTextStyle(size: 12, color: Colors.green)),
                              Text(' ${languages.lblOff})', style: boldTextStyle(size: 12, color: Colors.green)),
                            ],
                          ),
                      ],
                    ),
                ],
              ).expand(),
            ],
          ).paddingAll(8),
          if (widget.showDescription)
            Container(
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              margin: EdgeInsets.all(8),
              //decoration: cardDecoration(context),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(languages.lblAddress, style: secondaryTextStyle()),
                      8.width,
                      Marquee(
                        child: Text(
                          widget.bookingData.address != null ? widget.bookingData.address.validate() : languages.notAvailable,
                          style: boldTextStyle(size: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ).flexible(),
                    ],
                  ).paddingAll(8),
                  Divider(height: 0, color: context.dividerColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${languages.lblDate} & ${languages.lblTime}', style: secondaryTextStyle()),
                      8.width,
                      Text(
                        "${formatDate(widget.bookingData.date.validate(), format: DATE_FORMAT_2)} At ${buildTimeWidget(bookingDetail: widget.bookingData)}",
                        style: boldTextStyle(size: 12),
                        maxLines: 2,
                        textAlign: TextAlign.right,
                      ).expand(),
                    ],
                  ).paddingAll(8),
                  if (widget.bookingData.customerName.validate().isNotEmpty)
                    Column(
                      children: [
                        Divider(height: 0, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(languages.customer, style: secondaryTextStyle()),
                            8.width,
                            Text(widget.bookingData.customerName.validate(), style: boldTextStyle(size: 12), textAlign: TextAlign.right).flexible(),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  if (widget.bookingData.handyman.validate().isNotEmpty && isUserTypeProvider)
                    Column(
                      children: [
                        Divider(height: 0, color: context.dividerColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages.handyman, style: secondaryTextStyle()),
                            Text(widget.bookingData.handyman.validate().first.handyman!.displayName.validate(), style: boldTextStyle(size: 12)).flexible(),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  if (widget.bookingData.paymentStatus != null && widget.bookingData.status == BookingStatusKeys.complete)
                    Column(
                      children: [
                        Divider(height: 0, color: context.dividerColor),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(languages.paymentStatus, style: secondaryTextStyle()).expand(),
                            Text(
                              buildPaymentStatusWithMethod(widget.bookingData.paymentStatus.validate(), widget.bookingData.paymentMethod.validate().capitalizeFirstLetter()),
                              style: boldTextStyle(size: 12, color: (widget.bookingData.paymentStatus.validate() == PAID || widget.bookingData.paymentStatus.validate() == PENDING_BY_ADMINs) ? Colors.green : Colors.red),
                            ),
                          ],
                        ).paddingAll(8),
                      ],
                    ),
                  if (isUserTypeProvider && widget.bookingData.status == BookingStatusKeys.pending || (isUserTypeHandyman && widget.bookingData.status == BookingStatusKeys.accept))
                    Row(
                      children: [
                        if (isUserTypeProvider)
                          AppButton(
                            child: Text(languages.accept, style: boldTextStyle(color: white)),
                            width: context.width(),
                            color: primaryColor,
                            elevation: 0,
                            onTap: () async {
                              await showInDialog(
                                context,
                                backgroundColor: Colors.transparent,
                                builder: (_) {
                                  return BookingSummaryDialog(
                                    bookingDataList: widget.bookingData,
                                    bookingId: widget.bookingData.id,
                                  );
                                },
                                shape: RoundedRectangleBorder(borderRadius: radius()),
                                contentPadding: EdgeInsets.zero,
                              );
                            },
                          ).expand(),
                        12.width,
                        AppButton(
                          child: Text(languages.decline, style: boldTextStyle()),
                          width: context.width(),
                          elevation: 0,
                          color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white,
                          onTap: () {
                            if (isUserTypeProvider) {
                              confirmationRequestDialog(context, widget.index!, BookingStatusKeys.rejected);
                            } else {
                              confirmationRequestDialog(context, widget.index!, BookingStatusKeys.pending);
                            }
                          },
                        ).expand(),
                      ],
                    ).paddingOnly(bottom: 8, left: 8, right: 8, top: 16),
                  if (isUserTypeProvider && widget.bookingData.handyman!.isEmpty && widget.bookingData.status == BookingStatusKeys.accept)
                    Column(
                      children: [
                        8.height,
                        AppButton(
                          width: context.width(),
                          child: Text(languages.lblAssign, style: boldTextStyle(color: white)),
                          color: primaryColor,
                          elevation: 0,
                          onTap: () {
                            AssignHandymanScreen(
                              bookingId: widget.bookingData.id,
                              serviceAddressId: widget.bookingData.bookingAddressId,
                              onUpdate: () {
                                setState(() {});
                                LiveStream().emit(LIVESTREAM_UPDATE_BOOKINGS);
                              },
                            ).launch(context);
                          },
                        ),
                      ],
                    ).paddingAll(8),
                ],
              ).paddingAll(8),
            ),
        ],
      ), //booking card change
    ).onTap(
      () async {
        BookingDetailScreen(bookingId: widget.bookingData.id).launch(context);
      },
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
