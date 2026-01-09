import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class StreamingModel {

  const StreamingModel({
    required this.id,
    required this.nama,
    required this.code,
    required this.isDeleted,
  });

  final String id;
  final String nama;
  final String code;
  final String isDeleted;

  factory StreamingModel.fromJson(Map<String,dynamic> json) => StreamingModel(
    id: json['id'].toString(),
    nama: json['nama'].toString(),
    code: json['code'].toString(),
    isDeleted: json['is_deleted'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'code': code,
    'is_deleted': isDeleted
  };

  StreamingModel clone() => StreamingModel(
    id: id,
    nama: nama,
    code: code,
    isDeleted: isDeleted
  );


  StreamingModel copyWith({
    String? id,
    String? nama,
    String? code,
    String? isDeleted
  }) => StreamingModel(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    code: code ?? this.code,
    isDeleted: isDeleted ?? this.isDeleted,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is StreamingModel && id == other.id && nama == other.nama && code == other.code && isDeleted == other.isDeleted;

  @override
  int get hashCode => id.hashCode ^ nama.hashCode ^ code.hashCode ^ isDeleted.hashCode;
}
