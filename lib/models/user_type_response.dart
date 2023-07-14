import 'package:provider/models/pagination_model.dart';

class UserTypeResponse {
  List<UserTypeData>? userTypeData;
  Pagination? pagination;

  UserTypeResponse({this.userTypeData, this.pagination});

  factory UserTypeResponse.fromJson(Map<String, dynamic> json) {
    return UserTypeResponse(
      userTypeData: json['data'] != null ? (json['data'] as List).map((i) => UserTypeData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userTypeData != null) {
      data['data'] = this.userTypeData!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class UserTypeData {
  String? createdAt;
  int? id;
  String? name;
  String? updatedAt;

  UserTypeData({this.createdAt, this.id, this.name, this.updatedAt});

  factory UserTypeData.fromJson(Map<String, dynamic> json) {
    return UserTypeData(
      createdAt: json['created_at'],
      id: json['id'],
      name: json['name'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
