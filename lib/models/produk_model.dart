import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class ProdukModel {
  final int id;
  final String file;
  final String namaProduk;
  final String keterangan;
  final String bprId;

  final String? fhotoBase64;
  final String? kodePrd;
  final String? jnsPrd;
  final String? status;

  ProdukModel({
    required this.id,
    required this.file,
    required this.namaProduk,
    required this.keterangan,
    required this.bprId,
    this.fhotoBase64,
    this.kodePrd,
    this.jnsPrd,
    this.status,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'] ?? json['ID'] ?? 0,
      file: json['file']?.toString() ?? '',
      namaProduk: json['nama_produk']?.toString() ?? json['Judul']?.toString() ?? '',
      keterangan: json['keterangan']?.toString() ?? json['Deskripsi']?.toString() ?? '',
      bprId: json['bpr_id']?.toString() ?? '',
      fhotoBase64: json['Fhoto']?.toString(),
      kodePrd: json['KodePrd']?.toString(),
      jnsPrd: json['JnsPrd']?.toString(),
      status: json['Status']?.toString(),
    );
  }
}
