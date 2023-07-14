import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/fragments/booking_fragment.dart';
import 'package:provider/fragments/notification_fragment.dart';
import 'package:provider/main.dart';
import 'package:provider/provider/fragments/provider_home_fragment.dart';
import 'package:provider/provider/fragments/provider_payment_fragment.dart';
import 'package:provider/provider/fragments/provider_profile_fragment.dart';
import 'package:provider/screens/chat/user_chat_list_screen.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ProviderDashboardScreen extends StatefulWidget {
  final int? index;

  ProviderDashboardScreen({this.index});

  @override
  ProviderDashboardScreenState createState() => ProviderDashboardScreenState();
}

class ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  int currentIndex = 0;

  DateTime? currentBackPressTime;

  List<Widget> fragmentList = [
    ProviderHomeFragment(),
    BookingFragment(),
    ProviderPaymentFragment(),
    ProviderProfileFragment(),
  ];

  List<String> screenName = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(
      () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
        }

        window.onPlatformBrightnessChanged = () async {
          if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
            appStore.setDarkMode(context.platformBrightness() == Brightness.light);
          }
        };
        OneSignal.shared.sendTag(ONESIGNAL_TAG_KEY, ONESIGNAL_TAG_PROVIDER_VALUE);
      },
    );

    LiveStream().on(LIVESTREAM_PROVIDER_ALL_BOOKING, (index) {
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
    LiveStream().dispose(LIVESTREAM_PROVIDER_ALL_BOOKING);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();

        if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          toast(languages.lblCloseAppMsg);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        appBar: appBarWidget(
          [
            languages.providerHome,
            languages.lblBooking,
            languages.lblPayment,
            languages.lblProfile,
          ][currentIndex],
          color: primaryColor,
          textColor: Colors.white,
          showBack: false,
          actions: [
            IconButton(
              icon: chat.iconImage(color: white, size: 20),
              onPressed: () async {
                 ChatListScreen().launch(context);
              },
            ),
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  ic_notification.iconImage(color: white, size: 20),
                  Positioned(
                    top: -14,
                    right: -6,
                    child: Observer(
                      builder: (context) {
                        if (appStore.notificationCount.validate() > 0)
                          return Container(
                            padding: EdgeInsets.all(4),
                            child: FittedBox(
                              child: Text(appStore.notificationCount.toString(), style: primaryTextStyle(size: 12, color: Colors.white)),
                            ),
                            decoration: boxDecorationDefault(color: Colors.red, shape: BoxShape.circle),
                          );

                        return Offstage();
                      },
                    ),
                  )
                ],
              ),
              onPressed: () async {
                NotificationFragment().launch(context);
              },
            ),
          ],
        ),
        body: fragmentList[currentIndex],
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
                  icon: un_fill_wallet.iconImage(color: appTextSecondaryColor),
                  selectedIcon: ic_fill_wallet.iconImage(color: context.primaryColor),
                  label: languages.lblPayment,
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
      ),
    );
  }
}
