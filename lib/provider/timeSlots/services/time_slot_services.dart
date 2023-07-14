import 'package:provider/main.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<SlotData>> getProviderTimeSlots() async {
  List<SlotData> timeSlotsList = [];

  appStore.setLoading(true);

  await getProviderSlot(val: appStore.userId.validate()).then((value) {
    timeSlotsList = value;
  }).catchError((e) {
    toast(e.toString());
  });
  appStore.setLoading(false);

  return timeSlotsList;
}

Future<List<SlotData>> getProviderServiceTimeSlots({required int serviceId}) async {
  List<SlotData> timeSlotsList = [];

  appStore.setLoading(true);

  await getProviderServiceSlot(providerId: appStore.userId.validate(), serviceId: serviceId).then((value) {
    timeSlotsList = value;
  }).catchError((e) {
    toast(e.toString());
  });
  appStore.setLoading(false);

  return timeSlotsList;
}
