import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/screens/cash_management/cash_constant.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/extensions/color_extension.dart';

class CashFilterModel {
  String? name;
  String? type;
  Color? color;

  CashFilterModel({this.name, this.type, this.color});
}

List<CashFilterModel> getCashFilterList() {
  List<CashFilterModel> list = [];

  list.add(CashFilterModel(name: languages.today, type: TODAY));
  list.add(CashFilterModel(name: languages.yesterday, type: YESTERDAY));
  list.add(CashFilterModel(name: languages.customDate, type: CUSTOM));

  return list;
}

List<CashFilterModel> getCashStatusFilterList() {
  List<CashFilterModel> list = [];

  list.add(CashFilterModel(name: languages.all, type: null));
  list.add(CashFilterModel(name: handleStatusText(status: APPROVED_BY_HANDYMAN), type: APPROVED_BY_HANDYMAN));
  list.add(CashFilterModel(name: handleStatusText(status: SEND_TO_PROVIDER), type: SEND_TO_PROVIDER));
  list.add(CashFilterModel(name: handleStatusText(status: APPROVED_BY_PROVIDER), type: APPROVED_BY_PROVIDER));

  return list;
}

List<CashFilterModel> get currentStatusList => isUserTypeProvider ? getCashStatusProviderFilterList() : getCashStatusFilterList();

List<CashFilterModel> getCashStatusProviderFilterList() {
  List<CashFilterModel> list = [];

  list.add(CashFilterModel(name: languages.all, type: null));
  list.add(CashFilterModel(name: handleStatusText(status: PENDING_BY_PROVIDER), type: PENDING_BY_PROVIDER));
  list.add(CashFilterModel(name: handleStatusText(status: APPROVED_BY_PROVIDER), type: APPROVED_BY_PROVIDER));
  list.add(CashFilterModel(name: handleStatusText(status: SEND_TO_ADMIN), type: SEND_TO_ADMIN));
  list.add(CashFilterModel(name: handleStatusText(status: APPROVED_BY_ADMIN), type: APPROVED_BY_ADMIN));

  return list;
}

List<CashFilterModel> getCashPaymentList() {
  List<CashFilterModel> list = [];

  list.add(CashFilterModel(name: languages.cash, type: CASHES));
  list.add(CashFilterModel(name: languages.bank, type: BANK));

  return list;
}

List<CashFilterModel> getStatusInfo() {
  List<CashFilterModel> list = [];

  list.add(CashFilterModel(name: languages.handymanApprovedTheRequest, type: APPROVED_BY_HANDYMAN, color: APPROVED_BY_HANDYMAN.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.requestSentToTheProvider, type: SEND_TO_PROVIDER, color: SEND_TO_PROVIDER.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.requestSentToTheAdmin, type: SEND_TO_ADMIN, color: SEND_TO_ADMIN.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.requestPendingWithTheProvider, type: PENDING_BY_PROVIDER, color: PENDING_BY_PROVIDER.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.providerApprovedTheRequest, type: APPROVED_BY_PROVIDER, color: APPROVED_BY_PROVIDER.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.requestPendingWithTheAdmin, type: PENDING_BY_ADMIN, color: PENDING_BY_ADMIN.getCashPaymentStatusBackgroundColor));
  list.add(CashFilterModel(name: languages.adminApprovedTheRequest, type: APPROVED_BY_ADMIN, color: APPROVED_BY_ADMIN.getCashPaymentStatusBackgroundColor));

  return list;
}
