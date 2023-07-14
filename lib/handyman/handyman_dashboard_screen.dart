import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/my_provider_widget.dart';
import 'package:provider/fragments/booking_fragment.dart';
import 'package:provider/fragments/notification_fragment.dart';
import 'package:provider/handyman/screen/fragments/handyman_fragment.dart';
import 'package:provider/handyman/screen/fragments/handyman_profile_fragment.dart';
import 'package:provider/main.dart';
import 'package:provider/screens/chat/user_chat_list_screen.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HandymanDashboardScreen extends StatefulWidget {
  final int? index;

  HandymanDashboardScreen({this.index});

  @override
  _HandymanDashboardScreenState createState() => _HandymanDashboardScreenState();
}

class _HandymanDashboardScreenState extends State<HandymanDashboardScreen> {
  int currentIndex = 0;

  List<Widget> fragmentList = [
    HandymanHomeFragment(),
    BookingFragment(),
    NotificationFragment(),
    HandymanProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setStatusBarColor(primaryColor);

    afterBuildCreated(() async {
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      window.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.light);
        }
      };

      OneSignal.shared.sendTag(ONESIGNAL_TAG_KEY, ONESIGNAL_TAG_HANDYMAN_VALUE);
    });

    LiveStream().on(LIVESTREAM_HANDY_BOARD, (index) {
      currentIndex = (index as Map)["index"];
      setState(() {});
    });

    LiveStream().on(LIVESTREAM_HANDYMAN_ALL_BOOKING, (index) {
      currentIndex = index as int;
      setState(() {});
    });

    await 3.seconds.delay;
    showForceUpdateDialog(context);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    LiveStream().dispose(LIVESTREAM_HANDY_BOARD);
    LiveStream().dispose(LIVESTREAM_HANDYMAN_ALL_BOOKING);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: fragmentList[currentIndex],
      appBar: appBarWidget(
        [
          languages.handymanHome,
          languages.lblBooking,
          languages.notification,
          languages.lblProfile,
        ][currentIndex],
        color: primaryColor,
        elevation: 0.0,
        textColor: Colors.white,
        showBack: false,
        actions: [
          if (currentIndex == 2)
            IconButton(
              icon: Icon(Icons.clear_all_rounded, color: white),
              onPressed: () async {
                LiveStream().emit(LIVESTREAM_UPDATE_NOTIFICATIONS);
              },
            ),
          IconButton(
            icon: ic_info.iconImage(color: Colors.white),
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(borderRadius: radius()),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                builder: (context) {
                  return MyProviderWidget();
                },
              );
            },
          ),
          IconButton(
            icon: Image.asset(chat, height: 20, width: 20, color: white),
            onPressed: () async {
              ChatListScreen().launch(context);
            },
          ),
        ],
      ),
      bottomNavigationBar: Blur(
        blur: 30,
        borderRadius: radius(0),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: context.primaryColor.withOpacity(0.02),
            indicatorColor: context.primaryColor.withOpacity(0.1),
            labelTextStyle: MaterialStateProperty.all(primaryTextStyle(size: 12)),
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: NavigationBar(
            selectedIndex: currentIndex,
            destinations: [
              NavigationDestination(
                icon: ic_home.iconImage(color: appTextSecondaryColor),
                selectedIcon: ic_fill_home.iconImage(color: context.primaryColor),
                label: languages.home,
              ),
              NavigationDestination(
                icon: total_booking.iconImage(color: appTextSecondaryColor),
                selectedIcon: fill_ticket.iconImage(color: context.primaryColor),
                label: languages.lblBooking,
              ),
              NavigationDestination(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ic_notification.iconImage(color: appTextSecondaryColor),
                    Positioned(
                      top: -10,
                      right: -4,
                      child: Observer(builder: (context) {
                        if (appStore.notificationCount.validate() > 0)
                          return Container(
                            padding: EdgeInsets.all(4),
                            child: FittedBox(
                              child: Text(appStore.notificationCount.toString(), style: primaryTextStyle(size: 12, color: Colors.white)),
                            ),
                            decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                          );

                        return Offstage();
                      }),
                    )
                  ],
                ),
                selectedIcon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ic_fill_notification.iconImage(color: context.primaryColor),
                    Positioned(
                      top: -10,
                      right: -4,
                      child: Observer(builder: (context) {
                        if (appStore.notificationCount.validate() > 0)
                          return Container(
                            padding: EdgeInsets.all(4),
                            child: FittedBox(
                              child: Text(appStore.notificationCount.toString(), style: primaryTextStyle(size: 12, color: Colors.white)),
                            ),
                            decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                          );

                        return Offstage();
                      }),
                    )
                  ],
                ),
                label: languages.notification,
              ),
              NavigationDestination(
                icon: profile.iconImage(color: appTextSecondaryColor),
                selectedIcon: ic_fill_profile.iconImage(color: context.primaryColor),
                label: languages.lblProfile,
              ),
            ],
            onDestinationSelected: (index) {
              currentIndex = index;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
