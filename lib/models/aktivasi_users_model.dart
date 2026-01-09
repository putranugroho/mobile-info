import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class AktivasiUsersModel {

  const AktivasiUsersModel({
    required this.no,
    required this.noHp,
    required this.bprId,
    required this.userId,
    required this.password,
    required this.pwCetak,
    required this.passwordSalah,
    required this.mpin,
    required this.mpinCetak,
    required this.mpinSalah,
    required this.typeAcct,
    required this.noKtp,
    required this.nama,
    required this.noRek,
    required this.namaRek,
    required this.email,
    required this.fotoId,
    required this.fotoDiri,
    required this.deviceId,
    required this.tariktunai,
    required this.transfer,
    required this.pindahBuku,
    required this.ppobBeli,
    required this.ppobBayar,
    required this.belanja,
    required this.trxTerakhir,
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
    required this.uniqueId,
    required this.logo1,
    required this.idNasabahKeeping,
  });

  final String no;
  final String noHp;
  final String bprId;
  final String userId;
  final String password;
  final String pwCetak;
  final String passwordSalah;
  final String mpin;
  final String mpinCetak;
  final String mpinSalah;
  final String typeAcct;
  final String noKtp;
  final String nama;
  final String noRek;
  final String namaRek;
  final String email;
  final dynamic fotoId;
  final dynamic fotoDiri;
  final String deviceId;
  final String tariktunai;
  final String transfer;
  final String pindahBuku;
  final String ppobBeli;
  final String ppobBayar;
  final String belanja;
  final dynamic trxTerakhir;
  final String status;
  final dynamic userInput;
  final dynamic tglInput;
  final dynamic termInput;
  final dynamic userUbah;
  final dynamic tglUbah;
  final dynamic termUbah;
  final dynamic userHapus;
  final dynamic tglHapus;
  final dynamic termHapus;
  final dynamic userOto;
  final dynamic tglOto;
  final dynamic termOto;
  final String uniqueId;
  final dynamic logo1;
  final String idNasabahKeeping;

  factory AktivasiUsersModel.fromJson(Map<String,dynamic> json) => AktivasiUsersModel(
    no: json['no'].toString(),
    noHp: json['no_hp'].toString(),
    bprId: json['bpr_id'].toString(),
    userId: json['user_id'].toString(),
    password: json['password'].toString(),
    pwCetak: json['pw_cetak'].toString(),
    passwordSalah: json['password_salah'].toString(),
    mpin: json['mpin'].toString(),
    mpinCetak: json['mpin_cetak'].toString(),
    mpinSalah: json['mpin_salah'].toString(),
    typeAcct: json['type_acct'].toString(),
    noKtp: json['no_ktp'].toString(),
    nama: json['nama'].toString(),
    noRek: json['no_rek'].toString(),
    namaRek: json['nama_rek'].toString(),
    email: json['email'].toString(),
    fotoId: json['foto_id'] as dynamic,
    fotoDiri: json['foto_diri'] as dynamic,
    deviceId: json['device_id'].toString(),
    tariktunai: json['tariktunai'].toString(),
    transfer: json['transfer'].toString(),
    pindahBuku: json['pindah_buku'].toString(),
    ppobBeli: json['ppob_beli'].toString(),
    ppobBayar: json['ppob_bayar'].toString(),
    belanja: json['belanja'].toString(),
    trxTerakhir: json['trx_terakhir'] as dynamic,
    status: json['status'].toString(),
    userInput: json['user_input'] as dynamic,
    tglInput: json['tgl_input'] as dynamic,
    termInput: json['term_input'] as dynamic,
    userUbah: json['user_ubah'] as dynamic,
    tglUbah: json['tgl_ubah'] as dynamic,
    termUbah: json['term_ubah'] as dynamic,
    userHapus: json['user_hapus'] as dynamic,
    tglHapus: json['tgl_hapus'] as dynamic,
    termHapus: json['term_hapus'] as dynamic,
    userOto: json['user_oto'] as dynamic,
    tglOto: json['tgl_oto'] as dynamic,
    termOto: json['term_oto'] as dynamic,
    uniqueId: json['unique_id'].toString(),
    logo1: json['logo1'] as dynamic,
    idNasabahKeeping: json['id_nasabah_keeping'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'no': no,
    'no_hp': noHp,
    'bpr_id': bprId,
    'user_id': userId,
    'password': password,
    'pw_cetak': pwCetak,
    'password_salah': passwordSalah,
    'mpin': mpin,
    'mpin_cetak': mpinCetak,
    'mpin_salah': mpinSalah,
    'type_acct': typeAcct,
    'no_ktp': noKtp,
    'nama': nama,
    'no_rek': noRek,
    'nama_rek': namaRek,
    'email': email,
    'foto_id': fotoId,
    'foto_diri': fotoDiri,
    'device_id': deviceId,
    'tariktunai': tariktunai,
    'transfer': transfer,
    'pindah_buku': pindahBuku,
    'ppob_beli': ppobBeli,
    'ppob_bayar': ppobBayar,
    'belanja': belanja,
    'trx_terakhir': trxTerakhir,
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
    'unique_id': uniqueId,
    'logo1': logo1,
    'id_nasabah_keeping': idNasabahKeeping
  };

  AktivasiUsersModel clone() => AktivasiUsersModel(
    no: no,
    noHp: noHp,
    bprId: bprId,
    userId: userId,
    password: password,
    pwCetak: pwCetak,
    passwordSalah: passwordSalah,
    mpin: mpin,
    mpinCetak: mpinCetak,
    mpinSalah: mpinSalah,
    typeAcct: typeAcct,
    noKtp: noKtp,
    nama: nama,
    noRek: noRek,
    namaRek: namaRek,
    email: email,
    fotoId: fotoId,
    fotoDiri: fotoDiri,
    deviceId: deviceId,
    tariktunai: tariktunai,
    transfer: transfer,
    pindahBuku: pindahBuku,
    ppobBeli: ppobBeli,
    ppobBayar: ppobBayar,
    belanja: belanja,
    trxTerakhir: trxTerakhir,
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
    uniqueId: uniqueId,
    logo1: logo1,
    idNasabahKeeping: idNasabahKeeping
  );


  AktivasiUsersModel copyWith({
    String? no,
    String? noHp,
    String? bprId,
    String? userId,
    String? password,
    String? pwCetak,
    String? passwordSalah,
    String? mpin,
    String? mpinCetak,
    String? mpinSalah,
    String? typeAcct,
    String? noKtp,
    String? nama,
    String? noRek,
    String? namaRek,
    String? email,
    dynamic? fotoId,
    dynamic? fotoDiri,
    String? deviceId,
    String? tariktunai,
    String? transfer,
    String? pindahBuku,
    String? ppobBeli,
    String? ppobBayar,
    String? belanja,
    dynamic? trxTerakhir,
    String? status,
    dynamic? userInput,
    dynamic? tglInput,
    dynamic? termInput,
    dynamic? userUbah,
    dynamic? tglUbah,
    dynamic? termUbah,
    dynamic? userHapus,
    dynamic? tglHapus,
    dynamic? termHapus,
    dynamic? userOto,
    dynamic? tglOto,
    dynamic? termOto,
    String? uniqueId,
    dynamic? logo1,
    String? idNasabahKeeping
  }) => AktivasiUsersModel(
    no: no ?? this.no,
    noHp: noHp ?? this.noHp,
    bprId: bprId ?? this.bprId,
    userId: userId ?? this.userId,
    password: password ?? this.password,
    pwCetak: pwCetak ?? this.pwCetak,
    passwordSalah: passwordSalah ?? this.passwordSalah,
    mpin: mpin ?? this.mpin,
    mpinCetak: mpinCetak ?? this.mpinCetak,
    mpinSalah: mpinSalah ?? this.mpinSalah,
    typeAcct: typeAcct ?? this.typeAcct,
    noKtp: noKtp ?? this.noKtp,
    nama: nama ?? this.nama,
    noRek: noRek ?? this.noRek,
    namaRek: namaRek ?? this.namaRek,
    email: email ?? this.email,
    fotoId: fotoId ?? this.fotoId,
    fotoDiri: fotoDiri ?? this.fotoDiri,
    deviceId: deviceId ?? this.deviceId,
    tariktunai: tariktunai ?? this.tariktunai,
    transfer: transfer ?? this.transfer,
    pindahBuku: pindahBuku ?? this.pindahBuku,
    ppobBeli: ppobBeli ?? this.ppobBeli,
    ppobBayar: ppobBayar ?? this.ppobBayar,
    belanja: belanja ?? this.belanja,
    trxTerakhir: trxTerakhir ?? this.trxTerakhir,
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
    uniqueId: uniqueId ?? this.uniqueId,
    logo1: logo1 ?? this.logo1,
    idNasabahKeeping: idNasabahKeeping ?? this.idNasabahKeeping,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is AktivasiUsersModel && no == other.no && noHp == other.noHp && bprId == other.bprId && userId == other.userId && password == other.password && pwCetak == other.pwCetak && passwordSalah == other.passwordSalah && mpin == other.mpin && mpinCetak == other.mpinCetak && mpinSalah == other.mpinSalah && typeAcct == other.typeAcct && noKtp == other.noKtp && nama == other.nama && noRek == other.noRek && namaRek == other.namaRek && email == other.email && fotoId == other.fotoId && fotoDiri == other.fotoDiri && deviceId == other.deviceId && tariktunai == other.tariktunai && transfer == other.transfer && pindahBuku == other.pindahBuku && ppobBeli == other.ppobBeli && ppobBayar == other.ppobBayar && belanja == other.belanja && trxTerakhir == other.trxTerakhir && status == other.status && userInput == other.userInput && tglInput == other.tglInput && termInput == other.termInput && userUbah == other.userUbah && tglUbah == other.tglUbah && termUbah == other.termUbah && userHapus == other.userHapus && tglHapus == other.tglHapus && termHapus == other.termHapus && userOto == other.userOto && tglOto == other.tglOto && termOto == other.termOto && uniqueId == other.uniqueId && logo1 == other.logo1 && idNasabahKeeping == other.idNasabahKeeping;

  @override
  int get hashCode => no.hashCode ^ noHp.hashCode ^ bprId.hashCode ^ userId.hashCode ^ password.hashCode ^ pwCetak.hashCode ^ passwordSalah.hashCode ^ mpin.hashCode ^ mpinCetak.hashCode ^ mpinSalah.hashCode ^ typeAcct.hashCode ^ noKtp.hashCode ^ nama.hashCode ^ noRek.hashCode ^ namaRek.hashCode ^ email.hashCode ^ fotoId.hashCode ^ fotoDiri.hashCode ^ deviceId.hashCode ^ tariktunai.hashCode ^ transfer.hashCode ^ pindahBuku.hashCode ^ ppobBeli.hashCode ^ ppobBayar.hashCode ^ belanja.hashCode ^ trxTerakhir.hashCode ^ status.hashCode ^ userInput.hashCode ^ tglInput.hashCode ^ termInput.hashCode ^ userUbah.hashCode ^ tglUbah.hashCode ^ termUbah.hashCode ^ userHapus.hashCode ^ tglHapus.hashCode ^ termHapus.hashCode ^ userOto.hashCode ^ tglOto.hashCode ^ termOto.hashCode ^ uniqueId.hashCode ^ logo1.hashCode ^ idNasabahKeeping.hashCode;
}
