import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class BprModel {

  const BprModel({
    required this.bprId,
    required this.namaBpr,
    required this.alamatBpr,
    required this.kodePos,
    required this.npwpBpr,
    required this.noTel,
    required this.email,
    required this.namaPic,
    required this.hpPic,
    required this.emailPic,
    required this.kodeBank1,
    required this.noRek1,
    required this.namaRek1,
    required this.kodeBank2,
    required this.noRek2,
    required this.namaRek2,
    required this.bprLogo,
    required this.kdbprRi,
    required this.status,
    required this.userInput,
    required this.tglInput,
    required this.termInput,
    required this.userUbah,
    required this.tglUbah,
    required this.termUbah,
    required this.userHapus,
    required this.tglHapus,
    required this.termHapus,
    required this.userOto,
    required this.tglOto,
    required this.termOto,
    required this.gateway,
  });

  final String bprId;
  final String namaBpr;
  final String alamatBpr;
  final String kodePos;
  final String npwpBpr;
  final String noTel;
  final String email;
  final String namaPic;
  final String hpPic;
  final String emailPic;
  final String kodeBank1;
  final String noRek1;
  final String namaRek1;
  final String kodeBank2;
  final String noRek2;
  final String namaRek2;
  final String bprLogo;
  final String kdbprRi;
  final String status;
  final String userInput;
  final String tglInput;
  final String termInput;
  final dynamic userUbah;
  final dynamic tglUbah;
  final dynamic termUbah;
  final dynamic userHapus;
  final dynamic tglHapus;
  final dynamic termHapus;
  final dynamic userOto;
  final dynamic tglOto;
  final dynamic termOto;
  final String gateway;

  factory BprModel.fromJson(Map<String,dynamic> json) => BprModel(
    bprId: json['bpr_id'].toString(),
    namaBpr: json['nama_bpr'].toString(),
    alamatBpr: json['alamat_bpr'].toString(),
    kodePos: json['kode_pos'].toString(),
    npwpBpr: json['npwp_bpr'].toString(),
    noTel: json['no_tel'].toString(),
    email: json['email'].toString(),
    namaPic: json['nama_pic'].toString(),
    hpPic: json['hp_pic'].toString(),
    emailPic: json['email_pic'].toString(),
    kodeBank1: json['kode_bank1'].toString(),
    noRek1: json['no_rek1'].toString(),
    namaRek1: json['nama_rek1'].toString(),
    kodeBank2: json['kode_bank2'].toString(),
    noRek2: json['no_rek2'].toString(),
    namaRek2: json['nama_rek2'].toString(),
    bprLogo: json['bpr_logo'].toString(),
    kdbprRi: json['kdbpr_ri'].toString(),
    status: json['status'].toString(),
    userInput: json['user_input'].toString(),
    tglInput: json['tgl_input'].toString(),
    termInput: json['term_input'].toString(),
    userUbah: json['user_ubah'] as dynamic,
    tglUbah: json['tgl_ubah'] as dynamic,
    termUbah: json['term_ubah'] as dynamic,
    userHapus: json['user_hapus'] as dynamic,
    tglHapus: json['tgl_hapus'] as dynamic,
    termHapus: json['term_hapus'] as dynamic,
    userOto: json['user_oto'] as dynamic,
    tglOto: json['tgl_oto'] as dynamic,
    termOto: json['term_oto'] as dynamic,
    gateway: json['gateway'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'bpr_id': bprId,
    'nama_bpr': namaBpr,
    'alamat_bpr': alamatBpr,
    'kode_pos': kodePos,
    'npwp_bpr': npwpBpr,
    'no_tel': noTel,
    'email': email,
    'nama_pic': namaPic,
    'hp_pic': hpPic,
    'email_pic': emailPic,
    'kode_bank1': kodeBank1,
    'no_rek1': noRek1,
    'nama_rek1': namaRek1,
    'kode_bank2': kodeBank2,
    'no_rek2': noRek2,
    'nama_rek2': namaRek2,
    'bpr_logo': bprLogo,
    'kdbpr_ri': kdbprRi,
    'status': status,
    'user_input': userInput,
    'tgl_input': tglInput,
    'term_input': termInput,
    'user_ubah': userUbah,
    'tgl_ubah': tglUbah,
    'term_ubah': termUbah,
    'user_hapus': userHapus,
    'tgl_hapus': tglHapus,
    'term_hapus': termHapus,
    'user_oto': userOto,
    'tgl_oto': tglOto,
    'term_oto': termOto,
    'gateway': gateway
  };

  BprModel clone() => BprModel(
    bprId: bprId,
    namaBpr: namaBpr,
    alamatBpr: alamatBpr,
    kodePos: kodePos,
    npwpBpr: npwpBpr,
    noTel: noTel,
    email: email,
    namaPic: namaPic,
    hpPic: hpPic,
    emailPic: emailPic,
    kodeBank1: kodeBank1,
    noRek1: noRek1,
    namaRek1: namaRek1,
    kodeBank2: kodeBank2,
    noRek2: noRek2,
    namaRek2: namaRek2,
    bprLogo: bprLogo,
    kdbprRi: kdbprRi,
    status: status,
    userInput: userInput,
    tglInput: tglInput,
    termInput: termInput,
    userUbah: userUbah,
    tglUbah: tglUbah,
    termUbah: termUbah,
    userHapus: userHapus,
    tglHapus: tglHapus,
    termHapus: termHapus,
    userOto: userOto,
    tglOto: tglOto,
    termOto: termOto,
    gateway: gateway
  );


  BprModel copyWith({
    String? bprId,
    String? namaBpr,
    String? alamatBpr,
    String? kodePos,
    String? npwpBpr,
    String? noTel,
    String? email,
    String? namaPic,
    String? hpPic,
    String? emailPic,
    String? kodeBank1,
    String? noRek1,
    String? namaRek1,
    String? kodeBank2,
    String? noRek2,
    String? namaRek2,
    String? bprLogo,
    String? kdbprRi,
    String? status,
    String? userInput,
    String? tglInput,
    String? termInput,
    dynamic? userUbah,
    dynamic? tglUbah,
    dynamic? termUbah,
    dynamic? userHapus,
    dynamic? tglHapus,
    dynamic? termHapus,
    dynamic? userOto,
    dynamic? tglOto,
    dynamic? termOto,
    String? gateway
  }) => BprModel(
    bprId: bprId ?? this.bprId,
    namaBpr: namaBpr ?? this.namaBpr,
    alamatBpr: alamatBpr ?? this.alamatBpr,
    kodePos: kodePos ?? this.kodePos,
    npwpBpr: npwpBpr ?? this.npwpBpr,
    noTel: noTel ?? this.noTel,
    email: email ?? this.email,
    namaPic: namaPic ?? this.namaPic,
    hpPic: hpPic ?? this.hpPic,
    emailPic: emailPic ?? this.emailPic,
    kodeBank1: kodeBank1 ?? this.kodeBank1,
    noRek1: noRek1 ?? this.noRek1,
    namaRek1: namaRek1 ?? this.namaRek1,
    kodeBank2: kodeBank2 ?? this.kodeBank2,
    noRek2: noRek2 ?? this.noRek2,
    namaRek2: namaRek2 ?? this.namaRek2,
    bprLogo: bprLogo ?? this.bprLogo,
    kdbprRi: kdbprRi ?? this.kdbprRi,
    status: status ?? this.status,
    userInput: userInput ?? this.userInput,
    tglInput: tglInput ?? this.tglInput,
    termInput: termInput ?? this.termInput,
    userUbah: userUbah ?? this.userUbah,
    tglUbah: tglUbah ?? this.tglUbah,
    termUbah: termUbah ?? this.termUbah,
    userHapus: userHapus ?? this.userHapus,
    tglHapus: tglHapus ?? this.tglHapus,
    termHapus: termHapus ?? this.termHapus,
    userOto: userOto ?? this.userOto,
    tglOto: tglOto ?? this.tglOto,
    termOto: termOto ?? this.termOto,
    gateway: gateway ?? this.gateway,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is BprModel && bprId == other.bprId && namaBpr == other.namaBpr && alamatBpr == other.alamatBpr && kodePos == other.kodePos && npwpBpr == other.npwpBpr && noTel == other.noTel && email == other.email && namaPic == other.namaPic && hpPic == other.hpPic && emailPic == other.emailPic && kodeBank1 == other.kodeBank1 && noRek1 == other.noRek1 && namaRek1 == other.namaRek1 && kodeBank2 == other.kodeBank2 && noRek2 == other.noRek2 && namaRek2 == other.namaRek2 && bprLogo == other.bprLogo && kdbprRi == other.kdbprRi && status == other.status && userInput == other.userInput && tglInput == other.tglInput && termInput == other.termInput && userUbah == other.userUbah && tglUbah == other.tglUbah && termUbah == other.termUbah && userHapus == other.userHapus && tglHapus == other.tglHapus && termHapus == other.termHapus && userOto == other.userOto && tglOto == other.tglOto && termOto == other.termOto && gateway == other.gateway;

  @override
  int get hashCode => bprId.hashCode ^ namaBpr.hashCode ^ alamatBpr.hashCode ^ kodePos.hashCode ^ npwpBpr.hashCode ^ noTel.hashCode ^ email.hashCode ^ namaPic.hashCode ^ hpPic.hashCode ^ emailPic.hashCode ^ kodeBank1.hashCode ^ noRek1.hashCode ^ namaRek1.hashCode ^ kodeBank2.hashCode ^ noRek2.hashCode ^ namaRek2.hashCode ^ bprLogo.hashCode ^ kdbprRi.hashCode ^ status.hashCode ^ userInput.hashCode ^ tglInput.hashCode ^ termInput.hashCode ^ userUbah.hashCode ^ tglUbah.hashCode ^ termUbah.hashCode ^ userHapus.hashCode ^ tglHapus.hashCode ^ termHapus.hashCode ^ userOto.hashCode ^ tglOto.hashCode ^ termOto.hashCode ^ gateway.hashCode;
}
