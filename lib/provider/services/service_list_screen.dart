import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/components/service_widget.dart';
import 'package:provider/provider/services/add_services.dart';
import 'package:provider/provider/services/service_detail_screen.dart';
import 'package:provider/provider/services/shimmer/service_list_shimmer.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../utils/constant.dart';

class ServiceListScreen extends StatefulWidget {
  @override
  _ServiceListScreenState createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  TextEditingController searchList = TextEditingController();

  List<ServiceData> services = [];
  Future<List<ServiceData>>? future;

  int page = 1;

  bool changeListType = false;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getSearchList(page, search: searchList.text, perPage: 10, providerId: appStore.userId, services: services, lastPageCallback: (b) {
      isLastPage = b;
    });
  }

  void setPageToOne() {
    page = 1;
    appStore.setLoading(true);

    init();
    setState(() {});
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
      appBar: appBarWidget(
        languages.lblAllService,
        textColor: white,
        color: context.primaryColor,
        backWidget: BackWidget(),
        textSize: APP_BAR_TEXT_SIZE,
        actions: [
          IconButton(
            onPressed: () {
              changeListType = !changeListType;
              setState(() {});
            },
            icon: Image.asset(changeListType ? list : grid, height: 20, width: 20),
          ),
          IconButton(
            onPressed: () async {
              bool? res;

              res = await AddServices().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);

              if (res ?? false) {
                setPageToOne();
              }
            },
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.hintAddService,
          ),
        ],
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<ServiceData>>(
            future: future,
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: languages.reload,
                onRetry: () {
                  setPageToOne();
                },
              );
            },
            loadingWidget: ServiceListShimmer(width: changeListType ? context.width() : context.width() * 0.5 - 24),
            onSuccess: (list) {
              if (list.isEmpty) {
                return NoDataWidget(
                  title: languages.noServiceFound,
                  subTitle: languages.noServiceSubTitle,
                  imageWidget: EmptyStateWidget(),
                );
              }

              return AnimatedScrollView(
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
                    init();
                    setState(() {});
                  }
                },
                children: [
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: searchList,
                    onFieldSubmitted: (s) {
                      setPageToOne();
                    },
                    decoration: InputDecoration(
                      hintText: languages.lblSearchHere,
                      prefixIcon: Icon(Icons.search, color: context.iconColor, size: 20),
                      hintStyle: secondaryTextStyle(),
                      border: OutlineInputBorder(borderRadius: radius(8), borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                      filled: true,
                      contentPadding: EdgeInsets.all(16),
                      fillColor: appStore.isDarkMode ? cardDarkColor : cardColor,
                    ),
                  ).paddingOnly(left: 16, right: 16, top: 24, bottom: 8),
                  if (services.isNotEmpty)
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      child: AnimatedWrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        scaleConfiguration: ScaleConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
                        listAnimationType: ListAnimationType.FadeIn,
                        fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                        alignment: WrapAlignment.start,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return ServiceComponent(
                            data: services[index],
                            width: changeListType ? context.width() : context.width() * 0.5 - 24,
                          ).onTap(() async {
                            await ServiceDetailScreen(serviceId: services[index].id.validate()).launch(context).then((value) {
                              if (value != null) {
                                setPageToOne();
                              }
                            });
                          }, borderRadius: radius());
                        },
                      ),
                    ),
                ],
              );
            },
          ),
          Observer(builder: (context) => LoaderWidget().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
