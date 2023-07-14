class VerifyTransactionResponse {
  TransactionData? transactionData;
  String? message;
  String? status;

  VerifyTransactionResponse({this.transactionData, this.message, this.status});

  factory VerifyTransactionResponse.fromJson(Map<String, dynamic> json) {
    return VerifyTransactionResponse(
      transactionData: json['data'] != null ? TransactionData.fromJson(json['data']) : null,
      message: json['message'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.transactionData != null) {
      data['data'] = this.transactionData!.toJson();
    }
    return data;
  }
}

class TransactionData {
  num? account_id;
  num? amount;
  num? amount_settled;
  num? app_fee;
  String? auth_model;
  Card? card;
  num? charged_amount;
  String? created_at;
  String? currency;
  Customer? customer;
  String? device_fingerprint;
  String? flw_ref;
  num? id;
  String? ip;
  num? merchant_fee;
  Meta? meta;
  String? narration;
  String? payment_type;
  String? processor_response;
  String? status;
  String? tx_ref;

  TransactionData(
      {this.account_id,
      this.amount,
      this.amount_settled,
      this.app_fee,
      this.auth_model,
      this.card,
      this.charged_amount,
      this.created_at,
      this.currency,
      this.customer,
      this.device_fingerprint,
      this.flw_ref,
      this.id,
      this.ip,
      this.merchant_fee,
      this.meta,
      this.narration,
      this.payment_type,
      this.processor_response,
      this.status,
      this.tx_ref});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      account_id: json['account_id'],
      amount: json['amount'],
      amount_settled: json['amount_settled'],
      app_fee: json['app_fee'],
      auth_model: json['auth_model'],
      card: json['card'] != null ? Card.fromJson(json['card']) : null,
      charged_amount: json['charged_amount'],
      created_at: json['created_at'],
      currency: json['currency'],
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      device_fingerprint: json['device_fingerprint'],
      flw_ref: json['flw_ref'],
      id: json['id'],
      ip: json['ip'],
      merchant_fee: json['merchant_fee'],
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      narration: json['narration'],
      payment_type: json['payment_type'],
      processor_response: json['processor_response'],
      status: json['status'],
      tx_ref: json['tx_ref'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account_id'] = this.account_id;
    data['amount'] = this.amount;
    data['amount_settled'] = this.amount_settled;
    data['app_fee'] = this.app_fee;
    data['auth_model'] = this.auth_model;
    data['charged_amount'] = this.charged_amount;
    data['created_at'] = this.created_at;
    data['currency'] = this.currency;
    data['device_fingerprint'] = this.device_fingerprint;
    data['flw_ref'] = this.flw_ref;
    data['id'] = this.id;
    data['ip'] = this.ip;
    data['merchant_fee'] = this.merchant_fee;
    data['narration'] = this.narration;
    data['payment_type'] = this.payment_type;
    data['processor_response'] = this.processor_response;
    data['status'] = this.status;
    data['tx_ref'] = this.tx_ref;
    if (this.card != null) {
      data['card'] = this.card!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Customer {
  String? created_at;
  String? email;
  int? id;
  String? name;
  String? phone_number;

  Customer({this.created_at, this.email, this.id, this.name, this.phone_number});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      created_at: json['created_at'],
      email: json['email'],
      id: json['id'],
      name: json['name'],
      phone_number: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.created_at;
    data['email'] = this.email;
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone_number'] = this.phone_number;
    return data;
  }
}

class Meta {
  String? checkoutInitAddress;

  Meta({this.checkoutInitAddress});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      checkoutInitAddress: json['__CheckoutInitAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['__CheckoutInitAddress'] = this.checkoutInitAddress;
    return data;
  }
}

class Card {
  String? country;
  String? expiry;
  String? first_6digits;
  String? issuer;
  String? last_4digits;
  String? token;
  String? type;

  Card({this.country, this.expiry, this.first_6digits, this.issuer, this.last_4digits, this.token, this.type});

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      country: json['country'],
      expiry: json['expiry'],
      first_6digits: json['first_6digits'],
      issuer: json['issuer'],
      last_4digits: json['last_4digits'],
      token: json['token'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['expiry'] = this.expiry;
    data['first_6digits'] = this.first_6digits;
    data['issuer'] = this.issuer;
    data['last_4digits'] = this.last_4digits;
    data['token'] = this.token;
    data['type'] = this.type;
    return data;
  }
}
