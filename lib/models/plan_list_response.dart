import 'package:provider/models/provider_subscription_model.dart';

class PlanListResponse {
  List<ProviderSubscriptionModel>? data;

  PlanListResponse({this.data});

  factory PlanListResponse.fromJson(Map<String, dynamic> json) {
    return PlanListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ProviderSubscriptionModel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
