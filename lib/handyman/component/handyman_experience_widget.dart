import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/configs.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class HandymanExperienceWidget extends StatefulWidget {
  const HandymanExperienceWidget({Key? key}) : super(key: key);

  @override
  _HandymanExperienceWidgetState createState() => _HandymanExperienceWidgetState();
}

class _HandymanExperienceWidgetState extends State<HandymanExperienceWidget> {
  String temp = '';
  int value = 0;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    Duration duration = DateTime.now().difference(DateTime.parse(appStore.createdAt));

    if (duration.inDays < 365) {
      temp = languages.lblDay;
      value = duration.inDays;
    } else if (duration.inDays >= 365) {
      temp = languages.lblYear;
      value = (duration.inDays / 365).floor();
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (temp.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("$value", style: boldTextStyle(color: primaryColor, size: LABEL_TEXT_SIZE)),
          8.height,
          Text(
            "$temp${languages.lblOf} \n${languages.lblExperience}",
            style: secondaryTextStyle(),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
