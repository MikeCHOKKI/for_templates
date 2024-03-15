import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:ou_suis_je/GoogleMapAddressComponent.dart';

class GoogleMapAddress {
  List<GoogleMapAddressComponent>? address_components;
  String? formatted_address;
  GoogleMapAddress({
    this.address_components,
    this.formatted_address,
  });

  GoogleMapAddress copyWith({
    List<GoogleMapAddressComponent>? address_components,
    String? formatted_address,
  }) {
    return GoogleMapAddress(
      address_components: address_components ?? this.address_components,
      formatted_address: formatted_address ?? this.formatted_address,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (address_components != null) {
      result.addAll({'address_components': address_components!.map((x) => x?.toMap()).toList()});
    }
    if (formatted_address != null) {
      result.addAll({'formatted_address': formatted_address});
    }

    return result;
  }

  factory GoogleMapAddress.fromMap(Map<String, dynamic> map) {
    return GoogleMapAddress(
      address_components: map['address_components'] != null
          ? List<GoogleMapAddressComponent>.from(
              map['address_components']?.map((x) => GoogleMapAddressComponent.fromMap(x)))
          : null,
      formatted_address: map['formatted_address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoogleMapAddress.fromJson(String source) => GoogleMapAddress.fromMap(json.decode(source));

  @override
  String toString() =>
      'GoogleMapAddress(address_components: $address_components, formatted_address: $formatted_address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GoogleMapAddress &&
        listEquals(other.address_components, address_components) &&
        other.formatted_address == formatted_address;
  }

  @override
  int get hashCode => address_components.hashCode ^ formatted_address.hashCode;
}
