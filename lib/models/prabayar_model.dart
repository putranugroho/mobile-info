import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class PrabayarModel {

  const PrabayarModel({
    required this.status,
    required this.iconUrl,
    required this.pulsaCode,
    required this.pulsaOp,
    required this.pulsaNominal,
    required this.pulsaDetails,
    required this.pulsaPrice,
    required this.pulsaType,
    required this.masaaktif,
    required this.pulsaCategory,
  });

  final String status;
  final String iconUrl;
  final String pulsaCode;
  final String pulsaOp;
  final String pulsaNominal;
  final String pulsaDetails;
  final int pulsaPrice;
  final String pulsaType;
  final String masaaktif;
  final String pulsaCategory;

  factory PrabayarModel.fromJson(Map<String,dynamic> json) => PrabayarModel(
    status: json['status'].toString(),
    iconUrl: json['icon_url'].toString(),
    pulsaCode: json['pulsa_code'].toString(),
    pulsaOp: json['pulsa_op'].toString(),
    pulsaNominal: json['pulsa_nominal'].toString(),
    pulsaDetails: json['pulsa_details'].toString(),
    pulsaPrice: json['pulsa_price'] as int,
    pulsaType: json['pulsa_type'].toString(),
    masaaktif: json['masaaktif'].toString(),
    pulsaCategory: json['pulsa_category'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'status': status,
    'icon_url': iconUrl,
    'pulsa_code': pulsaCode,
    'pulsa_op': pulsaOp,
    'pulsa_nominal': pulsaNominal,
    'pulsa_details': pulsaDetails,
    'pulsa_price': pulsaPrice,
    'pulsa_type': pulsaType,
    'masaaktif': masaaktif,
    'pulsa_category': pulsaCategory
  };

  PrabayarModel clone() => PrabayarModel(
    status: status,
    iconUrl: iconUrl,
    pulsaCode: pulsaCode,
    pulsaOp: pulsaOp,
    pulsaNominal: pulsaNominal,
    pulsaDetails: pulsaDetails,
    pulsaPrice: pulsaPrice,
    pulsaType: pulsaType,
    masaaktif: masaaktif,
    pulsaCategory: pulsaCategory
  );


  PrabayarModel copyWith({
    String? status,
    String? iconUrl,
    String? pulsaCode,
    String? pulsaOp,
    String? pulsaNominal,
    String? pulsaDetails,
    int? pulsaPrice,
    String? pulsaType,
    String? masaaktif,
    String? pulsaCategory
  }) => PrabayarModel(
    status: status ?? this.status,
    iconUrl: iconUrl ?? this.iconUrl,
    pulsaCode: pulsaCode ?? this.pulsaCode,
    pulsaOp: pulsaOp ?? this.pulsaOp,
    pulsaNominal: pulsaNominal ?? this.pulsaNominal,
    pulsaDetails: pulsaDetails ?? this.pulsaDetails,
    pulsaPrice: pulsaPrice ?? this.pulsaPrice,
    pulsaType: pulsaType ?? this.pulsaType,
    masaaktif: masaaktif ?? this.masaaktif,
    pulsaCategory: pulsaCategory ?? this.pulsaCategory,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is PrabayarModel && status == other.status && iconUrl == other.iconUrl && pulsaCode == other.pulsaCode && pulsaOp == other.pulsaOp && pulsaNominal == other.pulsaNominal && pulsaDetails == other.pulsaDetails && pulsaPrice == other.pulsaPrice && pulsaType == other.pulsaType && masaaktif == other.masaaktif && pulsaCategory == other.pulsaCategory;

  @override
  int get hashCode => status.hashCode ^ iconUrl.hashCode ^ pulsaCode.hashCode ^ pulsaOp.hashCode ^ pulsaNominal.hashCode ^ pulsaDetails.hashCode ^ pulsaPrice.hashCode ^ pulsaType.hashCode ^ masaaktif.hashCode ^ pulsaCategory.hashCode;
}
