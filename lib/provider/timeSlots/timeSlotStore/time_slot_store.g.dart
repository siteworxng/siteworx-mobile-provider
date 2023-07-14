// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_slot_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimeSlotStore on TimeSlotStoreBase, Store {
  late final _$isLoadingAtom = Atom(name: 'TimeSlotStoreBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$slotsForAllServicesAtom = Atom(name: 'TimeSlotStoreBase.slotsForAllServices', context: context);

  @override
  bool get slotsForAllServices {
    _$slotsForAllServicesAtom.reportRead();
    return super.slotsForAllServices;
  }

  @override
  set slotsForAllServices(bool value) {
    _$slotsForAllServicesAtom.reportWrite(value, super.slotsForAllServices, () {
      super.slotsForAllServices = value;
    });
  }

  late final _$isTimeSlotAvailableAtom = Atom(name: 'TimeSlotStoreBase.isTimeSlotAvailable', context: context);

  @override
  bool get isTimeSlotAvailable {
    _$isTimeSlotAvailableAtom.reportRead();
    return super.isTimeSlotAvailable;
  }

  @override
  set isTimeSlotAvailable(bool value) {
    _$isTimeSlotAvailableAtom.reportWrite(value, super.isTimeSlotAvailable, () {
      super.isTimeSlotAvailable = value;
    });
  }

  late final _$serviceSlotDataAtom = Atom(name: 'TimeSlotStoreBase.serviceSlotData', context: context);

  @override
  List<SlotData> get serviceSlotData {
    _$serviceSlotDataAtom.reportRead();
    return super.serviceSlotData;
  }

  @override
  set serviceSlotData(List<SlotData> value) {
    _$serviceSlotDataAtom.reportWrite(value, super.serviceSlotData, () {
      super.serviceSlotData = value;
    });
  }

  late final _$addSlotDataAsyncAction = AsyncAction('TimeSlotStoreBase.addSlotData', context: context);

  @override
  Future<void> addSlotData({required SlotData value}) {
    return _$addSlotDataAsyncAction.run(() => super.addSlotData(value: value));
  }

  late final _$initializeSlotsAsyncAction = AsyncAction('TimeSlotStoreBase.initializeSlots', context: context);

  @override
  Future<void> initializeSlots({required List<SlotData> value}) {
    return _$initializeSlotsAsyncAction.run(() => super.initializeSlots(value: value));
  }

  late final _$timeSlotForProviderAsyncAction = AsyncAction('TimeSlotStoreBase.timeSlotForProvider', context: context);

  @override
  Future<void> timeSlotForProvider() {
    return _$timeSlotForProviderAsyncAction.run(() => super.timeSlotForProvider());
  }

  late final _$removeSlotDataAsyncAction = AsyncAction('TimeSlotStoreBase.removeSlotData', context: context);

  @override
  Future<void> removeSlotData({required SlotData value}) {
    return _$removeSlotDataAsyncAction.run(() => super.removeSlotData(value: value));
  }

  late final _$setForAllServicesAsyncAction = AsyncAction('TimeSlotStoreBase.setForAllServices', context: context);

  @override
  Future<void> setForAllServices({required bool value, bool isInitializing = false}) {
    return _$setForAllServicesAsyncAction.run(() => super.setForAllServices(value: value, isInitializing: isInitializing));
  }

  late final _$clearSlotDataAsyncAction = AsyncAction('TimeSlotStoreBase.clearSlotData', context: context);

  @override
  Future<void> clearSlotData() {
    return _$clearSlotDataAsyncAction.run(() => super.clearSlotData());
  }

  late final _$TimeSlotStoreBaseActionController = ActionController(name: 'TimeSlotStoreBase', context: context);

  @override
  List<String> checkIsAvailable({required String selectedDay}) {
    final _$actionInfo = _$TimeSlotStoreBaseActionController.startAction(name: 'TimeSlotStoreBase.checkIsAvailable');
    try {
      return super.checkIsAvailable(selectedDay: selectedDay);
    } finally {
      _$TimeSlotStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLoading(bool val) {
    final _$actionInfo = _$TimeSlotStoreBaseActionController.startAction(name: 'TimeSlotStoreBase.setLoading');
    try {
      return super.setLoading(val);
    } finally {
      _$TimeSlotStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
slotsForAllServices: ${slotsForAllServices},
isTimeSlotAvailable: ${isTimeSlotAvailable},
serviceSlotData: ${serviceSlotData}
    ''';
  }
}
