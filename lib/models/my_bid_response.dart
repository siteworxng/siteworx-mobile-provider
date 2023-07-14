import 'package:provider/models/pagination_model.dart';

import '../provider/jobRequest/models/bidder_data.dart';

class MyBidResponse {
  Pagination? pagination;
  List<BidderData>? bidData;

  MyBidResponse({this.pagination, this.bidData});

  MyBidResponse.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      bidData = [];
      json['data'].forEach((v) {
        bidData?.add(BidderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (bidData != null) {
      map['data'] = bidData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
