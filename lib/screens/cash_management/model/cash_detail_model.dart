import 'package:provider/screens/cash_management/model/payment_history_model.dart';

class CashHistoryModel {
  num? totalCash;
  num? todayCash;
  List<PaymentHistoryData>? data;

  CashHistoryModel({
    this.totalCash,
    this.todayCash,
    this.data,
  });

  factory CashHistoryModel.fromJson(Map<String, dynamic> json) => CashHistoryModel(
        totalCash: json["total_cash"],
        todayCash: json["today_cash"],
        data: json["cash_detail"] == null ? [] : List<PaymentHistoryData>.from(json["cash_detail"]!.map((x) => PaymentHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    return {
      "total_cash": totalCash,
      "today_cash": todayCash,
      "cash_detail": data == null ? [] : List<PaymentHistoryData>.from(data!.map((x) => x.toJson())),
    };
  }
}
