import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/payment_list_reasponse.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/fragments/shimmer/provider_payment_shimmer.dart';
import 'package:provider/screens/booking_detail_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class ProviderPaymentFragment extends StatefulWidget {
  const ProviderPaymentFragment({Key? key}) : super(key: key);

  @override
  State<ProviderPaymentFragment> createState() => _ProviderPaymentFragmentState();
}

class _ProviderPaymentFragmentState extends State<ProviderPaymentFragment> {
  List<PaymentData> list = [];
  Future<List<PaymentData>>? future;

  UniqueKey keyForStatus = UniqueKey();

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getPaymentAPI(page, list, (p0) {
      isLastPage = p0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SnapHelperWidget<List<PaymentData>>(
          initialData: cachedPaymentList,
          future: future,
          loadingWidget: ProviderPaymentShimmer(),
          onSuccess: (list) {
            return AnimatedListView(
              itemCount: list.length,
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              physics: AlwaysScrollableScrollPhysics(),
              listAnimationType: ListAnimationType.FadeIn,
              fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
              onSwipeRefresh: () async {
                page = 1;

                init();
                setState(() {});

                return await 2.seconds.delay;
              },
              onNextPage: () {
                if (!isLastPage) {
                  page++;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                }
              },
              itemBuilder: (p0, index) {
                PaymentData data = list[index];

                return GestureDetector(
                  onTap: () {
                    BookingDetailScreen(bookingId: data.bookingId).launch(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.scaffoldBackgroundColor,
                      border: Border.all(color: context.dividerColor, width: 1.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: boxDecorationWithRoundedCorners(
                            backgroundColor: primaryColor.withOpacity(0.2),
                            borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                          ),
                          width: context.width(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data.customerName.validate(), style: boldTextStyle(size: 12)).flexible(),
                              Text('#' + data.bookingId.validate().toString(), style: boldTextStyle(color: primaryColor, size: 12)),
                            ],
                          ),
                        ),
                        4.height,
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(languages.lblPaymentID, style: secondaryTextStyle(size: 12)),
                                Text("#" + data.id.validate().toString(), style: boldTextStyle(size: 12)),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Divider(thickness: 0.9, color: context.dividerColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(languages.paymentStatus, style: secondaryTextStyle(size: 12)),
                                Text(
                                  getPaymentStatusText(data.paymentStatus.validate(value: languages.pending), data.paymentMethod),
                                  style: boldTextStyle(size: 12),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Divider(thickness: 0.9, color: context.dividerColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(languages.paymentMethod, style: secondaryTextStyle(size: 12)),
                                Text(
                                  (data.paymentMethod.validate().isNotEmpty ? data.paymentMethod.validate() : languages.notAvailable).capitalizeFirstLetter(),
                                  style: boldTextStyle(size: 12),
                                ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                            Divider(thickness: 0.9, color: context.dividerColor),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(languages.lblAmount, style: secondaryTextStyle(size: 12)),
                                if (data.isPackageBooking)
                                  PriceWidget(
                                    price: data.packageData!.price.validate(),
                                    color: primaryColor,
                                    size: 12,
                                    isBoldText: true,
                                  )
                                else
                                  PriceWidget(
                                    price: calculateTotalAmount(
                                      servicePrice: data.price.validate(),
                                      qty: data.quantity.validate(),
                                      couponData: data.couponData != null ? data.couponData : null,
                                      taxes: data.taxes.validate(),
                                      serviceDiscountPercent: data.discount.validate(),
                                      extraCharges: data.extraCharges,
                                    ),
                                    color: primaryColor,
                                    size: 12,
                                    isBoldText: true,
                                  ),
                              ],
                            ).paddingSymmetric(vertical: 4),
                          ],
                        ).paddingSymmetric(horizontal: 16, vertical: 10),
                        // 8.height,
                      ],
                    ),
                  ),
                );
              },
              emptyWidget: NoDataWidget(
                title: languages.lblNoPayments,
                imageWidget: EmptyStateWidget(),
              ),
            );
          },
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              imageWidget: ErrorStateWidget(),
              retryText: languages.reload,
              onRetry: () {
                keyForStatus = UniqueKey();
                page = 1;
                appStore.setLoading(true);

                init();
                setState(() {});
              },
            );
          },
        ),
        Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
      ],
    );
  }
}
