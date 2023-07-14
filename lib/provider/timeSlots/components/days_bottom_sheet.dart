import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class DaysBottomSheet extends StatefulWidget {
  final String selectedDay;

  DaysBottomSheet({required this.selectedDay});

  @override
  DaysBottomSheetState createState() => DaysBottomSheetState();
}

class DaysBottomSheetState extends State<DaysBottomSheet> {
  List<String> localDayList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    localDayList.add(widget.selectedDay);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.45,
      maxChildSize: 0.7,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: boxDecorationWithRoundedCorners(borderRadius: radiusOnly(topLeft: 16, topRight: 16), backgroundColor: context.cardColor),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 6,
                      width: 40,
                      decoration: boxDecorationDefault(borderRadius: radius(60), color: context.primaryColor),
                    ).center(),
                    16.height,
                    ListView.builder(
                      itemCount: daysList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (_, i) {
                        if (daysList[i] == widget.selectedDay) return SizedBox();
                        return Container(
                          child: CheckboxListTile(
                            title: Text(daysList[i], style: boldTextStyle()),
                            value: localDayList.contains(daysList[i]),
                            onChanged: (bool? value) {
                              if (localDayList.contains(daysList[i])) {
                                localDayList.remove(daysList[i]);
                              } else {
                                localDayList.add(daysList[i]);
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ).paddingBottom(60),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: AppButton(
                  text: languages.btnSave,
                  color: primaryColor,
                  textStyle: boldTextStyle(color: white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: () async {
                    if (localDayList.isNotEmpty) finish(context, localDayList);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
