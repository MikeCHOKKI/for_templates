import 'dart:convert';

import 'package:flutter/foundation.dart';

class GoogleMapAddressComponent {
  String? long_name;
  String? short_name;
  List<String>? types;
  GoogleMapAddressComponent({
    this.long_name,
    this.short_name,
    this.types,
  });

  GoogleMapAddressComponent copyWith({
    String? long_name,
    String? short_name,
    List<String>? types,
  }) {
    return GoogleMapAddressComponent(
      long_name: long_name ?? this.long_name,
      short_name: short_name ?? this.short_name,
      types: types ?? this.types,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (long_name != null) {
      result.addAll({'long_name': long_name});
    }
    if (short_name != null) {
      result.addAll({'short_name': short_name});
    }
    if (types != null) {
      result.addAll({'types': types});
    }

    return result;
  }

  factory GoogleMapAddressComponent.fromMap(Map<String, dynamic> map) {
    return GoogleMapAddressComponent(
      long_name: map['long_name'],
      short_name: map['short_name'],
      types: List<String>.from(map['types']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GoogleMapAddressComponent.fromJson(String source) => GoogleMapAddressComponent.fromMap(json.decode(source));

  @override
  String toString() => 'GoogleMapAddressComponent(long_name: $long_name, short_name: $short_name, types: $types)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoogleMapAddressComponent &&
        other.long_name == long_name &&
        other.short_name == short_name &&
        listEquals(other.types, types);
  }

  @override
  int get hashCode => long_name.hashCode ^ short_name.hashCode ^ types.hashCode;
}
