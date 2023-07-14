import 'package:provider/models/pagination_model.dart';

class CategoryResponse {
  Pagination? pagination;
  List<CategoryData>? data;

  CategoryResponse({this.pagination, this.data});

  CategoryResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  int? id;
  String? name;
  int? status;
  String? description;
  int? isFeatured;
  String? color;
  String? categoryImage;
  int? categoryId;
  String? categoryExtension;
  String? categoryName;
  int? services;

  CategoryData({this.id, this.name, this.status, this.description, this.isFeatured, this.color, this.categoryImage, this.categoryId, this.categoryExtension, this.categoryName, this.services});

  //CategoryData({this.id, this.name, this.status, this.description, this.isFeatured, this.color, this.categoryImage});

  CategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    description = json['description'];
    isFeatured = json['is_featured'];
    color = json['color'];
    categoryImage = json['category_image'];
    categoryId = json['category_id'];
    categoryExtension = json['category_extension'];
    categoryName = json['category_name'];
    services = json['services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['color'] = this.color;
    data['category_image'] = this.categoryImage;
    data['category_id'] = this.categoryId;
    data['category_extension'] = this.categoryExtension;
    data['category_name'] = this.categoryName;
    data['services'] = this.services;
    return data;
  }
}
