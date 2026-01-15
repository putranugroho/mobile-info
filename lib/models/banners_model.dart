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
    this.url,
    this.title,
    this.description,
  });

  final int id;
  final String banners;
  final String tipe;
  final String results;
  final String jenis;
  final String? url; // url url cloud
  final String? title;
  final String? description;

  factory BannersModel.fromJson(Map<String, dynamic> json) => BannersModel(
    id: json['id'] as int,
    banners: json['banners'].toString(),
    tipe: json['tipe'].toString(),
    results: json['results'].toString(),
    jenis: json['jenis'] ?? '',
    url: json['url'],
    title: json['title'],
    description: json['description'],
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
  };

  BannersModel clone() =>
      BannersModel(id: id, banners: banners, tipe: tipe, results: results, jenis: jenis, url: url, title: title, description: description);

  BannersModel copyWith({int? id, String? banners, String? tipe, String? results, String? jenis, String? url, String? title, String? description}) =>
      BannersModel(
        id: id ?? this.id,
        banners: banners ?? this.banners,
        tipe: tipe ?? this.tipe,
        results: results ?? this.results,
        jenis: jenis ?? this.jenis,
        url: url ?? this.url,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BannersModel && id == other.id && banners == other.banners && tipe == other.tipe && results == other.results;

  @override
  int get hashCode => id.hashCode ^ banners.hashCode ^ tipe.hashCode ^ results.hashCode;

  @override
  String toString() {
    return 'BannersModel(id: $id, banners: $banners, tipe: $tipe, results: $results, jenis: $jenis, url: $url, title: $title, description: $description)';
  }
}
