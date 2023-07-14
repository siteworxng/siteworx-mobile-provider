import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:provider/provider/timeSlots/services/time_slot_services.dart';
import 'package:provider/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'time_slot_store.g.dart';

class TimeSlotStore = TimeSlotStoreBase with _$TimeSlotStore;

abstract class TimeSlotStoreBase with Store {
  @observable
  bool isLoading = false;

  @observable
  bool slotsForAllServices = false;

  @observable
  bool isTimeSlotAvailable = false;

  @observable
  List<SlotData> serviceSlotData = ObservableList();

  @action
  Future<void> addSlotData({required SlotData value}) async {
    serviceSlotData.add(value);
  }

  @action
  Future<void> initializeSlots({required List<SlotData> value}) async {
    serviceSlotData = value;
  }

  @action
  Future<void> timeSlotForProvider() async {
    List<SlotData> list = await getProviderTimeSlots();
    isTimeSlotAvailable = list.where((element) => element.slot.validate().isNotEmpty).isNotEmpty;
  }

  @action
  Future<void> removeSlotData({required SlotData value}) async {
    serviceSlotData.removeWhere((element) => element.day == value.day.validate());
  }

  @action
  Future<void> setForAllServices({required bool value, bool isInitializing = false}) async {
    slotsForAllServices = value;

    if (isInitializing) setValue(FOR_ALL_SERVICES, value);
  }

  @action
  Future<void> clearSlotData() async {
    serviceSlotData.clear();
  }

  @action
  List<String> checkIsAvailable({required String selectedDay}) {
    return serviceSlotData.firstWhere((element) => element.day == selectedDay, orElse: () => SlotData(slot: [], day: '')).slot.validate();
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }
}
