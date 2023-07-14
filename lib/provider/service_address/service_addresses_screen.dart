import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/service_address/components/add_service_component.dart';
import 'package:provider/provider/service_address/shimmer/service_address_shimmer.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/app_widgets.dart';
import '../../components/empty_error_state_widget.dart';
import 'components/service_addresses_component.dart';

class ServiceAddressesScreen extends StatefulWidget {
  final bool? isFromService;

  ServiceAddressesScreen({this.isFromService});

  @override
  ServiceAddressesScreenState createState() => ServiceAddressesScreenState();
}

class ServiceAddressesScreenState extends State<ServiceAddressesScreen> {
  Future<List<AddressResponse>>? future;
  List<AddressResponse> addressList = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    future = getAddressesWithPagination(
      page: page,
      lastPageCallback: (b) {
        isLastPage = b;
      },
      addressList: addressList,
      providerId: appStore.userId.validate(),
    );
  }

  void addAddressDialog(AddressResponse? data) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.all(0),
      dialogAnimation: DialogAnimation.SCALE,
      builder: (_) {
        return AddServiceComponent(addressData: data);
      },
    ).then((value) {
      if (value != null) {
        if (value) {
          init();
          setState(() {});
        }
      }
    });
  }

  Future<void> updateAddressStatus({required AddressResponse data, required bool status}) async {
    appStore.setLoading(true);
    Map request = {
      AddAddressKey.id: data.id,
      AddAddressKey.providerId: appStore.userId,
      AddAddressKey.latitude: data.latitude,
      AddAddressKey.longitude: data.longitude,
      AddAddressKey.status: status ? "1" : "0",
      AddAddressKey.address: data.address,
    };
    await addAddresses(request).then((value) {
      init();
      setState(() {});
      toast(value.message.validate());
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  Future<void> deleteAddress(int? id) async {
    appStore.setLoading(true);
    await removeAddress(id).then((value) {
      toast(value.message);
      finish(context);
      init();
      setState(() {});
    }).catchError((e) {
      toast(e.toString(), print: true);
    });

    appStore.setLoading(false);
  }

  void deleteDialog({int? id}) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.all(0),
      builder: (_) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(delete, width: 110, height: 110, fit: BoxFit.cover),
              32.height,
              Text(languages.lblDeleteAddress, style: boldTextStyle(size: 16)),
              16.height,
              Text(languages.lblDeleteAddressMsg, style: secondaryTextStyle(), textAlign: TextAlign.center),
              28.height,
              Row(
                children: [
                  AppButton(
                    child: Text(languages.lblCancel, style: boldTextStyle()),
                    color: context.cardColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(languages.lblDelete, style: boldTextStyle(color: white)),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      deleteAddress(id);
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 28),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.lblServiceAddress,
        textColor: white,
        showBack: true,
        backWidget: BackWidget(),
        color: context.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              addAddressDialog(null);
            },
            icon: Icon(Icons.add, size: 28, color: white),
            tooltip: languages.lblAddServiceAddress,
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<AddressResponse>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasData) {
                if (snap.data.validate().isEmpty)
                  return NoDataWidget(
                    title: languages.noServiceAddressTitle,
                    subTitle: languages.noServiceAddressSubTitle,
                    imageWidget: EmptyStateWidget(),
                  );
                return AnimatedListView(
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      appStore.setLoading(true);

                      init();
                      setState(() {});
                    }
                  },
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  slideConfiguration: SlideConfiguration(verticalOffset: 400),
                  disposeScrollController: false,
                  onSwipeRefresh: () async {
                    page = 1;

                    init();
                    setState(() {});

                    return await 2.seconds.delay;
                  },
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: addressList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (_, i) {
                    AddressResponse data = addressList[i];
                    return ServiceAddressesComponent(
                      addressList[i],
                      onEdit: () {
                        ifNotTester(context, () {
                          addAddressDialog(data);
                        });
                      },
                      onDelete: () {
                        ifNotTester(context, () {
                          deleteDialog(id: data.id.validate());
                        });
                      },
                      onStatusUpdate: (value) async {
                        ifNotTester(context, () {
                          updateAddressStatus(data: data, status: value.validate());
                        });
                      },
                    );
                  },
                );
              }

              return snapWidgetHelper(
                snap,
                loadingWidget: ServiceAddressShimmer(),
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
