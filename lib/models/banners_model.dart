import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class BannersModel {

  const BannersModel({
    required this.id,
    required this.banners,
    required this.tipe,
    required this.results,
  });

  final int id;
  final String banners;
  final String tipe;
  final String results;

  factory BannersModel.fromJson(Map<String,dynamic> json) => BannersModel(
    id: json['id'] as int,
    banners: json['banners'].toString(),
    tipe: json['tipe'].toString(),
    results: json['results'].toString()
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'banners': banners,
    'tipe': tipe,
    'results': results
  };

  BannersModel clone() => BannersModel(
    id: id,
    banners: banners,
    tipe: tipe,
    results: results
  );


  BannersModel copyWith({
    int? id,
    String? banners,
    String? tipe,
    String? results
  }) => BannersModel(
    id: id ?? this.id,
    banners: banners ?? this.banners,
    tipe: tipe ?? this.tipe,
    results: results ?? this.results,
  );

  @override
  bool operator ==(Object other) => identical(this, other)
    || other is BannersModel && id == other.id && banners == other.banners && tipe == other.tipe && results == other.results;

  @override
  int get hashCode => id.hashCode ^ banners.hashCode ^ tipe.hashCode ^ results.hashCode;
}
