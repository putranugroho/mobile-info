import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UsersModel {

  const UsersModel({
    required this.id,
    required this.noCif,
    required this.usersId,
    required this.bprId,
    required this.nama,
    required this.tglLahir,
    required this.noIdentitas,
    required this.nomorPonsel,
    required this.bprLogo,
    required this.bprNama,
    required this.perbarindo,
    required this.createdAt,
  });

  final int id;
  final String noCif;
  final String usersId;
  final String bprId;
  final String nama;
  final String tglLahir;
  final String noIdentitas;
  final String nomorPonsel;
  final String bprLogo;
  final String bprNama;
  final String perbarindo;
  final String createdAt;

  factory UsersModel.fromJson(Map<String,dynamic> json) => UsersModel(
    id: json['id'] as int,
    noCif: json['no_cif'].toString(),
    usersId: json['users_id'].toString(),
    bprId: json['bpr_id'].toString(),
    nama: json['nama'].toString(),
    tglLahir: json['tgl_lahir'].toString(),
    noIdentitas: json['no_identitas'].toString(),
    nomorPonsel: json['nomor_ponsel'].toString(),
    bprLogo: json['bpr_logo'].toString(),
    bprNama: json['bpr_nama'].toString(),
    perbarindo: json['perbarindo'].toString(),
    createdAt: json['created_at'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'no_cif': noCif,
    'users_id': usersId,
    'bpr_id': bprId,
    'nama': nama,
    'tgl_lahir': tglLahir,
    'no_identitas': noIdentitas,
    'nomor_ponsel': nomorPonsel,
    'bpr_logo': bprLogo,
    'bpr_nama': bprNama,
    'perbarindo': perbarindo,
    'created_at': createdAt
  };

  UsersModel clone() => UsersModel(
    id: id,
    noCif: noCif,
    usersId: usersId,
    bprId: bprId,
    nama: nama,
    tglLahir: tglLahir,
    noIdentitas: noIdentitas,
    nomorPonsel: nomorPonsel,
    bprLogo: bprLogo,
    bprNama: bprNama,
    perbarindo: perbarindo,
    createdAt: createdAt
  );


  UsersModel copyWith({
    int? id,
    String? noCif,
    String? usersId,
    String? bprId,
    String? nama,
    String? tglLahir,
    String? noIdentitas,
    String? nomorPonsel,
    String? bprLogo,
    String? bprNama,
    String? perbarindo,
    String? createdAt
  }) => UsersModel(
    id: id ?? this.id,
    noCif: noCif ?? this.noCif,
    usersId: usersId ?? this.usersId,
    bprId: bprId ?? this.bprId,
    nama: nama ?? this.nama,
    tglLahir: tglLahir ?? this.tglLahir,
    noIdentitas: noIdentitas ?? this.noIdentitas,
    nomorPonsel: nomorPonsel ?? this.nomorPonsel,
    bprLogo: bprLogo ?? this.bprLogo,
    bprNama: bprNama ?? this.bprNama,
    perbarindo: perbarindo ?? this.perbarindo,
    createdAt: createdAt ?? this.createdAt,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UsersModel && id == other.id && noCif == other.noCif && usersId == other.usersId && bprId == other.bprId && nama == other.nama && tglLahir == other.tglLahir && noIdentitas == other.noIdentitas && nomorPonsel == other.nomorPonsel && bprLogo == other.bprLogo && bprNama == other.bprNama && perbarindo == other.perbarindo && createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ noCif.hashCode ^ usersId.hashCode ^ bprId.hashCode ^ nama.hashCode ^ tglLahir.hashCode ^ noIdentitas.hashCode ^ nomorPonsel.hashCode ^ bprLogo.hashCode ^ bprNama.hashCode ^ perbarindo.hashCode ^ createdAt.hashCode;
}
