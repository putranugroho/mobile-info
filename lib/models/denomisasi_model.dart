import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class DenomisasiModel {

  const DenomisasiModel({
    required this.id,
    required this.nominal,
    required this.namaNominal,
    required this.isDeleted,
  });

  final int id;
  final String nominal;
  final String namaNominal;
  final String isDeleted;

  factory DenomisasiModel.fromJson(Map<String,dynamic> json) => DenomisasiModel(
    id: json['id'] as int,
    nominal: json['nominal'].toString(),
    namaNominal: json['nama_nominal'].toString(),
    isDeleted: json['is_deleted'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nominal': nominal,
    'nama_nominal': namaNominal,
    'is_deleted': isDeleted
  };

  DenomisasiModel clone() => DenomisasiModel(
    id: id,
    nominal: nominal,
    namaNominal: namaNominal,
    isDeleted: isDeleted
  );


  DenomisasiModel copyWith({
    int? id,
    String? nominal,
    String? namaNominal,
    String? isDeleted
  }) => DenomisasiModel(
    id: id ?? this.id,
    nominal: nominal ?? this.nominal,
    namaNominal: namaNominal ?? this.namaNominal,
    isDeleted: isDeleted ?? this.isDeleted,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is DenomisasiModel && id == other.id && nominal == other.nominal && namaNominal == other.namaNominal && isDeleted == other.isDeleted;

  @override
  int get hashCode => id.hashCode ^ nominal.hashCode ^ namaNominal.hashCode ^ isDeleted.hashCode;
}
