import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class UserIbprModel {

  const UserIbprModel({
    required this.id,
    required this.usersId,
    required this.namaLengkap,
    required this.nomorPonsel,
    required this.bprId,
    required this.noRekening,
    required this.noKtp,
    required this.photo,
    required this.createdDate,
    required this.bprLogo,
    required this.bprNama,
  });

  final int id;
  final String usersId;
  final String namaLengkap;
  final String nomorPonsel;
  final String bprId;
  final String noRekening;
  final String noKtp;
  final String photo;
  final String createdDate;
  final String bprLogo;
  final String bprNama;

  factory UserIbprModel.fromJson(Map<String,dynamic> json) => UserIbprModel(
    id: json['id'] as int,
    usersId: json['users_id'].toString(),
    namaLengkap: json['nama_lengkap'].toString(),
    nomorPonsel: json['nomor_ponsel'].toString(),
    bprId: json['bpr_id'].toString(),
    noRekening: json['no_rekening'].toString(),
    noKtp: json['no_ktp'].toString(),
    photo: json['photo'].toString(),
    createdDate: json['createdDate'].toString(),
    bprLogo: json['bpr_logo'].toString(),
    bprNama: json['bpr_nama'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'users_id': usersId,
    'nama_lengkap': namaLengkap,
    'nomor_ponsel': nomorPonsel,
    'bpr_id': bprId,
    'no_rekening': noRekening,
    'no_ktp': noKtp,
    'photo': photo,
    'createdDate': createdDate,
    'bpr_logo': bprLogo,
    'bpr_nama': bprNama
  };

  UserIbprModel clone() => UserIbprModel(
    id: id,
    usersId: usersId,
    namaLengkap: namaLengkap,
    nomorPonsel: nomorPonsel,
    bprId: bprId,
    noRekening: noRekening,
    noKtp: noKtp,
    photo: photo,
    createdDate: createdDate,
    bprLogo: bprLogo,
    bprNama: bprNama
  );


  UserIbprModel copyWith({
    int? id,
    String? usersId,
    String? namaLengkap,
    String? nomorPonsel,
    String? bprId,
    String? noRekening,
    String? noKtp,
    String? photo,
    String? createdDate,
    String? bprLogo,
    String? bprNama
  }) => UserIbprModel(
    id: id ?? this.id,
    usersId: usersId ?? this.usersId,
    namaLengkap: namaLengkap ?? this.namaLengkap,
    nomorPonsel: nomorPonsel ?? this.nomorPonsel,
    bprId: bprId ?? this.bprId,
    noRekening: noRekening ?? this.noRekening,
    noKtp: noKtp ?? this.noKtp,
    photo: photo ?? this.photo,
    createdDate: createdDate ?? this.createdDate,
    bprLogo: bprLogo ?? this.bprLogo,
    bprNama: bprNama ?? this.bprNama,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is UserIbprModel && id == other.id && usersId == other.usersId && namaLengkap == other.namaLengkap && nomorPonsel == other.nomorPonsel && bprId == other.bprId && noRekening == other.noRekening && noKtp == other.noKtp && photo == other.photo && createdDate == other.createdDate && bprLogo == other.bprLogo && bprNama == other.bprNama;

  @override
  int get hashCode => id.hashCode ^ usersId.hashCode ^ namaLengkap.hashCode ^ nomorPonsel.hashCode ^ bprId.hashCode ^ noRekening.hashCode ^ noKtp.hashCode ^ photo.hashCode ^ createdDate.hashCode ^ bprLogo.hashCode ^ bprNama.hashCode;
}
