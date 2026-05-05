import 'package:flutter/foundation.dart';
import 'package:quiver/core.dart';

import 'index.dart';

@immutable
class BannersModel {
  final int? id;
  final String banners;
  final String tipe;
  final String results;
  final String jenis;
  final String url;
  final String title;
  final String description;
  final int? urutan;

  final String scopeType;
  final String bprId;
  final String bannerType;
  final String imageFile;
  final String imageUrl;
  final String videoFile;
  final String videoUrl;
  final String textContent;
  final bool isActive;

  BannersModel({
    this.id,
    this.banners = "",
    this.tipe = "",
    this.results = "",
    this.jenis = "",
    this.url = "",
    this.title = "",
    this.description = "",
    this.urutan,
    this.scopeType = "",
    this.bprId = "",
    this.bannerType = "",
    this.imageFile = "",
    this.imageUrl = "",
    this.videoFile = "",
    this.videoUrl = "",
    this.textContent = "",
    this.isActive = true,
  });

  factory BannersModel.fromJson(Map<String, dynamic> json) {
    final bannerType = "${json['banner_type'] ?? json['jenis'] ?? ''}".toUpperCase();

    final imageFile = "${json['image_file'] ?? json['banners'] ?? ''}";
    final videoFile = "${json['video_file'] ?? ''}";

    return BannersModel(
      id: int.tryParse("${json['id'] ?? ''}"),
      banners: imageFile,
      tipe: "${json['tipe'] ?? ''}",
      results: "${json['results'] ?? ''}",
      jenis: bannerType,
      url: "${json['url'] ?? json['video_url'] ?? ''}",
      title: "${json['title'] ?? ''}",
      description: "${json['description'] ?? ''}",
      urutan: int.tryParse("${json['urutan'] ?? ''}"),

      scopeType: "${json['scope_type'] ?? ''}",
      bprId: "${json['bpr_id'] ?? ''}",
      bannerType: bannerType,
      imageFile: imageFile,
      imageUrl: "${json['image_url'] ?? ''}",
      videoFile: videoFile,
      videoUrl: "${json['video_url'] ?? ''}",
      textContent: "${json['text_content'] ?? ''}",
      isActive: json['is_active'] == null ? true : json['is_active'] == true,
    );
  }
}
