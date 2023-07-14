import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/provider/timeSlots/components/available_slots_component.dart';
import 'package:provider/provider/timeSlots/components/days_bottom_sheet.dart';
import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class EditTimeSlotScreen extends StatefulWidget {
  final List<SlotData> slotData;
  final String? selectedDay;
  final Function(List<SlotData>) onSave;

  EditTimeSlotScreen({required this.slotData, this.selectedDay, required this.onSave});

  @override
  EditTimeSlotScreenState createState() => EditTimeSlotScreenState();
}

class EditTimeSlotScreenState extends State<EditTimeSlotScreen> {
  UniqueKey keyForTimeSlotWidget = UniqueKey();
  int selectedDayIndex = 0;

  List<String> selectedTimeSlots = [];

  String selectedDay = daysList.first;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    daysList.forEach((element) {
      if (element == widget.selectedDay) {
        selectedDayIndex = daysList.indexOf(element);
        selectedDay = element.validate();
        keyForTimeSlotWidget = UniqueKey();
      }
    });
  }

  Future saveTimeSlot() async {
    timeSlotStore.serviceSlotData = widget.slotData;
    finish(context, true);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.timeSlots,
        center: true,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.selectYourDay, style: boldTextStyle()).paddingSymmetric(horizontal: 16, vertical: 16),
                HorizontalList(
                  itemCount: daysList.length,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  wrapAlignment: WrapAlignment.start,
                  spacing: 16,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (BuildContext context, int index) {
                    String data = daysList[index];
                    bool isSelected = selectedDayIndex == index;
                    return GestureDetector(
                      onTap: () {
                        selectedDayIndex = index;
                        selectedDay = data.validate();
                        keyForTimeSlotWidget = UniqueKey();

                        setState(() {});
                      },
                      child: Container(
                        height: 60,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: isSelected ? primaryColor : context.cardColor,
                          borderRadius: BorderRadius.circular(defaultRadius),
                        ),
                        child: Text(
                          data.validate(),
                          style: appStore.isDarkMode ? boldTextStyle(color: white) : boldTextStyle(color: isSelected ? white : appTextPrimaryColor),
                        ),
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.chooseTime, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
                    TextButton(
                      child: Text(languages.copyTo, style: secondaryTextStyle()),
                      onPressed: () async {
                        List<String> list = await showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                          ),
                          builder: (_) {
                            return DaysBottomSheet(selectedDay: selectedDay);
                          },
                        );

                        list.forEach((element) {
                          widget.slotData.removeWhere((e) => e.day.validate().toLowerCase() == element.toLowerCase());
                          widget.slotData.add(SlotData(day: element.toLowerCase(), slot: selectedTimeSlots.toSet().toList()));
                        });

                        keyForTimeSlotWidget = UniqueKey();

                        setState(() {});
                      },
                    ),
                  ],
                ).paddingOnly(left: 16, right: 16, top: 16),
                AvailableSlotsComponent(
                  key: keyForTimeSlotWidget,
                  onChanged: (List<String> selectedSlots) {
                    selectedTimeSlots = selectedSlots;

                    widget.slotData.removeWhere((e) => e.day.validate().toLowerCase() == selectedDay.toLowerCase());
                    widget.slotData.add(SlotData(day: selectedDay.toLowerCase(), slot: selectedTimeSlots.toSet().toList()));

                    setState(() {});
                  },
                  availableSlots: [],
                  selectedSlots: widget.slotData.firstWhere((element) => element.day.validate().toLowerCase() == selectedDay.toLowerCase(), orElse: () => SlotData(slot: [], day: '')).slot.validate(),
                ).paddingSymmetric(horizontal: 16, vertical: 16),
              ],
            ),
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
      bottomNavigationBar: AppButton(
        width: context.width(),
        color: primaryColor,
        text: languages.lblUpdate,
        onTap: () {
          widget.onSave.call(widget.slotData);
        },
      ).paddingAll(24),
    );
  }
}
