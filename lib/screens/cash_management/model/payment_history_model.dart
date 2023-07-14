import 'package:provider/models/pagination_model.dart';
import 'package:provider/screens/cash_management/cash_constant.dart';

class PaymentHistoryModel {
  Pagination? pagination;
  List<PaymentHistoryData>? data;

  PaymentHistoryModel({
    this.pagination,
    this.data,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) => PaymentHistoryModel(
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        data: json["data"] == null ? [] : List<PaymentHistoryData>.from(json["data"]!.map((x) => PaymentHistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "data": data == null ? [] : List<PaymentHistoryData>.from(data!.map((x) => x.toJson())),
      };
}

class PaymentHistoryData {
  num? id;
  num? paymentId;
  num? bookingId;
  String? action;
  String? text;
  String? type;
  String? status;
  num? senderId;
  num? receiverId;
  num? parentId;
  String? txnId;
  String? otherTransactionDetail;
  DateTime? datetime;
  num? totalAmount;

  //local
  bool get isTypeBank => type == BANK;

  PaymentHistoryData({
    this.id,
    this.paymentId,
    this.bookingId,
    this.action,
    this.text,
    this.type,
    this.status,
    this.senderId,
    this.parentId,
    this.receiverId,
    this.txnId,
    this.otherTransactionDetail,
    this.datetime,
    this.totalAmount,
  });

  factory PaymentHistoryData.fromJson(Map<String, dynamic> json) => PaymentHistoryData(
        id: json["id"],
        paymentId: json["payment_id"],
        bookingId: json["booking_id"],
        action: json["action"],
        text: json["text"],
        type: json["type"],
        status: json["status"],
        parentId: json["parent_id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        txnId: json["txn_id"],
        otherTransactionDetail: json["other_transaction_detail"],
        datetime: json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "payment_id": paymentId,
        "booking_id": bookingId,
        "action": action,
        "text": text,
        "txn_id": txnId,
        "parent_id": parentId,
        "other_transaction_detail": otherTransactionDetail,
        "type": type,
        "status": status,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "datetime": datetime?.toIso8601String(),
        "total_amount": totalAmount,
      };
}
