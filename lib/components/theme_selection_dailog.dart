import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeSelectionDaiLog extends StatefulWidget {
  final BuildContext buildContext;

  ThemeSelectionDaiLog(this.buildContext);

  @override
  ThemeSelectionDaiLogState createState() => ThemeSelectionDaiLogState();
}

class ThemeSelectionDaiLogState extends State<ThemeSelectionDaiLog> {
  List<String> themeModeList = [];
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      themeModeList = [languages.lightMode, languages.darkMode, languages.systemDefault];
    });
    currentIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: boxDecorationWithRoundedCorners(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              backgroundColor: primaryColor,
            ),
            padding: EdgeInsets.only(left: 24, right: 8, bottom: 8, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages.chooseTheme, style: boldTextStyle(color: white, size: 16)),
                IconButton(
                  onPressed: () {
                    finish(context);
                  },
                  icon: Icon(Icons.close, size: 22, color: white),
                ),
              ],
            ),
          ),
          AnimatedListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 16),
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            itemCount: themeModeList.length,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                value: index,
                activeColor: primaryColor,
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: currentIndex,
                title: Text(themeModeList[index], style: primaryTextStyle()),
                onChanged: (dynamic val) async {
                  currentIndex = val;

                  if (val == THEME_MODE_SYSTEM) {
                    appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
                  } else if (val == THEME_MODE_LIGHT) {
                    appStore.setDarkMode(false);
                  } else if (val == THEME_MODE_DARK) {
                    appStore.setDarkMode(true);
                  }
                  await setValue(THEME_MODE_INDEX, val);

                  setState(() {});
                  finish(context);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
