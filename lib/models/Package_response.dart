import 'package:provider/models/attachment_model.dart';
import 'package:provider/models/pagination_model.dart';
import 'package:provider/models/service_model.dart';

class PackageResponse {
  Pagination? pagination;
  List<PackageData>? packageList;

  PackageResponse(this.pagination, this.packageList);

  PackageResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      packageList = [];
      json['data'].forEach((v) {
        packageList!.add(PackageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.packageList != null) {
      data['data'] = this.packageList!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class PackageData {
  int? id;
  String? name;
  String? description;
  num? price;
  String? startDate;
  String? endDate;
  List<ServiceData>? serviceList;
  var isFeatured;
  int? categoryId;
  int? subCategoryId;
  List<Attachments>? attchments;
  List<String>? imageAttachments;
  int? status;
  String? categoryName;
  String? subCategoryName;
  String? packageType;

  PackageData({
    this.id,
    this.name,
    this.description,
    this.price,
    this.startDate,
    this.endDate,
    this.serviceList,
    this.isFeatured,
    this.categoryId,
    this.attchments,
    this.imageAttachments,
    this.status,
    this.categoryName,
    this.packageType,
  });

  PackageData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryName = json['category_name'];
    subCategoryName = json['subcategory_name'];
    description = json['description'];
    price = json['price'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    status = json['status'];
    packageType = json['package_type'];
    serviceList = json['services'] != null ? (json['services'] as List).map((i) => ServiceData.fromJson(i)).toList() : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    categoryId = json['category_id'];
    subCategoryId = json['subcategory_id'];
    isFeatured = json['is_featured'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['subcategory_name'] = this.subCategoryName;
    data['status'] = this.status;
    data['package_type'] = this.packageType;
    if (this.serviceList != null) {
      data['services'] = this.serviceList!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['subcategory_id'] = this.subCategoryId;
    data['is_featured'] = this.isFeatured;
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    if (this.imageAttachments != null) {
      data['attchments'] = this.imageAttachments;
    }
    return data;
  }
}
