import 'dart:convert';

class ConfigurationResponse {
  List<Configurations>? configurations;
  List<PaymentSetting>? paymentSettings;

  ConfigurationResponse({
    this.paymentSettings,
    this.configurations,
  });

  ConfigurationResponse.fromJson(Map<String, dynamic> json) {
    configurations = json['configurations'] != null ? (json['configurations'] as List).map((i) => Configurations.fromJson(i)).toList() : null;
    paymentSettings = json['payment_settings'] != null ? (json['payment_settings'] as List).map((i) => PaymentSetting.fromJson(i)).toList() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.configurations != null) {
      data['configurations'] = this.configurations!.map((v) => v.toJson()).toList();
    }

    if (this.paymentSettings != null) {
      data['payment_settings'] = this.paymentSettings!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class LiveValue {
  /// For Stripe
  String? stripeUrl;
  String? stripeKey;
  String? stripePublickey;

  /// For Razor Pay
  String? razorUrl;
  String? razorKey;
  String? razorSecret;

  /// For Flutter Wave
  String? flutterwavePublic;
  String? flutterwaveSecret;
  String? flutterwaveEncryption;

  /// For PayStack
  String? paypalUrl;

  /// For Sadad
  String? sadadId;
  String? sadadKey;
  String? sadadDomain;

  /// For CinetPay
  String? cinetId;
  String? cinetKey;
  String? cinetPublicKey;

  LiveValue({
    this.stripeUrl,
    this.stripeKey,
    this.stripePublickey,
    this.razorUrl,
    this.razorKey,
    this.razorSecret,
    this.flutterwavePublic,
    this.flutterwaveSecret,
    this.flutterwaveEncryption,
    this.paypalUrl,
    this.sadadId,
    this.sadadKey,
    this.sadadDomain,
    this.cinetId,
    this.cinetKey,
    this.cinetPublicKey,
  });

  factory LiveValue.fromJson(Map<String, dynamic> json) {
    return LiveValue(
      stripeUrl: json['stripe_url'],
      stripeKey: json['stripe_key'],
      stripePublickey: json['stripe_publickey'],
      razorUrl: json['razor_url'],
      razorKey: json['razor_key'],
      razorSecret: json['razor_secret'],
      flutterwavePublic: json['flutterwave_public'],
      flutterwaveSecret: json['flutterwave_secret'],
      flutterwaveEncryption: json['flutterwave_encryption'],
      paypalUrl: json['paypal_url'],
      sadadId: json['sadad_id'],
      sadadKey: json['sadad_key'],
      sadadDomain: json['sadad_domain'],
      cinetId: json['cinet_id'],
      cinetKey: json['cinet_key'],
      cinetPublicKey: json['cinet_publickey'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stripe_url'] = this.stripeUrl;
    data['stripe_key'] = this.stripeKey;
    data['stripe_publickey'] = this.stripePublickey;
    data['razor_url'] = this.razorUrl;
    data['razor_key'] = this.razorKey;
    data['razor_secret'] = this.razorSecret;
    data['flutterwave_public'] = this.flutterwavePublic;
    data['flutterwave_secret'] = this.flutterwaveSecret;
    data['flutterwave_encryption'] = this.flutterwaveEncryption;
    data['paypal_url'] = this.paypalUrl;
    data['sadad_id'] = this.sadadId;
    data['sadad_key'] = this.sadadKey;
    data['sadad_domain'] = this.sadadDomain;
    data['cinet_id'] = this.cinetId;
    data['cinet_key'] = this.cinetKey;
    data['cinet_publickey'] = this.cinetPublicKey;

    return data;
  }
}

class PaymentSetting {
  int? id;
  int? isTest;
  LiveValue? liveValue;
  int? status;
  String? title;
  String? type;
  LiveValue? testValue;

  PaymentSetting({this.id, this.isTest, this.liveValue, this.status, this.title, this.type, this.testValue});

  static String encode(List<PaymentSetting> paymentList) {
    return json.encode(paymentList.map<Map<String, dynamic>>((payment) => payment.toJson()).toList());
  }

  static List<PaymentSetting> decode(String musics) {
    return (json.decode(musics) as List<dynamic>).map<PaymentSetting>((item) => PaymentSetting.fromJson(item)).toList();
  }

  factory PaymentSetting.fromJson(Map<String, dynamic> json) {
    return PaymentSetting(
      id: json['id'],
      isTest: json['is_test'],
      liveValue: json['live_value'] != null ? LiveValue.fromJson(json['live_value']) : null,
      status: json['status'],
      title: json['title'],
      type: json['type'],
      testValue: json['value'] != null ? LiveValue.fromJson(json['value']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_test'] = this.isTest;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.liveValue != null) {
      data['live_value'] = this.liveValue?.toJson();
    }
    if (this.testValue != null) {
      data['value'] = this.testValue?.toJson();
    }
    return data;
  }
}

class Configurations {
  Country? country;
  int? id;
  String? key;
  String? type;
  String? value;

  Configurations({this.country, this.id, this.key, this.type, this.value});

  factory Configurations.fromJson(Map<String, dynamic> json) {
    return Configurations(
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      id: json['id'],
      key: json['key'],
      type: json['type'],
      value: json['value'] != null ? json['value'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['type'] = this.type;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.value != null) {
      data['value'] = this.value;
    }
    return data;
  }
}

class Country {
  int? id;
  String? code;
  String? name;
  int? dialCode;
  String? currencyName;
  String? symbol;
  String? currencyCode;

  Country({this.id, this.code, this.name, this.dialCode, this.currencyName, this.symbol, this.currencyCode});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    dialCode = json['dial_code'];
    currencyName = json['currency_name'];
    symbol = json['symbol'];
    currencyCode = json['currency_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['dial_code'] = this.dialCode;
    data['currency_name'] = this.currencyName;
    data['symbol'] = this.symbol;
    data['currency_code'] = this.currencyCode;
    return data;
  }
}
