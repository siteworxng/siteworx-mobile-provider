import 'package:provider/models/user_data.dart';

class RegisterResponse {
  UserData? data;
  String? message;

  RegisterResponse({this.data, this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class RegisterData {
  String? apiToken;
  String? contactNumber;
  String? displayName;
  String? email;
  String? firstName;
  String? lastName;
  String? userType;
  String? username;
  int? providerId;
  var status;
  String? address;
  String? uid;
  String? password;
  int? id;

  RegisterData({
    this.apiToken,
    this.contactNumber,
    this.displayName,
    this.email,
    this.password,
    this.firstName,
    required this.lastName,
    this.userType,
    required this.username,
    this.providerId,
    this.status,
    this.address,
    this.uid,
    this.id,
  });

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      apiToken: json['api_token'],
      contactNumber: json['contact_number'],
      displayName: json['display_name'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: json['user_type'],
      username: json['username'],
      providerId: json['provider_id'],
      status: json['status'],
      address: json['address'],
      uid: json['uid'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_token'] = this.apiToken;
    data['contact_number'] = this.contactNumber;
    data['display_name'] = this.displayName;
    data['email'] = this.email;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_type'] = this.userType;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['address'] = this.address;
    data['uid'] = this.uid;
    data['id'] = this.id;
    return data;
  }
}
