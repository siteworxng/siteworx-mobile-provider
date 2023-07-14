class GooglePlacesModel {
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  GooglePlacesModel({this.description, this.matchedSubstrings, this.placeId, this.reference, this.structuredFormatting, this.terms, this.types});

  factory GooglePlacesModel.fromJson(Map<String, dynamic> json) {
    return GooglePlacesModel(
      description: json['description'],
      matchedSubstrings: json['matched_substrings'] != null ? (json['matched_substrings'] as List).map((i) => MatchedSubstring.fromJson(i)).toList() : null,
      placeId: json['place_id'],
      reference: json['reference'],
      structuredFormatting: json['structured_formatting'] != null ? StructuredFormatting.fromJson(json['structured_formatting']) : null,
      terms: json['terms'] != null ? (json['terms'] as List).map((i) => Term.fromJson(i)).toList() : null,
      types: json['types'] != null ? new List<String>.from(json['types']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    if (this.matchedSubstrings != null) {
      data['matched_substrings'] = this.matchedSubstrings!.map((v) => v.toJson()).toList();
    }
    if (this.structuredFormatting != null) {
      data['structured_formatting'] = this.structuredFormatting!.toJson();
    }
    if (this.terms != null) {
      data['terms'] = this.terms!.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['types'] = this.types;
    }
    return data;
  }
}

class Term {
  int? offset;
  String? value;

  Term({this.offset, this.value});

  factory Term.fromJson(Map<String, dynamic> json) {
    return Term(
      offset: json['offset'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offset'] = this.offset;
    data['value'] = this.value;
    return data;
  }
}

class MatchedSubstring {
  int? length;
  int? offset;

  MatchedSubstring({this.length, this.offset});

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['offset'] = this.offset;
    return data;
  }
}

class StructuredFormatting {
  String? mainText;
  List<MainTextMatchedSubstring>? mainTextMatchedSubstrings;
  String? secondaryText;

  StructuredFormatting({this.mainText, this.mainTextMatchedSubstrings, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'],
      mainTextMatchedSubstrings: json['main_text_matched_substrings'] != null ? (json['main_text_matched_substrings'] as List).map((i) => MainTextMatchedSubstring.fromJson(i)).toList() : null,
      secondaryText: json['secondary_text'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_text'] = this.mainText;
    data['secondary_text'] = this.secondaryText;
    if (this.mainTextMatchedSubstrings != null) {
      data['main_text_matched_substrings'] = this.mainTextMatchedSubstrings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainTextMatchedSubstring {
  int? length;
  int? offset;

  MainTextMatchedSubstring({this.length, this.offset});

  factory MainTextMatchedSubstring.fromJson(Map<String, dynamic> json) {
    return MainTextMatchedSubstring(
      length: json['length'],
      offset: json['offset'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['length'] = this.length;
    data['offset'] = this.offset;
    return data;
  }
}
