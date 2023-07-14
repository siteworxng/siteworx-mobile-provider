import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/handyman/component/handyman_review_component.dart';
import 'package:provider/handyman/component/handyman_total_component.dart';
import 'package:provider/screens/cash_management/component/today_cash_component.dart';
import 'package:provider/handyman/shimmer/handyman_dashboard_shimmer.dart';
import 'package:provider/main.dart';
import 'package:provider/models/handyman_dashboard_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/components/chart_component.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/app_widgets.dart';
import '../../../components/empty_error_state_widget.dart';
import '../../../provider/components/upcoming_booking_component.dart';

class HandymanHomeFragment extends StatefulWidget {
  const HandymanHomeFragment({Key? key}) : super(key: key);

  @override
  _HandymanHomeFragmentState createState() => _HandymanHomeFragmentState();
}

class _HandymanHomeFragmentState extends State<HandymanHomeFragment> {
  int page = 1;

  late Future<HandymanDashBoardResponse> future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = handymanDashboard();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<HandymanDashBoardResponse>(
            initialData: cachedHandymanDashboardResponse,
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                return AnimatedScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 16, top: 16),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 500.milliseconds),
                  children: [
                    Text("${languages.lblHello}, ${appStore.userFullName}", style: boldTextStyle(size: 16)).paddingLeft(16),
                    8.height,
                    Text(languages.lblWelcomeBack, style: secondaryTextStyle(size: 14)).paddingLeft(16),
                    16.height,
                    TodayCashComponent(todayCashAmount: snap.data!.todayCashAmount.validate()),
                    8.height,
                    HandymanTotalComponent(snap: snap.data!),
                    8.height,
                    ChartComponent(),
                    UpcomingBookingComponent(bookingData: snap.data!.upcomingBookings.validate()),
                    16.height,
                    HandymanReviewComponent(reviews: snap.data!.handymanReviews.validate()),
                  ],
                  onSwipeRefresh: () async {
                    page = 1;
                    appStore.setLoading(true);

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                );
              }
              return snapWidgetHelper(
                snap,
                loadingWidget: HandymanDashboardShimmer(),
                errorBuilder: (error) {
                  return NoDataWidget(
                    title: error,
                    imageWidget: ErrorStateWidget(),
                    retryText: languages.reload,
                    onRetry: () {
                      page = 1;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    },
                  );
                },
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
