import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class VaModel {

  const VaModel({
    required this.id,
    required this.bankCode,
    required this.bankName,
    required this.logo,
    required this.type,
    required this.isDeleted,
  });

  final String id;
  final String bankCode;
  final String bankName;
  final dynamic logo;
  final String type;
  final String isDeleted;

  factory VaModel.fromJson(Map<String,dynamic> json) => VaModel(
    id: json['id'].toString(),
    bankCode: json['bank_code'].toString(),
    bankName: json['bank_name'].toString(),
    logo: json['logo'] as dynamic,
    type: json['type'].toString(),
    isDeleted: json['is_deleted'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'bank_code': bankCode,
    'bank_name': bankName,
    'logo': logo,
    'type': type,
    'is_deleted': isDeleted
  };

  VaModel clone() => VaModel(
    id: id,
    bankCode: bankCode,
    bankName: bankName,
    logo: logo,
    type: type,
    isDeleted: isDeleted
  );


  VaModel copyWith({
    String? id,
    String? bankCode,
    String? bankName,
    dynamic? logo,
    String? type,
    String? isDeleted
  }) => VaModel(
    id: id ?? this.id,
    bankCode: bankCode ?? this.bankCode,
    bankName: bankName ?? this.bankName,
    logo: logo ?? this.logo,
    type: type ?? this.type,
    isDeleted: isDeleted ?? this.isDeleted,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is VaModel && id == other.id && bankCode == other.bankCode && bankName == other.bankName && logo == other.logo && type == other.type && isDeleted == other.isDeleted;

  @override
  int get hashCode => id.hashCode ^ bankCode.hashCode ^ bankName.hashCode ^ logo.hashCode ^ type.hashCode ^ isDeleted.hashCode;
}
