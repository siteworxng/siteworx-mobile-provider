import 'package:provider/models/Package_response.dart';
import 'package:provider/models/attachment_model.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/extra_charges_model.dart';
import 'package:provider/models/pagination_model.dart';
import 'package:provider/models/tax_list_response.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

class BookingListResponse {
  List<BookingData>? data;
  Pagination? pagination;

  BookingListResponse({required this.data, required this.pagination});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => BookingData.fromJson(i)).toList() : null,
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class BookingData {
  int? id;
  String? address;
  int? customerId;
  int? serviceId;
  int? providerId;
  num? price;
  int? quantity;
  String? type;
  num? discount;
  num? amount;
  String? status;
  String? statusLabel;
  String? description;
  String? bookingSlot;
  String? providerName;
  String? customerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;
  String? date;
  String? durationDiff;
  int? paymentId;
  int? bookingAddressId;
  List<TaxData>? taxes;
  num? totalAmount;
  num? paidAmount;

  String? durationDiffHour;
  List<Handyman>? handyman;
  List<String>? imageAttachments;
  List<Attachments>? serviceAttachments;
  CouponData? couponData;
  num? totalCalculatedPrice;

  int? totalReview;
  num? totalRating;
  int? isCancelled;
  String? reason;
  String? startAt;
  String? endAt;
  List<ExtraChargesModel>? extraCharges;
  String? bookingType;
  PackageData? bookingPackage;

  //Local
  double get totalAmountWithExtraCharges => totalAmount.validate() + extraCharges.validate().sumByDouble((e) => e.qty.validate() * e.price.validate());

  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isFreeService => price.validate() == 0;

  bool get isPostJob => bookingType == BOOKING_TYPE_USER_POST_JOB;

  bool get isPackageBooking => bookingPackage != null ? true : false;

  bool get isAdvancePaymentDone => paidAmount.validate() != 0;

  bool get canCustomerContact =>
      status != BookingStatusKeys.pending &&
      status != BookingStatusKeys.cancelled &&
      status != BookingStatusKeys.failed &&
      status != BookingStatusKeys.rejected &&
      status != BookingStatusKeys.waitingAdvancedPayment;

  BookingData({
    this.address,
    this.imageAttachments,
    this.customerId,
    this.bookingSlot,
    this.customerName,
    this.date,
    this.description,
    this.discount,
    this.amount,
    this.durationDiff,
    this.durationDiffHour,
    this.handyman,
    this.couponData,
    this.id,
    this.paymentId,
    this.paymentMethod,
    this.paymentStatus,
    this.price,
    this.providerId,
    this.providerName,
    //this.serviceAttachments,
    this.taxes,
    this.serviceId,
    this.serviceName,
    this.status,
    this.statusLabel,
    this.type,
    this.quantity,
    this.totalCalculatedPrice,
    this.bookingAddressId,
    this.totalAmount,
    this.totalReview,
    this.totalRating,
    this.isCancelled,
    this.reason,
    this.startAt,
    this.endAt,
    this.extraCharges,
    this.bookingType,
    this.bookingPackage,
    this.paidAmount,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      address: json['address'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: json['discount'],
      amount: json['amount'],
      bookingSlot: json['booking_slot'],
      durationDiff: json['duration_diff'],
      durationDiffHour: json['duration_diff_hour'],
      handyman: json['handyman'] != null ? (json['handyman'] as List).map((i) => Handyman.fromJson(i)).toList() : [],
      id: json['id'],
      paymentId: json['payment_id'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
      price: json['price'],
      providerId: json['provider_id'],
      providerName: json['provider_name'],
      // service_attchments: json['service_attchments'] != null ? (json['service_attchments'] as List).map((i) => Attachments.fromJson(i)).toList() : null,
      //  image_attchments :json['attchments'],
      imageAttachments: json['service_attchments'] != null ? List<String>.from(json['service_attchments']) : null,
      //service_attchments: json['service_attchments'] != null ? new List<String>.from(json['service_attchments']) : null,
      taxes: json['taxes'] != null ? (json['taxes'] as List).map((i) => TaxData.fromJson(i)).toList() : null,
      couponData: json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null,
      serviceId: json['service_id'],
      serviceName: json['service_name'],
      status: json['status'],
      statusLabel: json['status_label'],
      quantity: json['quantity'],
      type: json['type'],
      bookingAddressId: json['booking_address_id'],
      totalAmount: json['total_amount'],
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      isCancelled: json['is_cancelled'],
      reason: json['reason'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      extraCharges: json['extra_charges'] != null ? (json['extra_charges'] as List).map((i) => ExtraChargesModel.fromJson(i)).toList() : null,
      bookingType: json['booking_type'],
      bookingPackage: json['booking_package'] != null ? PackageData.fromJson(json['booking_package']) : null,
      paidAmount: json[AdvancePaymentKey.advancePaidAmount],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['date'] = this.date;
    data['discount'] = this.discount;
    data['amount'] = this.amount;
    data['duration_diff'] = this.durationDiff;
    data['id'] = this.id;
    data['booking_slot'] = this.bookingSlot;
    data['price'] = this.price;
    data['provider_id'] = this.providerId;
    data['provider_name'] = this.providerName;
    data['service_id'] = this.serviceId;
    data['service_name'] = this.serviceName;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['type'] = this.type;
    data['address'] = this.address;
    data['description'] = this.description;
    data['duration_diff_hour'] = this.durationDiffHour;
    data['handyman'] = this.handyman;
    data['payment_id'] = this.paymentId;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    // data['service_attchments'] = this.service_attchments;
    //  data['attchments'] = this.image_attchments;
    if (this.imageAttachments != null) {
      data['service_attchments'] = this.imageAttachments;
    }
    /* if (this.service_attchments != null) {
      data['service_attchments'] = this.service_attchments!.map((v) => v.toJson()).toList();
    }*/
    data['booking_address_id'] = this.bookingAddressId;
    data['quantity'] = this.quantity;
    if (this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (this.couponData != null) {
      data['coupon_data'] = this.couponData!.toJson();
    }
    data['total_amount'] = this.totalAmount;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['reason'] = this.reason;
    data['is_cancelled'] = this.isCancelled;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    if (this.extraCharges != null) {
      data['extra_charges'] = this.extraCharges!.map((v) => v.toJson()).toList();
    }
    data['booking_type'] = this.bookingType;
    data[AdvancePaymentKey.advancePaidAmount] = this.amount;
    if (bookingPackage != null) {
      data['booking_package'] = this.bookingPackage!.toJson();
    }
    return data;
  }
}

class Handyman {
  int? id;
  int? bookingId;
  int? handymanId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  UserData? handyman;

  Handyman({this.id, this.bookingId, this.handymanId, this.createdAt, this.updatedAt, this.deletedAt, this.handyman});

  Handyman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['booking_id'];
    handymanId = json['handyman_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    handyman = json['handyman'] != null ? new UserData.fromJson(json['handyman']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['booking_id'] = this.bookingId;
    data['handyman_id'] = this.handymanId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    if (this.handyman != null) {
      data['handyman'] = this.handyman!.toJson();
    }
    return data;
  }
}
