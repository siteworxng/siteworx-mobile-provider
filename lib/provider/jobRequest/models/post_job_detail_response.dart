import 'package:provider/provider/jobRequest/models/post_job_data.dart';

import 'bidder_data.dart';

class PostJobDetailResponse {
  PostJobData? postRequestDetail;
  List<BidderData>? bidderData;

  PostJobDetailResponse({this.postRequestDetail, this.bidderData});

  PostJobDetailResponse.fromJson(dynamic json) {
    postRequestDetail = json['post_request_detail'] != null ? PostJobData.fromJson(json['post_request_detail']) : null;
    if (json['bider_data'] != null) {
      bidderData = [];
      json['bider_data'].forEach((v) {
        bidderData?.add(BidderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (postRequestDetail != null) {
      map['post_request_detail'] = postRequestDetail?.toJson();
    }
    if (bidderData != null) {
      map['bider_data'] = bidderData?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
