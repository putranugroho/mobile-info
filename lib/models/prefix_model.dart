import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class PrefixModel {

  const PrefixModel({
    required this.id,
    required this.provider,
    required this.codeData,
    required this.codePulsa,
    required this.logo,
  });

  final int id;
  final String provider;
  final String codeData;
  final String codePulsa;
  final String logo;

  factory PrefixModel.fromJson(Map<String,dynamic> json) => PrefixModel(
    id: json['id'] as int,
    provider: json['provider'].toString(),
    codeData: json['code_data'].toString(),
    codePulsa: json['code_pulsa'].toString(),
    logo: json['logo'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'provider': provider,
    'code_data': codeData,
    'code_pulsa': codePulsa,
    'logo': logo
  };

  PrefixModel clone() => PrefixModel(
    id: id,
    provider: provider,
    codeData: codeData,
    codePulsa: codePulsa,
    logo: logo
  );


  PrefixModel copyWith({
    int? id,
    String? provider,
    String? codeData,
    String? codePulsa,
    String? logo
  }) => PrefixModel(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    codeData: codeData ?? this.codeData,
    codePulsa: codePulsa ?? this.codePulsa,
    logo: logo ?? this.logo,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is PrefixModel && id == other.id && provider == other.provider && codeData == other.codeData && codePulsa == other.codePulsa && logo == other.logo;

  @override
  int get hashCode => id.hashCode ^ provider.hashCode ^ codeData.hashCode ^ codePulsa.hashCode ^ logo.hashCode;
}
