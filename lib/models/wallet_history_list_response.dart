import 'dart:convert';

import 'package:provider/models/pagination_model.dart';

class WalletHistoryListResponse {
  List<WalletHistory>? data;
  Pagination? pagination;

  WalletHistoryListResponse({this.data, this.pagination});

  factory WalletHistoryListResponse.fromJson(Map<String, dynamic> json) {
    return WalletHistoryListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => WalletHistory.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class WalletHistory {
  ActivityData? activityData;
  String? activityMessage;
  String? activityType;
  String? datetime;
  int? id;

  WalletHistory({this.activityData, this.activityMessage, this.activityType, this.datetime, this.id});

  factory WalletHistory.fromJson(Map<String, dynamic> json) {
    return WalletHistory(
      activityData: json['activity_data'] != null ? ActivityData.fromJson(jsonDecode(json['activity_data'] as String)) : null,
      activityMessage: json['activity_message'],
      activityType: json['activity_type'],
      datetime: json['datetime'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (data['activity_data'] != null) {
      data['activity_data'] = this.activityData;
    }
    data['activity_message'] = this.activityMessage;
    data['activity_type'] = this.activityType;
    data['datetime'] = this.datetime;

    data['id'] = this.id;
    return data;
  }
}

class ActivityData {
  int? amount;
  String? providerName;
  String? title;
  int? userId;

  ActivityData({this.amount, this.providerName, this.title, this.userId});

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      amount: json['amount'],
      providerName: json['provider_name'],
      title: json['title'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['provider_name'] = this.providerName;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    return data;
  }
}
