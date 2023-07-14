import 'package:flutter/material.dart';
import 'package:provider/components/notification_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/notification_list_response.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/screens/booking_detail_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../components/app_widgets.dart';
import '../components/base_scaffold_widget.dart';
import '../components/empty_error_state_widget.dart';

class NotificationFragment extends StatefulWidget {
  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationFragment> {
  late Future<List<NotificationData>> future;
  List<NotificationData> list = [];

  int page = 1;
  bool isLastPage = false;

  @override
  void initState() {
    super.initState();

    LiveStream().on(LIVESTREAM_UPDATE_NOTIFICATIONS, (p0) {
      appStore.setLoading(true);

      init(type: MARK_AS_READ);
      setState(() {});
    });
    init();
  }

  Future<void> init({String type = ''}) async {
    future = getNotification(
      {NotificationKey.type: type},
      notificationList: list,
      lastPageCallback: (val) => isLastPage = val,
    );
  }

  Future<void> readNotification({String? id}) async {
    Map request = {CommonKeys.bookingId: id};

    //appStore.setLoading(true);

    await bookingDetail(request).then((value) {
      init();
    }).catchError((e) {
      log(e.toString());
    });

    //appStore.setLoading(false);
  }

  Widget listIterate(List<NotificationData> list) {
    return AnimatedListView(
      shrinkWrap: true,
      itemCount: list.length,
      physics: NeverScrollableScrollPhysics(),
      listAnimationType: ListAnimationType.FadeIn,
      fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
      slideConfiguration: SlideConfiguration(duration: 400.milliseconds, delay: 50.milliseconds),
      itemBuilder: (context, index) {
        NotificationData data = list[index];

        return GestureDetector(
          onTap: () async {
            if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER && data.data!.type == PAYOUT) {
              readNotification(id: data.data!.id.toString());
            } else if (isUserTypeHandyman) {
              if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_BOOKING) {
                readNotification(id: data.data!.id.toString());
                BookingDetailScreen(bookingId: data.data!.id).launch(context);
              } else {
                //
              }
            } else if (isUserTypeProvider) {
              if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER) {
                if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_BOOKING) {
                  readNotification(id: data.data!.id.toString());
                  BookingDetailScreen(bookingId: data.data!.id).launch(context);
                } else if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_POST_JOB) {
                  //
                } else {
                  //
                }
              } else {
                init();
              }
            }
          },
          child: NotificationWidget(data: data),
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(LIVESTREAM_UPDATE_NOTIFICATIONS);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: Navigator.canPop(context) ? languages.notification : null,
      actions: [
        IconButton(
          icon: Icon(Icons.clear_all_rounded, color: Colors.white),
          onPressed: () async {
            showConfirmDialogCustom(
              context,
              onAccept: (_) async {
                appStore.setLoading(true);

                init(type: MARK_AS_READ);
                setState(() {});
              },
              primaryColor: context.primaryColor,
              negativeText: languages.lblNo,
              positiveText: languages.lblYes,
              title: languages.confirmationRequestTxt,
            );
          },
        ),
      ],
      body: SnapHelperWidget<List<NotificationData>>(
        initialData: cachedNotifications,
        future: future,
        loadingWidget: LoaderWidget(),
        onSuccess: (list) {
          return AnimatedListView(
            itemCount: list.length,
            shrinkWrap: true,
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            emptyWidget: NoDataWidget(
              title: languages.noNotificationTitle,
              subTitle: languages.noNotificationSubTitle,
              imageWidget: EmptyStateWidget(),
            ),
            itemBuilder: (context, index) {
              NotificationData data = list[index];

              return GestureDetector(
                onTap: () async {
                  if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER && data.data!.type == PAYOUT) {
                    readNotification(id: data.data!.id.toString());
                  } else if (isUserTypeHandyman) {
                    if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_BOOKING) {
                      readNotification(id: data.data!.id.toString());
                      BookingDetailScreen(bookingId: data.data!.id).launch(context);
                    } else {
                      //
                    }
                  } else if (isUserTypeProvider) {
                    if (data.data!.type != ADD_WALLET && data.data!.type != UPDATE_WALLET && data.data!.type != WALLET_PAYOUT_TRANSFER) {
                      if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_BOOKING) {
                        readNotification(id: data.data!.id.toString());
                        BookingDetailScreen(bookingId: data.data!.id).launch(context);
                      } else if (data.data!.notificationType.validate() == NOTIFICATION_TYPE_POST_JOB) {
                        //
                      } else {
                        //
                      }
                    } else {
                      init();
                    }
                  }
                },
                child: NotificationWidget(data: data),
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
    );
  }
}
