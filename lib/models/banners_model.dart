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
    required this.jenis,
    required this.url,
    required this.title,
    required this.description,
    required this.urutan,
  });

  final int id;
  final String banners;
  final String tipe;
  final String results;
  final String jenis;
  final String url;
  final String title;
  final String description;
  final int? urutan;

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
    id: json['id'] as int,
    banners: json['banners'].toString(),
    tipe: json['tipe'].toString(),
    results: json['results'].toString(),
    jenis: json['jenis'].toString(),
    url: json['url'].toString(),
    title: json['title'].toString(),
    description: json['description'].toString(),
    urutan: json['urutan'] == null ? null : int.tryParse(json['urutan'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'banners': banners,
    'tipe': tipe,
    'results': results,
    'jenis': jenis,
    'url': url,
    'title': title,
    'description': description,
    'urutan': urutan,
  };

  BannersModel clone() => BannersModel(
    id: id,
    banners: banners,
    tipe: tipe,
    results: results,
    jenis: jenis,
    url: url,
    title: title,
    description: description,
    urutan: urutan,
  );

  BannersModel copyWith({
    int? id,
    String? banners,
    String? tipe,
    String? results,
    String? jenis,
    String? url,
    String? title,
    String? description,
    int? urutan,
  }) => BannersModel(
    id: id ?? this.id,
    banners: banners ?? this.banners,
    tipe: tipe ?? this.tipe,
    results: results ?? this.results,
    jenis: jenis ?? this.jenis,
    url: url ?? this.url,
    title: title ?? this.title,
    description: description ?? this.description,
    urutan: urutan ?? this.urutan,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannersModel &&
          id == other.id &&
          banners == other.banners &&
          tipe == other.tipe &&
          results == other.results &&
          jenis == other.jenis &&
          url == other.url &&
          title == other.title &&
          description == other.description &&
          urutan == other.urutan;

  @override
  int get hashCode =>
      id.hashCode ^
      banners.hashCode ^
      tipe.hashCode ^
      results.hashCode ^
      jenis.hashCode ^
      url.hashCode ^
      title.hashCode ^
      description.hashCode ^
      urutan.hashCode;
}
