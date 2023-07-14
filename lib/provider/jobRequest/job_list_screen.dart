import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/jobRequest/shimmer/job_request_shimmer.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';
import 'components/job_item_widget.dart';
import 'models/post_job_data.dart';

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  late Future<List<PostJobData>> future;
  List<PostJobData> myPostJobList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getPostJobList(
      page,
      postJobList: myPostJobList,
      lastPageCallback: (val) => isLastPage = val,
    );
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.jobRequestList,
      body: Stack(
        children: [
          SnapHelperWidget<List<PostJobData>>(
            future: future,
            onSuccess: (data) {
              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                padding: EdgeInsets.all(16),
                itemCount: data.validate().length,
                shrinkWrap: true,
                emptyWidget: NoDataWidget(
                  title: languages.noDataFound,
                  imageWidget: EmptyStateWidget(),
                ),
                itemBuilder: (_, i) => JobItemWidget(data: data[i]),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
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
            loadingWidget: JobPostRequestShimmer(),
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
