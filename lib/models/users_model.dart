import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UsersModel {
  const UsersModel({
    required this.id,
    required this.nocif,
    required this.namaLengkap,
    required this.usersId,
    required this.bprId,
    required this.bprLogo,
    required this.bprNama,
    required this.noRekening,
    required this.nomorPonsel,
    required this.noKtp,
    required this.photo,
    required this.createdDate,
  });

  final int id;
  final String nocif;
  final String namaLengkap;
  final String usersId;
  final String bprId;
  final String bprLogo;
  final String bprNama;
  final String noRekening;
  final String nomorPonsel;
  final String noKtp;
  final String photo;
  final String createdDate;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
    id: json['id'] as int,
    nocif: json['nocif'].toString(),
    namaLengkap: json['nama_lengkap'].toString(),
    usersId: json['users_id'].toString(),
    bprId: json['bpr_id'].toString(),
    bprLogo: json['bpr_logo'].toString(),
    bprNama: json['bpr_nama'].toString(),
    noRekening: json['no_rekening'].toString(),
    nomorPonsel: json['nomor_ponsel'].toString(),
    noKtp: json['no_ktp'].toString(),
    photo: json['photo'].toString(),
    createdDate: json['createdDate'].toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nocif': nocif,
    'nama_lengkap': namaLengkap,
    'users_id': usersId,
    'bpr_id': bprId,
    'bpr_logo': bprLogo,
    'bpr_nama': bprNama,
    'no_rekening': noRekening,
    'nomor_ponsel': nomorPonsel,
    'no_ktp': noKtp,
    'photo': photo,
    'createdDate': createdDate,
  };

  UsersModel clone() => UsersModel(
    id: id,
    nocif: nocif,
    namaLengkap: namaLengkap,
    usersId: usersId,
    bprId: bprId,
    bprLogo: bprLogo,
    bprNama: bprNama,
    noRekening: noRekening,
    nomorPonsel: nomorPonsel,
    noKtp: noKtp,
    photo: photo,
    createdDate: createdDate,
  );

  UsersModel copyWith({
    int? id,
    String? nocif,
    String? namaLengkap,
    String? usersId,
    String? bprId,
    String? bprLogo,
    String? bprNama,
    String? noRekening,
    String? nomorPonsel,
    String? noKtp,
    String? photo,
    String? createdDate,
  }) => UsersModel(
    id: id ?? this.id,
    nocif: nocif ?? this.nocif,
    namaLengkap: namaLengkap ?? this.namaLengkap,
    usersId: usersId ?? this.usersId,
    bprId: bprId ?? this.bprId,
    bprLogo: bprLogo ?? this.bprLogo,
    bprNama: bprNama ?? this.bprNama,
    noRekening: noRekening ?? this.noRekening,
    nomorPonsel: nomorPonsel ?? this.nomorPonsel,
    noKtp: noKtp ?? this.noKtp,
    photo: photo ?? this.photo,
    createdDate: createdDate ?? this.createdDate,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersModel &&
          id == other.id &&
          nocif == other.nocif &&
          namaLengkap == other.namaLengkap &&
          usersId == other.usersId &&
          bprId == other.bprId &&
          bprLogo == other.bprLogo &&
          bprNama == other.bprNama &&
          noRekening == other.noRekening &&
          nomorPonsel == other.nomorPonsel &&
          noKtp == other.noKtp &&
          photo == other.photo &&
          createdDate == other.createdDate;

  @override
  int get hashCode =>
      id.hashCode ^
      nocif.hashCode ^
      namaLengkap.hashCode ^
      usersId.hashCode ^
      bprId.hashCode ^
      bprLogo.hashCode ^
      bprNama.hashCode ^
      noRekening.hashCode ^
      nomorPonsel.hashCode ^
      noKtp.hashCode ^
      photo.hashCode ^
      createdDate.hashCode;
}
