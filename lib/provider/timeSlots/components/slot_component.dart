import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/main.dart';
import 'package:provider/provider/timeSlots/components/slot_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class SlotsComponent extends StatefulWidget {
  final List<String> timeSlotList;

  SlotsComponent({required this.timeSlotList});

  @override
  SlotsComponentState createState() => SlotsComponentState();
}

class SlotsComponentState extends State<SlotsComponent> {
  int selectTimeSlotIndex = -1;

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
    return Observer(
      builder: (context) {
        return Container(
          width: context.width(),
          padding: EdgeInsets.only(top: 16, bottom: 16, left: 12, right: 12),
          decoration: boxDecorationWithRoundedCorners(
            backgroundColor: context.cardColor,
            borderRadius: BorderRadius.circular(defaultRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(languages.lblTime, style: boldTextStyle()).paddingOnly(top: 8, bottom: 16, left: 8, right: 16),
              if (widget.timeSlotList.isNotEmpty)
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.timeSlotList
                      .map(
                        (slot) => SlotWidget(
                          isAvailable: false,
                          isSelected: false,
                          width: context.width() / 3 - 24,
                          isWhiteBackground: appStore.isDarkMode ? scaffoldDarkColor : Colors.white,
                          value: slot.validate(),
                          onTap: () {
                            //
                          },
                        ),
                      )
                      .toList(),
                )
              else
                Text(languages.noSlotsAvailable, style: secondaryTextStyle()).paddingAll(16).center(),
            ],
          ),
        ).visible(!appStore.isLoading);
      },
    );
  }
}
