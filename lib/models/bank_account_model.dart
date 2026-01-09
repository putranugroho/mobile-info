import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class BankAccountModel {

  const BankAccountModel({
    required this.id,
    required this.bank,
    required this.bankCode,
    required this.nama,
    required this.account,
    required this.idUsers,
    required this.createdDate,
  });

  final int id;
  final String bank;
  final String bankCode;
  final String nama;
  final String account;
  final String idUsers;
  final String createdDate;

  factory BankAccountModel.fromJson(Map<String,dynamic> json) => BankAccountModel(
    id: json['id'] as int,
    bank: json['bank'].toString(),
    bankCode: json['bank_code'].toString(),
    nama: json['nama'].toString(),
    account: json['account'].toString(),
    idUsers: json['id_users'].toString(),
    createdDate: json['createdDate'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'bank': bank,
    'bank_code': bankCode,
    'nama': nama,
    'account': account,
    'id_users': idUsers,
    'createdDate': createdDate
  };

  BankAccountModel clone() => BankAccountModel(
    id: id,
    bank: bank,
    bankCode: bankCode,
    nama: nama,
    account: account,
    idUsers: idUsers,
    createdDate: createdDate
  );


  BankAccountModel copyWith({
    int? id,
    String? bank,
    String? bankCode,
    String? nama,
    String? account,
    String? idUsers,
    String? createdDate
  }) => BankAccountModel(
    id: id ?? this.id,
    bank: bank ?? this.bank,
    bankCode: bankCode ?? this.bankCode,
    nama: nama ?? this.nama,
    account: account ?? this.account,
    idUsers: idUsers ?? this.idUsers,
    createdDate: createdDate ?? this.createdDate,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is BankAccountModel && id == other.id && bank == other.bank && bankCode == other.bankCode && nama == other.nama && account == other.account && idUsers == other.idUsers && createdDate == other.createdDate;

  @override
  int get hashCode => id.hashCode ^ bank.hashCode ^ bankCode.hashCode ^ nama.hashCode ^ account.hashCode ^ idUsers.hashCode ^ createdDate.hashCode;
}
