import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/tax_list_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/taxes/shimmer/taxes_shimmer.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';

class TaxesScreen extends StatefulWidget {
  @override
  _TaxesScreenState createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
  Future<List<TaxData>>? future;
  List<TaxData> taxList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getTaxList(
      page: page,
      list: taxList,
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: appBarWidget(
        languages.lblTaxes,
        showBack: true,
        backWidget: BackWidget(),
        textColor: Colors.white,
        color: context.primaryColor,
      ),
      body: Stack(
        children: [
          SnapHelperWidget<List<TaxData>>(
            future: future,
            onSuccess: (list) {
              return AnimatedListView(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: list.length,
                padding: EdgeInsets.all(8),
                disposeScrollController: false,
                shrinkWrap: true,
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                itemBuilder: (context, index) {
                  TaxData data = list[index];

                  return Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(8),
                    decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(),
                      backgroundColor: context.cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${languages.lblTaxName}', style: secondaryTextStyle(size: 14)),
                            Text('${data.title.validate()}', style: boldTextStyle()),
                          ],
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${languages.lblMyTax}', style: secondaryTextStyle(size: 14)),
                            Row(
                              children: [
                                Text(
                                  isCommissionTypePercent(data.type) ? ' ${data.value.validate()} %' : ' ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${data.value.validate()}',
                                  style: boldTextStyle(),
                                ),
                                Text(' (${data.type.capitalizeFirstLetter()})', style: boldTextStyle()),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
                emptyWidget: NoDataWidget(
                  title: languages.lblNoTaxesFound,
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
              );
            },
            loadingWidget: TaxesShimmer(),
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
