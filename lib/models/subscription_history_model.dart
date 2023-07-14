import 'package:provider/models/pagination_model.dart';
import 'package:provider/models/provider_subscription_model.dart';

class SubscriptionHistoryResponse {
  Pagination? pagination;
  List<ProviderSubscriptionModel>? data;

  SubscriptionHistoryResponse({this.pagination, this.data});

  SubscriptionHistoryResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProviderSubscriptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
