import 'package:flutter/material.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class UserDemoModeScreen extends StatefulWidget {
  final Function(String email, String password) onChanged;

  UserDemoModeScreen({required this.onChanged});

  @override
  _UserDemoModeScreenState createState() => _UserDemoModeScreenState();
}

class _UserDemoModeScreenState extends State<UserDemoModeScreen> {
  List<String> demoLoginName = ["Demo Provider", "Demo Handyman", "Reset"];

  int btnIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getPackageName(),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data! == APP_PACKAGE_NAME) {
            return Column(
              children: [
                32.height,
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 16,
                  children: List.generate(
                    demoLoginName.length,
                    (index) {
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(side: BorderSide(color: btnIndex == index ? primaryColor : gray.withOpacity(0.2), width: 1)),
                        onPressed: () {
                          btnIndex = index;
                          setState(() {});

                          if (index == 0) {
                            widget.onChanged.call(DEFAULT_PROVIDER_EMAIL, DEFAULT_PASS);
                          }
                          if (index == 1) {
                            widget.onChanged.call(DEFAULT_HANDYMAN_EMAIL, DEFAULT_PASS);
                          }
                          if (index == 2) {
                            widget.onChanged.call('', '');
                          }
                        },
                        child: Text(demoLoginName[index], style: boldTextStyle(color: primaryColor)),
                      ).withWidth(context.width() / 2 - 24);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Offstage();
          }
        }
        return Offstage();
      },
    );
  }
}
