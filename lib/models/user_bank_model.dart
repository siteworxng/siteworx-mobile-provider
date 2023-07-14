import 'package:provider/models/pagination_model.dart';

class UserBankDetails {
  Pagination? pagination;
  List<BankData>? bankData;

  UserBankDetails({this.pagination, this.bankData});

  UserBankDetails.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      bankData = <BankData>[];
      json['data'].forEach((v) {
        bankData!.add(new BankData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.bankData != null) {
      data['data'] = this.bankData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BankData {
  int? id;
  int? providerId;
  String? bankName;
  String? branchName;
  String? accountNo;
  String? ifscNo;
  String? mobileNo;
  String? aadharNo;
  String? panNo;

  BankData({this.id, this.providerId, this.bankName, this.branchName, this.accountNo, this.ifscNo, this.mobileNo, this.aadharNo, this.panNo});

  BankData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    providerId = json['provider_id'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    accountNo = json['account_no'];
    ifscNo = json['ifsc_no'];
    mobileNo = json['mobile_no'];
    aadharNo = json['aadhar_no'];
    panNo = json['pan_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_id'] = this.providerId;
    data['bank_name'] = this.bankName;
    data['branch_name'] = this.branchName;
    data['account_no'] = this.accountNo;
    data['ifsc_no'] = this.ifscNo;
    data['mobile_no'] = this.mobileNo;
    data['aadhar_no'] = this.aadharNo;
    data['pan_no'] = this.panNo;
    return data;
  }
}
