import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/booking_item_component.dart';
import 'package:provider/components/booking_status_dropdown.dart';
import 'package:provider/fragments/shimmer/booking_shimmer.dart';
import 'package:provider/main.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/models/booking_status_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/empty_error_state_widget.dart';

// ignore: must_be_immutable
class BookingFragment extends StatefulWidget {
  String? statusType;

  BookingFragment({this.statusType});

  @override
  BookingFragmentState createState() => BookingFragmentState();
}

class BookingFragmentState extends State<BookingFragment> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  int page = 1;
  List<BookingData> bookings = [];

  String selectedValue = BOOKING_PAYMENT_STATUS_ALL;
  bool isLastPage = false;
  bool hasError = false;
  bool isApiCalled = false;

  Future<List<BookingData>>? future;
  UniqueKey keyForStatus = UniqueKey();

  @override
  void initState() {
    super.initState();
    LiveStream().on(LIVESTREAM_HANDY_BOARD, (index) {
      if (index is Map && index["index"] == 1) {
        selectedValue = BookingStatusKeys.accept;
        fetchAllBookingList();
        setState(() {});
      }
    });

    LiveStream().on(LIVESTREAM_HANDYMAN_ALL_BOOKING, (index) {
      if (index == 1) {
        selectedValue = '';
        fetchAllBookingList();
        setState(() {});
      }
    });

    LiveStream().on(LIVESTREAM_UPDATE_BOOKINGS, (p0) {
      page = 1;
      fetchAllBookingList();
      setState(() {});
    });

    init();
  }

  void init() async {
    if (widget.statusType.validate().isNotEmpty) {
      selectedValue = widget.statusType.validate();
    }

    fetchAllBookingList(loading: true);
  }

  Future<void> fetchAllBookingList({bool loading = true}) async {
    future = getBookingList(page, status: selectedValue, bookings: bookings, lastPageCallback: (b) {
      isLastPage = b;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_BOOKINGS);
    LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    // LiveStream().dispose(LIVESTREAM_HANDYMAN_ALL_BOOKING);
    // LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SnapHelperWidget<List<BookingData>>(
            initialData: cachedBookingList,
            future: future,
            loadingWidget: BookingShimmer(),
            onSuccess: (list) {
              return AnimatedListView(
                controller: scrollController,
                onSwipeRefresh: () async {
                  page = 1;
                  await fetchAllBookingList(loading: false);
                  setState(() {});
                  return await 2.seconds.delay;
                },
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: list.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                emptyWidget: NoDataWidget(
                  title: languages.noBookingTitle,
                  subTitle: languages.noBookingSubTitle,
                  imageWidget: EmptyStateWidget(),
                ),
                itemBuilder: (_, index) => BookingItemComponent(bookingData: list[index], index: index),
                //disposeScrollController: false,
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    fetchAllBookingList();
                    setState(() {});
                  }
                },
              ).paddingOnly(left: 0, right: 0, bottom: 0, top: 76);
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                retryText: languages.reload,
                imageWidget: ErrorStateWidget(),
                onRetry: () {
                  keyForStatus = UniqueKey();
                  appStore.setLoading(true);
                  page = 1;

                  fetchAllBookingList();
                  setState(() {});
                },
              );
            },
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 16,
            child: BookingStatusDropdown(
              isValidate: false,
              statusType: selectedValue,
              key: keyForStatus,
              onValueChanged: (BookingStatusResponse value) {
                page = 1;
                appStore.setLoading(true);

                selectedValue = value.value.validate(value: BOOKING_PAYMENT_STATUS_ALL);
                fetchAllBookingList(loading: true);
                setState(() {});

                if (bookings.isNotEmpty) {
                  scrollController.animateTo(0, duration: 1.seconds, curve: Curves.easeOutQuart);
                } else {
                  scrollController = ScrollController();
                }
              },
            ),
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
