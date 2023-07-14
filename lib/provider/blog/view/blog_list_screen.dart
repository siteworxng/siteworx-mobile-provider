import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/provider/blog/blog_repository.dart';
import 'package:provider/provider/blog/component/blog_item_component.dart';
import 'package:provider/provider/blog/model/blog_response_model.dart';
import 'package:provider/provider/blog/shimmer/blog_shimmer.dart';
import 'package:provider/provider/blog/view/add_blog_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../components/empty_error_state_widget.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  Future<List<BlogData>>? future;

  List<BlogData> blogList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getBlogListAPI(
      blogData: blogList,
      page: page,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.blogs,
        color: context.primaryColor,
        textColor: white,
        backWidget: BackWidget(),
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.addBlog,
            onPressed: () async {
              bool? res;

              res = await AddBlogScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

              if (res ?? false) {
                appStore.setLoading(true);
                page = 1;
                init();
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<BlogData>>(
            future: future,
            loadingWidget: BlogShimmer(),
            onSuccess: (list) {
              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: list.length,
                emptyWidget: NoDataWidget(
                  title: languages.noBlogsFound,
                  imageWidget: EmptyStateWidget(),
                ),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                disposeScrollController: false,
                itemBuilder: (BuildContext context, index) {
                  BlogData data = list[index];

                  return BlogItemComponent(
                    blogData: data,
                    callBack: () {
                      page = 1;
                      init();
                      setState(() {});
                    },
                  );
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
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
