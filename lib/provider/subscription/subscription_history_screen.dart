import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/subscription/components/subscription_widget.dart';
import 'package:provider/provider/subscription/shimmer/subscription_shimmer.dart';
import 'package:provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';

class SubscriptionHistoryScreen extends StatefulWidget {
  @override
  _SubscriptionHistoryScreenState createState() => _SubscriptionHistoryScreenState();
}

class _SubscriptionHistoryScreenState extends State<SubscriptionHistoryScreen> {
  Future<List<ProviderSubscriptionModel>>? future;
  List<ProviderSubscriptionModel> subscriptionsList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getSubscriptionHistory(
      page: page,
      providerSubscriptionList: subscriptionsList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblSubscriptionHistory, backWidget: BackWidget(), elevation: 0, color: primaryColor, textColor: Colors.white),
      body: Stack(
        children: [
          SnapHelperWidget<List<ProviderSubscriptionModel>>(
            future: future,
            loadingWidget: SubscriptionShimmer(),
            onSuccess: (snap) {
              if (snap.isEmpty)
                return NoDataWidget(
                  title: languages.noSubscriptionFound,
                  subTitle: languages.noSubscriptionSubTitle,
                  imageWidget: EmptyStateWidget(),
                );

              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                itemCount: snap.length,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
                disposeScrollController: false,
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                itemBuilder: (BuildContext context, index) {
                  return SubscriptionWidget(snap[index]);
                },
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
              );
            },
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
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
