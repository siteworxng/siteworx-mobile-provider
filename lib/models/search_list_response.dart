import 'package:provider/models/pagination_model.dart';
import 'package:provider/models/service_model.dart';

class SearchListResponse {
  List<ServiceData>? data;
  int? max;
  int? min;
  Pagination? pagination;

  SearchListResponse({this.data, this.max, this.min, this.pagination});

  factory SearchListResponse.fromJson(Map<String, dynamic> json) {
    return SearchListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => ServiceData.fromJson(i)).toList() : null,
      max: json['max'],
      min: json['min'],
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    data['max'] = this.max;
    data['min'] = this.min;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
