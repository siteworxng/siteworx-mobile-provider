import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/pagination_model.dart';
import 'package:provider/models/tax_list_response.dart';

import 'Package_response.dart';
import 'extra_charges_model.dart';

class PaymentListResponse {
  Pagination? pagination;
  List<PaymentData>? data;

  PaymentListResponse({this.pagination, this.data});

  PaymentListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = (json['data'] as List).map((i) => PaymentData.fromJson(i)).toList();
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

class PaymentData {
  int? id;
  int? bookingId;
  int? customerId;
  num? totalAmount;
  String? paymentStatus;
  String? paymentMethod;
  String? customerName;
  int? quantity;
  CouponData? couponData;
  List<TaxData>? taxes;
  num? discount;
  num? price;
  List<ExtraChargesModel>? extraCharges;
  PackageData? packageData;

  bool get isPackageBooking => packageData != null ? true : false;
  String? date;

  PaymentData({
    this.id,
    this.bookingId,
    this.customerId,
    this.totalAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.customerName,
    this.quantity,
    this.couponData,
    this.taxes,
    this.discount,
    this.price,
    this.extraCharges,
    this.date,
  });

  PaymentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    customerId = json['customer_id'];
    totalAmount = json['total_amount'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    customerName = json['customer_name'];
    quantity = json['quantity'];
    taxes = json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null;
    couponData = json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null;
    packageData = json['booking_package'] != null ? PackageData.fromJson(json['booking_package']) : null;
    discount = json['discount'];
    price = json['price'];
    date = json['date'];
    extraCharges = json['extra_charges'] != null ? (json['extra_charges'] as List).map((i) => ExtraChargesModel.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['customer_id'] = this.customerId;
    data['total_amount'] = this.totalAmount;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['customer_name'] = this.customerName;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['price'] = this.price;
    data['date'] = this.date;
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    if (this.packageData != null) {
      data['booking_package'] = this.packageData!.toJson();
    }
    if (this.extraCharges != null) {
      data['extra_charges'] = this.extraCharges!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
