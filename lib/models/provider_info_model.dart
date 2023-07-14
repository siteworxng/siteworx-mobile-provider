import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/user_data.dart';

import 'service_model.dart';

class HandymanInfoResponse {
  UserData? handymanData;
  List<ServiceData>? service;
  List<RatingData>? handymanRatingReview;

  HandymanInfoResponse({this.handymanData, this.service, this.handymanRatingReview});

  HandymanInfoResponse.fromJson(Map<String, dynamic> json) {
    handymanData = json['data'] != null ? new UserData.fromJson(json['data']) : null;
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service!.add(ServiceData.fromJson(v));
      });
    }
    if (json['handyman_rating_review'] != null) {
      handymanRatingReview = [];
      json['handyman_rating_review'].forEach((v) {
        handymanRatingReview!.add(new RatingData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.handymanData != null) {
      data['data'] = this.handymanData!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    if (this.handymanRatingReview != null) {
      data['handyman_rating_review'] = this.handymanRatingReview!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HandymanRatingReview {
  int? id;
  int? customerId;
  num? rating;
  String? review;
  int? serviceId;
  int? bookingId;
  int? handymanId;
  String? handymanName;
  String? handymanProfileImage;
  String? customerName;
  String? customerProfileImage;
  String? createdAt;

  HandymanRatingReview(
      {this.id,
      this.customerId,
      this.rating,
      this.review,
      this.serviceId,
      this.bookingId,
      this.handymanId,
      this.handymanName,
      this.handymanProfileImage,
      this.customerName,
      this.customerProfileImage,
      this.createdAt});

  HandymanRatingReview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    rating = json['rating'];
    review = json['review'];
    serviceId = json['service_id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    handymanName = json['handyman_name'];
    handymanProfileImage = json['handyman_profile_image'];
    customerName = json['customer_name'];
    customerProfileImage = json['customer_profile_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.serviceId;
    data['booking_id'] = this.bookingId;
    data['handyman_id'] = this.handymanId;
    data['handyman_name'] = this.handymanName;
    data['handyman_profile_image'] = this.handymanProfileImage;
    data['customer_name'] = this.customerName;
    data['customer_profile_image'] = this.customerProfileImage;
    data['created_at'] = this.createdAt;
    return data;
  }
}
