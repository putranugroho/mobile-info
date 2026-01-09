import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class HistoryModel {

  const HistoryModel({
    required this.id,
    required this.noRek,
    required this.bprId,
    required this.invoice,
    required this.noHp,
    required this.productCode,
    required this.productName,
    required this.nama,
    required this.reff,
    required this.amount,
    required this.createdDate,
    required this.tglTrans,
    required this.tglExpired,
    required this.tipe,
    required this.jenisTransaksi,
    required this.keterangan,
    required this.results,
    required this.status,
  });

  final int id;
  final String noRek;
  final String bprId;
  final String invoice;
  final String noHp;
  final String productCode;
  final String productName;
  final String nama;
  final dynamic reff;
  final String amount;
  final String createdDate;
  final String tglTrans;
  final String tglExpired;
  final String tipe;
  final String jenisTransaksi;
  final dynamic keterangan;
  final dynamic results;
  final String status;

  factory HistoryModel.fromJson(Map<String,dynamic> json) => HistoryModel(
    id: json['id'] as int,
    noRek: json['no_rek'].toString(),
    bprId: json['bpr_id'].toString(),
    invoice: json['invoice'].toString(),
    noHp: json['no_hp'].toString(),
    productCode: json['product_code'].toString(),
    productName: json['product_name'].toString(),
    nama: json['nama'].toString(),
    reff: json['reff'] as dynamic,
    amount: json['amount'].toString(),
    createdDate: json['createdDate'].toString(),
    tglTrans: json['tgl_trans'].toString(),
    tglExpired: json['tgl_expired'].toString(),
    tipe: json['tipe'].toString(),
    jenisTransaksi: json['jenis_transaksi'].toString(),
    keterangan: json['keterangan'] as dynamic,
    results: json['results'] as dynamic,
    status: json['status'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'no_rek': noRek,
    'bpr_id': bprId,
    'invoice': invoice,
    'no_hp': noHp,
    'product_code': productCode,
    'product_name': productName,
    'nama': nama,
    'reff': reff,
    'amount': amount,
    'createdDate': createdDate,
    'tgl_trans': tglTrans,
    'tgl_expired': tglExpired,
    'tipe': tipe,
    'jenis_transaksi': jenisTransaksi,
    'keterangan': keterangan,
    'results': results,
    'status': status
  };

  HistoryModel clone() => HistoryModel(
    id: id,
    noRek: noRek,
    bprId: bprId,
    invoice: invoice,
    noHp: noHp,
    productCode: productCode,
    productName: productName,
    nama: nama,
    reff: reff,
    amount: amount,
    createdDate: createdDate,
    tglTrans: tglTrans,
    tglExpired: tglExpired,
    tipe: tipe,
    jenisTransaksi: jenisTransaksi,
    keterangan: keterangan,
    results: results,
    status: status
  );


  HistoryModel copyWith({
    int? id,
    String? noRek,
    String? bprId,
    String? invoice,
    String? noHp,
    String? productCode,
    String? productName,
    String? nama,
    dynamic? reff,
    String? amount,
    String? createdDate,
    String? tglTrans,
    String? tglExpired,
    String? tipe,
    String? jenisTransaksi,
    dynamic? keterangan,
    dynamic? results,
    String? status
  }) => HistoryModel(
    id: id ?? this.id,
    noRek: noRek ?? this.noRek,
    bprId: bprId ?? this.bprId,
    invoice: invoice ?? this.invoice,
    noHp: noHp ?? this.noHp,
    productCode: productCode ?? this.productCode,
    productName: productName ?? this.productName,
    nama: nama ?? this.nama,
    reff: reff ?? this.reff,
    amount: amount ?? this.amount,
    createdDate: createdDate ?? this.createdDate,
    tglTrans: tglTrans ?? this.tglTrans,
    tglExpired: tglExpired ?? this.tglExpired,
    tipe: tipe ?? this.tipe,
    jenisTransaksi: jenisTransaksi ?? this.jenisTransaksi,
    keterangan: keterangan ?? this.keterangan,
    results: results ?? this.results,
    status: status ?? this.status,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is HistoryModel && id == other.id && noRek == other.noRek && bprId == other.bprId && invoice == other.invoice && noHp == other.noHp && productCode == other.productCode && productName == other.productName && nama == other.nama && reff == other.reff && amount == other.amount && createdDate == other.createdDate && tglTrans == other.tglTrans && tglExpired == other.tglExpired && tipe == other.tipe && jenisTransaksi == other.jenisTransaksi && keterangan == other.keterangan && results == other.results && status == other.status;

  @override
  int get hashCode => id.hashCode ^ noRek.hashCode ^ bprId.hashCode ^ invoice.hashCode ^ noHp.hashCode ^ productCode.hashCode ^ productName.hashCode ^ nama.hashCode ^ reff.hashCode ^ amount.hashCode ^ createdDate.hashCode ^ tglTrans.hashCode ^ tglExpired.hashCode ^ tipe.hashCode ^ jenisTransaksi.hashCode ^ keterangan.hashCode ^ results.hashCode ^ status.hashCode;
}
