import 'package:provider/models/pagination_model.dart';

class ServiceAddressesResponse {
  Pagination? pagination;
  List<AddressResponse>? addressResponse;

  ServiceAddressesResponse({this.pagination, this.addressResponse});

  ServiceAddressesResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      addressResponse = [];
      json['data'].forEach((v) {
        addressResponse!.add(new AddressResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.addressResponse != null) {
      data['data'] = this.addressResponse!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressResponse {
  int? id;
  int? providerId;
  String? latitude;
  String? longitude;
  int? status;
  String? address;
  String? providerName;
  bool? isSelected;

  AddressResponse({this.id, this.providerId, this.latitude, this.longitude, this.status, this.address, this.providerName, this.isSelected});

  AddressResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    address = json['address'];
    providerName = json['provider_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['address'] = this.address;
    data['provider_name'] = this.providerName;
    return data;
  }
}
