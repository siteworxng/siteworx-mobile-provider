import '../../../models/service_model.dart';

class PostJobData {
  num? id;
  String? title;
  String? description;
  String? reason;
  num? price;
  num? jobPrice;
  num? providerId;
  num? customerId;
  String? status;
  String? createdAt;
  bool? canBid;
  List<ServiceData>? service;

  PostJobData({
    this.id,
    this.title,
    this.description,
    this.reason,
    this.price,
    this.providerId,
    this.customerId,
    this.status,
    this.canBid,
    this.service,
    this.jobPrice,
    this.createdAt,
  });

  PostJobData.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    reason = json['reason'];
    price = json['price'];
    jobPrice = json['job_price'];
    providerId = json['provider_id'];
    customerId = json['customer_id'];
    status = json['status'];
    canBid = json['can_bid'];
    createdAt = json['created_at'];
    if (json['service'] != null) {
      service = [];
      json['service'].forEach((v) {
        service?.add(ServiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['reason'] = reason;
    map['price'] = price;
    map['job_price'] = jobPrice;
    map['provider_id'] = providerId;
    map['customer_id'] = customerId;
    map['status'] = status;
    map['can_bid'] = canBid;
    map['created_at'] = createdAt;
    if (service != null) {
      map['service'] = service?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
