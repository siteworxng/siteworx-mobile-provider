import 'package:flutter/material.dart';
import 'package:provider/auth/sign_in_screen.dart';
import 'package:provider/handyman/handyman_dashboard_screen.dart';
import 'package:provider/main.dart';
import 'package:provider/provider/provider_dashboard_screen.dart';
import 'package:provider/screens/maintenance_mode_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/constant.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    afterBuildCreated(() async {
      appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE), context: context);
      setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);

      int themeModeIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
      if (themeModeIndex == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
      }
    });

    if (!await isAndroid12Above()) await 500.milliseconds.delay;

    if (remoteConfigDataModel.inMaintenanceMode.validate()) {
      MaintenanceModeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
    } else {
      if (!appStore.isLoggedIn) {
        SignInScreen().launch(context, isNewTask: true);
      } else {
        if (isUserTypeProvider) {
          setStatusBarColor(primaryColor);
          ProviderDashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else if (isUserTypeHandyman) {
          setStatusBarColor(primaryColor);
          HandymanDashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        } else {
          SignInScreen().launch(context, isNewTask: true);
        }
      }
    }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(appLogo, height: 120, width: 120),
              32.height,
              Text(APP_NAME, style: boldTextStyle(size: 26)),
            ],
          ),
        ],
      ),
    );
  }
}
