import 'package:provider/models/Package_response.dart';
import 'package:provider/models/attachment_model.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/service_detail_response.dart';
import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/model_keys.dart';

class ServiceData {
  int? id;
  String? name;
  int? categoryId;
  int? subCategoryId;
  int? providerId;
  num? price;
  var priceFormat;
  String? type;
  num? discount;
  String? duration;
  int? status;
  String? description;
  int? isFeatured;
  String? providerName;
  String? providerImage;
  int? cityId;
  String? categoryName;
  List<String>? imageAttachments;
  List<Attachments>? attchments;
  num? totalReview;
  num? totalRating;
  int? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;

  //Set Values
  num? totalAmount;
  num? discountPrice;
  num? taxAmount;
  num? couponDiscountAmount;
  String? dateTimeVal;
  String? couponId;
  num? qty;
  String? address;
  int? bookingAddressId;
  CouponData? appliedCouponData;
  num? isSlot;
  List<SlotData>? providerSlotData;
  List<PackageData>? servicePackage;
  num? advancePaymentSetting;
  num? isEnableAdvancePayment;
  num? advancePaymentAmount;
  num? advancePaymentPercentage;

  //Local
  bool get isHourlyService => type.validate() == SERVICE_TYPE_HOURLY;

  bool get isFreeService => price.validate() == 0;

  bool get isAdvancePayment => isEnableAdvancePayment.validate() == 1;

  bool get isAdvancePaymentSetting => advancePaymentSetting.validate() == 1;

  String? subCategoryName;

  bool? isSelected;

  ServiceData({
    this.id,
    this.name,
    this.imageAttachments,
    this.providerSlotData,
    this.categoryId,
    this.providerId,
    this.price,
    this.priceFormat,
    this.type,
    this.discount,
    this.duration,
    this.status,
    this.isSlot,
    this.description,
    this.isFeatured,
    this.providerName,
    this.subCategoryId,
    this.providerImage,
    this.cityId,
    this.categoryName,
    this.attchments,
    this.totalReview,
    this.totalRating,
    this.isFavourite,
    this.serviceAddressMapping,
    this.totalAmount,
    this.discountPrice,
    this.taxAmount,
    this.couponDiscountAmount,
    this.dateTimeVal,
    this.couponId,
    this.subCategoryName,
    this.qty,
    this.address,
    this.bookingAddressId,
    this.appliedCouponData,
    this.isSelected,
    this.servicePackage,
    this.advancePaymentSetting,
    this.isEnableAdvancePayment,
    this.advancePaymentAmount,
    this.advancePaymentPercentage,
  });

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    providerImage = json['provider_image'];
    categoryId = json['category_id'];
    subCategoryId = json['subcategory_id'];
    providerId = json['provider_id'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    discount = json['discount'];
    duration = json['duration'];
    status = json['status'];
    isSlot = json['is_slot'];
    description = json['description'];
    isFeatured = json['is_featured'];
    providerName = json['provider_name'];
    cityId = json['city_id'];
    categoryName = json['category_name'];
    //image_attchments = json['attchments'];
    imageAttachments = json['attchments'] != null ? List<String>.from(json['attchments']) : null;
    attchments = json['attchments_array'] != null ? (json['attchments_array'] as List).map((i) => Attachments.fromJson(i)).toList() : null;
    providerSlotData = json['slots'] != null ? (json['slots'] as List).map((i) => SlotData.fromJson(i)).toList() : null;
    subCategoryName = json['subcategory_name'];

    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    isFavourite = json['is_favourite'];

    if (json['service_address_mapping'] != null) {
      serviceAddressMapping = [];
      json['service_address_mapping'].forEach((v) {
        serviceAddressMapping!.add(new ServiceAddressMapping.fromJson(v));
      });
    }
    servicePackage = json['servicePackage'] != null ? (json['servicePackage'] as List).map((i) => PackageData.fromJson(i)).toList() : null;
    advancePaymentSetting = json[AdvancePaymentKey.advancePaymentSetting];
    isEnableAdvancePayment = json[AdvancePaymentKey.isEnableAdvancePayment];
    advancePaymentAmount = json[AdvancePaymentKey.advancePaymentAmount];
    advancePaymentPercentage = json[AdvancePaymentKey.advancePaymentAmount];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['provider_image'] = this.providerImage;
    data['category_id'] = this.categoryId;
    data['provider_id'] = this.providerId;
    data['is_slot'] = this.isSlot;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['status'] = this.status;
    data['description'] = this.description;
    data['is_featured'] = this.isFeatured;
    data['provider_name'] = this.providerName;
    data['city_id'] = this.cityId;
    data['subcategory_id'] = this.subCategoryId;
    data['subcategory_name'] = this.subCategoryName;

    data['category_name'] = this.categoryName;
    if (this.imageAttachments != null) {
      data['attchments'] = this.imageAttachments;
    }
    if (this.providerSlotData != null) {
      data['slots'] = this.providerSlotData;
    }
    if (this.servicePackage != null) {
      data['servicePackage'] = this.servicePackage!.map((v) => v.toJson()).toList();
    }
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['is_favourite'] = this.isFavourite;
    if (this.serviceAddressMapping != null) {
      data['service_address_mapping'] = this.serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    if (this.attchments != null) {
      data['attchments_array'] = this.attchments!.map((v) => v.toJson()).toList();
    }
    data[AdvancePaymentKey.advancePaymentSetting] = this.advancePaymentSetting;
    data[AdvancePaymentKey.isEnableAdvancePayment] = this.isEnableAdvancePayment;
    data[AdvancePaymentKey.advancePaymentAmount] = this.advancePaymentAmount;
    data[AdvancePaymentKey.advancePaymentAmount] = this.advancePaymentPercentage;
    return data;
  }
}
