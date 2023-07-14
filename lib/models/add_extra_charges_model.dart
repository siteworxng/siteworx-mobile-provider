class AddExtraChargesModel {
  String? title;
  num? price;
  num? qty;

  AddExtraChargesModel({this.title, this.price, this.qty});

  AddExtraChargesModel.fromJson(dynamic json) {
    title = json['title'];
    price = json['price'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['price'] = price;
    map['qty'] = qty;
    return map;
  }
}
