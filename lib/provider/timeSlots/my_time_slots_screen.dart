import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/timeSlots/components/days_component.dart';
import 'package:provider/provider/timeSlots/components/disclaimer_widget.dart';
import 'package:provider/provider/timeSlots/components/slot_component.dart';
import 'package:provider/provider/timeSlots/edit_time_slot_screen.dart';
import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:provider/provider/timeSlots/services/time_slot_services.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class MyTimeSlotsScreen extends StatefulWidget {
  final bool isFromService;

  MyTimeSlotsScreen({this.isFromService = false});

  @override
  _MyTimeSlotsScreenState createState() => _MyTimeSlotsScreenState();
}

class _MyTimeSlotsScreenState extends State<MyTimeSlotsScreen> {
  List<SlotData> timeSlotsList = [];

  String selectedDay = daysList.first;

  bool isTimeSlotAvailableForAll = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    timeSlotsList = await getProviderTimeSlots();
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> setForAllServices(bool status) async {
    timeSlotStore.setLoading(true);

    toast(languages.pleaseWaitWhileWeChangeTheStatus);

    Map request = {
      "slots_for_all_services": status ? 1 : 0,
      "id": appStore.userId,
    };

    await updateAllServicesApi(request: request).then((value) {
      isTimeSlotAvailableForAll = status;
      setState(() {});
      Fluttertoast.cancel();
      toast(value.message);
    }).catchError((e) {
      Fluttertoast.cancel();
      toast(e.toString());
    });

    timeSlotStore.setLoading(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> temp =
        timeSlotsList.isNotEmpty ? timeSlotsList.firstWhere((element) => element.day!.toLowerCase() == selectedDay.toLowerCase(), orElse: () => SlotData(slot: [], day: '')).slot.validate() : [];

    return Scaffold(
      appBar: appBarWidget(
        languages.myTimeSlots,
        textColor: white,
        color: context.primaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: context.cardColor,
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(languages.day, style: boldTextStyle()),
                          IconButton(
                            icon: Icon(Icons.edit, size: 20),
                            onPressed: () async {
                              await EditTimeSlotScreen(
                                slotData: timeSlotsList,
                                selectedDay: selectedDay,
                                onSave: (val) async {
                                  Map<String, dynamic> request = {"id": "", "provider_id": appStore.userId.validate(), "slots": val.map((e) => e.toJsonRequest()).toList()};
                                  appStore.setLoading(true);

                                  await saveProviderSlot(request).then((value) {
                                    toast(value.message.validate());

                                    if (widget.isFromService) {
                                      finish(context);
                                      finish(context, true);
                                      init();
                                    } else {
                                      finish(context, true);
                                      init();
                                    }
                                  }).catchError((e) {
                                    log(e.toString());
                                  });

                                  appStore.setLoading(false);
                                },
                              ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            },
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16, vertical: 8),
                      DaysComponent(
                        daysList: daysList,
                        onDayChanged: (day) {
                          selectedDay = day;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(languages.use24HourFormat, style: secondaryTextStyle(size: 14)),
                    16.width,
                    Observer(builder: (context) {
                      return Transform.scale(
                        scale: 0.8,
                        child: Switch.adaptive(
                          value: appStore.is24HourFormat,
                          onChanged: (value) {
                            appStore.set24HourFormat(value);
                          },
                        ),
                      );
                    })
                  ],
                ).paddingOnly(right: 16, top: 16, bottom: 16),
                SlotsComponent(timeSlotList: temp).paddingOnly(left: 16, right: 16),
                32.height,
                DisclaimerWidget(),
              ],
            ),
          ),
          Observer(builder: (_) => LoaderWidget().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
