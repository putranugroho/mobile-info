import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class PascabayarModel {

  const PascabayarModel({
    required this.code,
    required this.name,
    required this.status,
    required this.fee,
    required this.komisi,
    required this.type,
    required this.category,
  });

  final String code;
  final String name;
  final int status;
  final dynamic fee;
  final int komisi;
  final String type;
  final String category;

  factory PascabayarModel.fromJson(Map<String,dynamic> json) => PascabayarModel(
    code: json['code'].toString(),
    name: json['name'].toString(),
    status: json['status'] as int,
    fee: json['fee'] as dynamic,
    komisi: json['komisi'] as int,
    type: json['type'].toString(),
    category: json['category'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'status': status,
    'fee': fee,
    'komisi': komisi,
    'type': type,
    'category': category
  };

  PascabayarModel clone() => PascabayarModel(
    code: code,
    name: name,
    status: status,
    fee: fee,
    komisi: komisi,
    type: type,
    category: category
  );


  PascabayarModel copyWith({
    String? code,
    String? name,
    int? status,
    dynamic? fee,
    int? komisi,
    String? type,
    String? category
  }) => PascabayarModel(
    code: code ?? this.code,
    name: name ?? this.name,
    status: status ?? this.status,
    fee: fee ?? this.fee,
    komisi: komisi ?? this.komisi,
    type: type ?? this.type,
    category: category ?? this.category,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is PascabayarModel && code == other.code && name == other.name && status == other.status && fee == other.fee && komisi == other.komisi && type == other.type && category == other.category;

  @override
  int get hashCode => code.hashCode ^ name.hashCode ^ status.hashCode ^ fee.hashCode ^ komisi.hashCode ^ type.hashCode ^ category.hashCode;
}
