import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/packages/add_package_screen.dart';
import 'package:provider/provider/packages/package_detail_screen.dart';
import 'package:provider/provider/packages/shimmer/package_list_shimmer.dart';
import 'package:provider/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';

class PackageListScreen extends StatefulWidget {
  @override
  _PackageListScreenState createState() => _PackageListScreenState();
}

class _PackageListScreenState extends State<PackageListScreen> {
  Future<List<PackageData>>? future;
  List<PackageData> packageList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();

    afterBuildCreated(() {
      setStatusBarColor(context.primaryColor);
    });
  }

  void init() async {
    future = getAllPackageList(
      packageData: packageList,
      page: page,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  // region Delete Package
  void removePackage({int? packageId}) {
    deletePackage(packageId.validate()).then((value) async {
      toast(value.message.validate());
      init();

      setState(() {});
      await 2.seconds.delay;
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  Future<void> confirmationDialog({required PackageData packageData}) async {
    showConfirmDialogCustom(
      context,
      title: '${languages.areYouSureWantToDeleteThe} ${packageData.name.validate()} ${languages.package}?',
      primaryColor: context.primaryColor,
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      onAccept: (context) async {
        ifNotTester(context, () {
          appStore.setLoading(true);
          removePackage(packageId: packageData.id.validate());
          setState(() {});
        });
      },
    );
  }

  // endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.packages,
      actions: [
        IconButton(
          icon: Icon(Icons.add, size: 28, color: white),
          onPressed: () async {
            bool? res = await AddPackageScreen().launch(context);

            if (res ?? false) {
              appStore.setLoading(true);
              init();

              setState(() {});
            }
          },
        ),
      ],
      body: Stack(
        children: [
          SnapHelperWidget<List<PackageData>>(
            future: future,
            loadingWidget: PackageListShimmer(),
            onSuccess: (snap) {
              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(8),
                shrinkWrap: true,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemCount: snap.length,
                emptyWidget: NoDataWidget(
                  title: languages.packageNotAvailable,
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
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                itemBuilder: (BuildContext context, index) {
                  PackageData data = snap[index];

                  return Container(
                    width: context.width(),
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedImageWidget(
                          url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : '',
                          height: 70,
                          fit: BoxFit.cover,
                          radius: defaultRadius,
                        ),
                        16.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            4.height,
                            Marquee(child: Text(data.name.validate(), style: boldTextStyle())),
                            4.height,
                            if (data.subCategoryName.validate().isNotEmpty)
                              Marquee(
                                child: Row(
                                  children: [
                                    Text('${data.categoryName.validate()}', style: boldTextStyle(size: 14)),
                                    Text('  >  ', style: boldTextStyle(size: 14, color: textSecondaryColorGlobal)),
                                    Text('${data.subCategoryName.validate()}', style: secondaryTextStyle()),
                                  ],
                                ),
                              )
                            else if (data.categoryName != null)
                              Text('${data.categoryName.validate()}', style: secondaryTextStyle())
                            else
                              Offstage(),
                            if (data.categoryName != null || data.subCategoryName != null) 4.height,
                            PriceWidget(
                              price: data.price.validate(),
                              hourlyTextColor: Colors.white,
                              size: 16,
                            ),
                          ],
                        ).expand(),
                        PopupMenuButton(
                          icon: Icon(Icons.more_vert, size: 24, color: context.iconColor),
                          color: context.scaffoldBackgroundColor,
                          padding: EdgeInsets.all(8),
                          onSelected: (selection) async {
                            if (selection == 1) {
                              bool? res = await AddPackageScreen(data: data).launch(context);

                              if (res ?? false) {
                                appStore.setLoading(true);
                                init();

                                setState(() {});
                              }
                            } else if (selection == 2) {
                              confirmationDialog(packageData: data);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(child: Text(languages.lblEdit, style: boldTextStyle()), value: 1),
                            PopupMenuItem(child: Text(languages.lblDelete, style: boldTextStyle()), value: 2),
                          ],
                        ),
                      ],
                    ),
                  ).onTap(
                    () {
                      PackageDetailScreen(packageData: data).launch(context);
                    },
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                  );
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
