import 'package:nb_utils/nb_utils.dart';

class Pagination {
  var currentPage;
  var totalPages;
  var totalItems;

  Pagination({this.totalPages, this.totalItems, this.currentPage});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: json['totalPages'] != null ? json['totalPages'].toString().toInt() : null,
      totalItems: json['total_items'] != null ? json['total_items'].toString().toInt() : null,
      currentPage: json['currentPage'] != null ? json['currentPage'].toString().toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['totalPages'] = this.totalPages;
    data['total_items'] = this.totalItems;
    data['currentPage'] = this.currentPage;
    return data;
  }
}
