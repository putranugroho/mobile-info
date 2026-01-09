import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class BankModel {

  const BankModel({
    required this.bankCode,
    required this.name,
    required this.fee,
    required this.queue,
    required this.status,
  });

  final String bankCode;
  final String name;
  final int fee;
  final int queue;
  final String status;

  factory BankModel.fromJson(Map<String,dynamic> json) => BankModel(
    bankCode: json['bank_code'].toString(),
    name: json['name'].toString(),
    fee: json['fee'] as int,
    queue: json['queue'] as int,
    status: json['status'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'bank_code': bankCode,
    'name': name,
    'fee': fee,
    'queue': queue,
    'status': status
  };

  BankModel clone() => BankModel(
    bankCode: bankCode,
    name: name,
    fee: fee,
    queue: queue,
    status: status
  );


  BankModel copyWith({
    String? bankCode,
    String? name,
    int? fee,
    int? queue,
    String? status
  }) => BankModel(
    bankCode: bankCode ?? this.bankCode,
    name: name ?? this.name,
    fee: fee ?? this.fee,
    queue: queue ?? this.queue,
    status: status ?? this.status,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is BankModel && bankCode == other.bankCode && name == other.name && fee == other.fee && queue == other.queue && status == other.status;

  @override
  int get hashCode => bankCode.hashCode ^ name.hashCode ^ fee.hashCode ^ queue.hashCode ^ status.hashCode;
}
