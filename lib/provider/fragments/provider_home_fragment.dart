import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/main.dart';
import 'package:provider/models/dashboard_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/components/chart_component.dart';
import 'package:provider/provider/components/handyman_list_component.dart';
import 'package:provider/provider/components/handyman_recently_online_component.dart';
import 'package:provider/provider/components/job_list_component.dart';
import 'package:provider/provider/components/services_list_component.dart';
import 'package:provider/provider/components/total_component.dart';
import 'package:provider/provider/fragments/shimmer/provider_dashboard_shimmer.dart';
import 'package:provider/provider/subscription/pricing_plan_screen.dart';
import 'package:provider/screens/cash_management/component/today_cash_component.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import '../components/upcoming_booking_component.dart';

class ProviderHomeFragment extends StatefulWidget {
  @override
  _ProviderHomeFragmentState createState() => _ProviderHomeFragmentState();
}

class _ProviderHomeFragmentState extends State<ProviderHomeFragment> {
  int page = 1;

  int currentIndex = 0;

  late Future<DashboardResponse> future;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = providerDashboard();
  }

  Widget _buildHeaderWidget(DashboardResponse data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.height,
        Text("${languages.lblHello}, ${appStore.userFullName}", style: boldTextStyle(size: 16)).paddingLeft(16),
        8.height,
        Text(languages.lblWelcomeBack, style: secondaryTextStyle(size: 14)).paddingLeft(16),
        16.height,
      ],
    );
  }

  Widget planBanner(DashboardResponse data) {
    if (data.isPlanExpired.validate()) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: languages.lblPlanExpired,
        planSubtitle: languages.lblPlanSubTitle,
        planButtonTxt: languages.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.userNeverPurchasedPlan.validate()) {
      return subSubscriptionPlanWidget(
        planBgColor: appStore.isDarkMode ? context.cardColor : Colors.red.shade50,
        planTitle: languages.lblChooseYourPlan,
        planSubtitle: languages.lblRenewSubTitle,
        planButtonTxt: languages.btnTxtBuyNow,
        btnColor: Colors.red,
        onTap: () {
          PricingPlanScreen().launch(context);
        },
      );
    } else if (data.isPlanAboutToExpire.validate()) {
      int days = getRemainingPlanDays();

      if (days != 0 && days <= PLAN_REMAINING_DAYS) {
        return subSubscriptionPlanWidget(
          planBgColor: appStore.isDarkMode ? context.cardColor : Colors.orange.shade50,
          planTitle: languages.lblReminder,
          planSubtitle: languages.planAboutToExpire(days),
          planButtonTxt: languages.lblRenew,
          btnColor: Colors.orange,
          onTap: () {
            PricingPlanScreen().launch(context);
          },
        );
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
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
          FutureBuilder<DashboardResponse>(
            initialData: cachedProviderDashboardResponse,
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                return AnimatedScrollView(
                  padding: EdgeInsets.only(bottom: 16),
                  physics: AlwaysScrollableScrollPhysics(),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  children: [
                    if ((snap.data!.earningType == EARNING_TYPE_SUBSCRIPTION)) planBanner(snap.data!),
                    _buildHeaderWidget(snap.data!),
                    TodayCashComponent(todayCashAmount: snap.data!.todayCashAmount.validate()),
                    TotalComponent(snap: snap.data!),
                    ChartComponent(),
                    HandymanRecentlyOnlineComponent(images: snap.data!.onlineHandyman.validate()),
                    HandymanListComponent(list: snap.data!.handyman.validate()),
                    UpcomingBookingComponent(bookingData: snap.data!.upcomingBookings.validate()),
                    JobListComponent(list: snap.data!.myPostJobData.validate()).paddingOnly(left: 16, right: 16, top: 8),
                    ServiceListComponent(list: snap.data!.service.validate()),
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
                loadingWidget: ProviderDashboardShimmer(),
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
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
