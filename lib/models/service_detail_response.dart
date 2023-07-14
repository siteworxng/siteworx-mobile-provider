import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/service_model.dart';

class ServiceDetailResponse {
  Provider? provider;
  List<RatingData>? ratingData;
  List<ServiceFaq>? serviceFaq;
  ServiceData? serviceDetail;

  ServiceDetailResponse({
    this.provider,
    this.serviceDetail,
    this.ratingData,
    this.serviceFaq,
  });

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      provider: json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      ratingData: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      serviceFaq: json['service_faq'] != null ? (json['service_faq'] as List).map((i) => ServiceFaq.fromJson(i)).toList() : null,
      serviceDetail: json['service_detail'] != null ? ServiceData.fromJson(json['service_detail']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.ratingData != null) {
      data['rating_data'] = this.ratingData!.map((v) => v.toJson()).toList();
    }
    if (this.serviceFaq != null) {
      data['service_faq'] = this.serviceFaq!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    if (this.serviceDetail != null) {
      data['service_detail'] = this.serviceDetail!.toJson();
    }
    return data;
  }
}

class ServiceAddressMapping {
  String? createdAt;
  int? id;
  int? providerAddressId;
  ProviderAddressMapping? providerAddressMapping;
  int? serviceId;
  String? updatedAt;

  ServiceAddressMapping({this.createdAt, this.id, this.providerAddressId, this.providerAddressMapping, this.serviceId, this.updatedAt});

  factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    return ServiceAddressMapping(
      createdAt: json['created_at'],
      id: json['id'],
      providerAddressId: json['provider_address_id'],
      providerAddressMapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null,
      serviceId: json['service_id'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_address_id'] = this.providerAddressId;
    data['service_id'] = this.serviceId;
    if (this.createdAt != null) {
      data['created_at'] = this.createdAt;
    }
    if (this.providerAddressMapping != null) {
      data['provider_address_mapping'] = this.providerAddressMapping!.toJson();
    }
    if (this.updatedAt != null) {
      data['updated_at'] = this.updatedAt;
    }
    return data;
  }
}

class ProviderAddressMapping {
  String? address;
  String? createdAt;
  int? id;
  String? latitude;
  String? longitude;
  int? providerId;
  var status;
  String? updatedAt;

  ProviderAddressMapping({this.address, this.createdAt, this.id, this.latitude, this.longitude, this.providerId, this.status, this.updatedAt});

  factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    return ProviderAddressMapping(
      address: json['address'],
      createdAt: json['created_at'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      providerId: json['provider_id'],
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Provider {
  String? address;
  int? cityId;
  String? cityName;
  String? contactNumber;
  int? countryId;
  String? createdAt;
  String? description;
  String? displayName;
  String? email;
  String? firstName;
  int? id;
  int? isFeatured;
  String? lastName;
  String? lastNotificationSeen;
  String? loginType;
  String? profileImage;
  var providerId;
  String? providerType;
  var providerTypeId;
  var serviceAddressId;
  int? stateId;
  int? status;
  String? timeZone;
  var uid;
  String? updatedAt;
  String? userType;
  String? username;

  Provider({
    this.address,
    this.cityId,
    this.cityName,
    this.contactNumber,
    this.countryId,
    this.createdAt,
    this.description,
    this.displayName,
    this.email,
    this.firstName,
    this.id,
    this.isFeatured,
    this.lastName,
    this.lastNotificationSeen,
    this.loginType,
    this.profileImage,
    this.providerId,
    this.providerType,
    this.providerTypeId,
    this.serviceAddressId,
    this.stateId,
    this.status,
    this.timeZone,
    this.uid,
    this.updatedAt,
    this.userType,
    this.username,
  });

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
      address: json['address'],
      cityId: json['city_id'],
      cityName: json['city_name'],
      contactNumber: json['contact_number'],
      countryId: json['country_id'],
      createdAt: json['created_at'],
      description: json['description'],
      displayName: json['display_name'],
      email: json['email'],
      firstName: json['first_name'],
      id: json['id'],
      isFeatured: json['is_featured'],
      lastName: json['last_name'],
      lastNotificationSeen: json['last_notification_seen'],
      loginType: json['login_type'],
      profileImage: json['profile_image'],
      providerId: json['provider_id'],
      providerType: json['providertype'],
      providerTypeId: json['providertype_id'],
      serviceAddressId: json['service_address_id'],
      stateId: json['state_id'],
      status: json['status'],
      timeZone: json['time_zone'],
      uid: json['uid'],
      updatedAt: json['updated_at'],
      userType: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['created_at'] = this.createdAt;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['id'] = this.id;
    data['is_featured'] = this.isFeatured;
    data['last_name'] = this.lastName;
    data['last_notification_seen'] = this.lastNotificationSeen;
    data['profile_image'] = this.profileImage;
    data['providertype'] = this.providerType;
    data['providertype_id'] = this.providerTypeId;
    data['state_id'] = this.stateId;
    data['status'] = this.status;
    data['time_zone'] = this.timeZone;
    data['updated_at'] = this.updatedAt;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    if (this.description != null) {
      data['description'] = this.description;
    }
    if (this.loginType != null) {
      data['login_type'] = this.loginType;
    }
    if (this.providerId != null) {
      data['provider_id'] = this.providerId;
    }
    if (this.serviceAddressId != null) {
      data['service_address_id'] = this.serviceAddressId.toJson();
    }
    if (this.uid != null) {
      data['uid'] = this.uid.toJson();
    }
    return data;
  }
}

class ServiceFaq {
  String? createdAt;
  String? description;
  int? id;
  int? serviceId;
  int? status;
  String? title;
  String? updatedAt;

  ServiceFaq({this.createdAt, this.description, this.id, this.serviceId, this.status, this.title, this.updatedAt});

  factory ServiceFaq.fromJson(Map<String, dynamic> json) {
    return ServiceFaq(
      createdAt: json['created_at'],
      description: json['description'],
      id: json['id'],
      serviceId: json['service_id'],
      status: json['status'],
      title: json['title'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['title'] = this.title;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
