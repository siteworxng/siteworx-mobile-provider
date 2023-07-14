import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/handyman_add_update_screen.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/components/handyman_widget.dart';
import 'package:provider/provider/shimmer/handyman_list_shimmer.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../components/empty_error_state_widget.dart';

class HandymanListScreen extends StatefulWidget {
  @override
  HandymanListScreenState createState() => HandymanListScreenState();
}

class HandymanListScreenState extends State<HandymanListScreen> {
  Future<List<UserData>>? future;

  List<UserData> list = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init({bool isLoading = false, int page = 1}) async {
    future = getHandyman(
      page: page,
      providerId: appStore.userId,
      list: list,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );

    if (isLoading) {
      appStore.setLoading(true);
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appStore.isDarkMode ? blackColor : cardColor,
      appBar: appBarWidget(
        languages.lblAllHandyman,
        textColor: white,
        color: context.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              HandymanAddUpdateScreen(
                userType: USER_TYPE_HANDYMAN,
                onUpdate: () {
                  init(isLoading: true);
                },
              ).launch(context);
            },
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.lblAddHandyman,
          ),
        ],
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<UserData>>(
            future: future,
            loadingWidget: HandymanListShimmer(),
            onSuccess: (snap) {
              if (snap.isEmpty)
                return NoDataWidget(
                  title: languages.noHandymanYet,
                  imageWidget: EmptyStateWidget(),
                );

              return AnimatedScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                physics: AlwaysScrollableScrollPhysics(),
                onNextPage: () {
                  if (!isLastPage) {
                    init(isLoading: true, page: page++);
                  }
                },
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                children: [
                  AnimatedWrap(
                    spacing: 16,
                    runSpacing: 16,
                    itemCount: list.length,
                    listAnimationType: ListAnimationType.FadeIn,
                    fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                    scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                    itemBuilder: (context, index) {
                      return HandymanWidget(
                        data: list[index],
                        width: context.width() * 0.5 - 26,
                        onUpdate: () async {
                          init(isLoading: true);
                        },
                      );
                    },
                  ),
                ],
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: languages.reload,
                onRetry: () {
                  init(isLoading: true);
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
