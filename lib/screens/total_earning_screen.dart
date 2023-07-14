import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/total_earning_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/total_earning_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/base_scaffold_widget.dart';
import '../components/empty_error_state_widget.dart';

class TotalEarningScreen extends StatefulWidget {
  const TotalEarningScreen({Key? key}) : super(key: key);

  @override
  _TotalEarningScreenState createState() => _TotalEarningScreenState();
}

class _TotalEarningScreenState extends State<TotalEarningScreen> {
  List<TotalData> totalEarning = [];
  Future<List<TotalData>>? future;

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getTotalEarningList(page, totalEarning, (p0) {
      isLastPage = p0;
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblEarningList,
      body: Stack(
        children: [
          SnapHelperWidget<List<TotalData>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (totalEarning) {
              return AnimatedListView(
                itemCount: totalEarning.length,
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
                  TotalData data = totalEarning[index];
                  return TotalEarningWidget(totalEarning: data);
                },
                emptyWidget: NoDataWidget(
                  title: languages.lblNoEarningFound,
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
