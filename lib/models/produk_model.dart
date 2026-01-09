import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ProdukModel {

  const ProdukModel({
    required this.id,
    required this.file,
    required this.namaProduk,
    required this.keterangan,
    required this.createdDate,
    required this.bprId,
  });

  final int id;
  final String file;
  final String namaProduk;
  final String keterangan;
  final String createdDate;
  final String bprId;

  factory ProdukModel.fromJson(Map<String,dynamic> json) => ProdukModel(
    id: json['id'] as int,
    file: json['file'].toString(),
    namaProduk: json['nama_produk'].toString(),
    keterangan: json['keterangan'].toString(),
    createdDate: json['createdDate'].toString(),
    bprId: json['bpr_id'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'file': file,
    'nama_produk': namaProduk,
    'keterangan': keterangan,
    'createdDate': createdDate,
    'bpr_id': bprId
  };

  ProdukModel clone() => ProdukModel(
    id: id,
    file: file,
    namaProduk: namaProduk,
    keterangan: keterangan,
    createdDate: createdDate,
    bprId: bprId
  );


  ProdukModel copyWith({
    int? id,
    String? file,
    String? namaProduk,
    String? keterangan,
    String? createdDate,
    String? bprId
  }) => ProdukModel(
    id: id ?? this.id,
    file: file ?? this.file,
    namaProduk: namaProduk ?? this.namaProduk,
    keterangan: keterangan ?? this.keterangan,
    createdDate: createdDate ?? this.createdDate,
    bprId: bprId ?? this.bprId,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is ProdukModel && id == other.id && file == other.file && namaProduk == other.namaProduk && keterangan == other.keterangan && createdDate == other.createdDate && bprId == other.bprId;

  @override
  int get hashCode => id.hashCode ^ file.hashCode ^ namaProduk.hashCode ^ keterangan.hashCode ^ createdDate.hashCode ^ bprId.hashCode;
}
