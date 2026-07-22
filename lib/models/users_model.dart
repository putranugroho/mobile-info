import 'package:flutter/foundation.dart';

@immutable
class UsersModel {
  const UsersModel({
    required this.id,
    required this.noCif,
    required this.usersId,
    required this.bprId,
    required this.nama,
    required this.tglLahir,
    required this.noIdentitas,
    required this.nomorPonsel,
    required this.bprLogo,
    required this.bprNama,
    required this.perbarindo,
    required this.createdAt,
    this.kdKantor = '',
    this.sessionToken = '',
    this.loginDeviceId = '',
    this.loginDeviceName = '',
    this.loginExpiredAt = '',
  });

  final int id;
  final String noCif;
  final String usersId;
  final String bprId;
  final String kdKantor;
  final String nama;
  final String tglLahir;
  final String noIdentitas;
  final String nomorPonsel;
  final String bprLogo;
  final String bprNama;
  final String perbarindo;
  final String createdAt;

  // Field baru untuk session Go middleware
  final String sessionToken;
  final String loginDeviceId;
  final String loginDeviceName;
  final String loginExpiredAt;

  // Alias agar kode notifier bisa pakai currentUser.username
  String get username => usersId;

  static Map<String, dynamic>? _mapFrom(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static String _readKdKantor(Iterable<Map<String, dynamic>?> maps) {
    for (final map in maps) {
      if (map == null) continue;
      final kantor = '${map['kd_kantor'] ?? map['kdKantor'] ?? map['kantor'] ?? ''}'.trim();
      if (kantor.isNotEmpty) return kantor;
    }
    return '';
  }

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    final data = _mapFrom(json['data']);
    final user = _mapFrom(json['user']);
    final nestedUser = _mapFrom(data?['user']);
    final source = data ?? user ?? json;

    int parseId(dynamic value) {
      if (value is int) return value;
      return int.tryParse('${value ?? 0}') ?? 0;
    }

    return UsersModel(
      id: parseId(source['id']),
      noCif: '${source['no_cif'] ?? source['nocif'] ?? ''}',
      usersId: '${source['users_id'] ?? source['username'] ?? source['userid'] ?? ''}',
      bprId: '${source['bpr_id'] ?? source['bprId'] ?? ''}',
      kdKantor: _readKdKantor([data, user, nestedUser, json]),
      nama: '${source['nama'] ?? source['name'] ?? ''}',
      tglLahir: '${source['tgl_lahir'] ?? source['tanggal_lahir'] ?? ''}',
      noIdentitas: '${source['no_identitas'] ?? source['no_id'] ?? ''}',
      nomorPonsel: '${source['nomor_ponsel'] ?? source['phone'] ?? source['no_hp'] ?? ''}',
      bprLogo: '${source['bpr_logo'] ?? source['logo_bpr'] ?? ''}',
      bprNama: '${source['bpr_nama'] ?? source['nama_bpr'] ?? ''}',
      perbarindo: '${source['perbarindo'] ?? ''}',
      createdAt: '${source['created_at'] ?? ''}',
      sessionToken: '${source['session_token'] ?? ''}',
      loginDeviceId: '${source['login_device_id'] ?? ''}',
      loginDeviceName: '${source['login_device_name'] ?? ''}',
      loginExpiredAt: '${source['login_expired_at'] ?? ''}',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'no_cif': noCif,
    'users_id': usersId,
    'username': usersId,
    'bpr_id': bprId,
    'kd_kantor': kdKantor,
    'nama': nama,
    'tgl_lahir': tglLahir,
    'no_identitas': noIdentitas,
    'nomor_ponsel': nomorPonsel,
    'phone': nomorPonsel,
    'bpr_logo': bprLogo,
    'bpr_nama': bprNama,
    'perbarindo': perbarindo,
    'created_at': createdAt,
    'session_token': sessionToken,
    'login_device_id': loginDeviceId,
    'login_device_name': loginDeviceName,
    'login_expired_at': loginExpiredAt,
  };

  UsersModel clone() => UsersModel(
    id: id,
    noCif: noCif,
    usersId: usersId,
    bprId: bprId,
    kdKantor: kdKantor,
    nama: nama,
    tglLahir: tglLahir,
    noIdentitas: noIdentitas,
    nomorPonsel: nomorPonsel,
    bprLogo: bprLogo,
    bprNama: bprNama,
    perbarindo: perbarindo,
    createdAt: createdAt,
    sessionToken: sessionToken,
    loginDeviceId: loginDeviceId,
    loginDeviceName: loginDeviceName,
    loginExpiredAt: loginExpiredAt,
  );

  UsersModel copyWith({
    int? id,
    String? noCif,
    String? usersId,
    String? bprId,
    String? kdKantor,
    String? nama,
    String? tglLahir,
    String? noIdentitas,
    String? nomorPonsel,
    String? bprLogo,
    String? bprNama,
    String? perbarindo,
    String? createdAt,
    String? sessionToken,
    String? loginDeviceId,
    String? loginDeviceName,
    String? loginExpiredAt,
  }) => UsersModel(
    id: id ?? this.id,
    noCif: noCif ?? this.noCif,
    usersId: usersId ?? this.usersId,
    bprId: bprId ?? this.bprId,
    kdKantor: kdKantor ?? this.kdKantor,
    nama: nama ?? this.nama,
    tglLahir: tglLahir ?? this.tglLahir,
    noIdentitas: noIdentitas ?? this.noIdentitas,
    nomorPonsel: nomorPonsel ?? this.nomorPonsel,
    bprLogo: bprLogo ?? this.bprLogo,
    bprNama: bprNama ?? this.bprNama,
    perbarindo: perbarindo ?? this.perbarindo,
    createdAt: createdAt ?? this.createdAt,
    sessionToken: sessionToken ?? this.sessionToken,
    loginDeviceId: loginDeviceId ?? this.loginDeviceId,
    loginDeviceName: loginDeviceName ?? this.loginDeviceName,
    loginExpiredAt: loginExpiredAt ?? this.loginExpiredAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsersModel &&
          id == other.id &&
          noCif == other.noCif &&
          usersId == other.usersId &&
          bprId == other.bprId &&
          kdKantor == other.kdKantor &&
          nama == other.nama &&
          tglLahir == other.tglLahir &&
          noIdentitas == other.noIdentitas &&
          nomorPonsel == other.nomorPonsel &&
          bprLogo == other.bprLogo &&
          bprNama == other.bprNama &&
          perbarindo == other.perbarindo &&
          createdAt == other.createdAt &&
          sessionToken == other.sessionToken &&
          loginDeviceId == other.loginDeviceId &&
          loginDeviceName == other.loginDeviceName &&
          loginExpiredAt == other.loginExpiredAt;

  @override
  int get hashCode =>
      id.hashCode ^
      noCif.hashCode ^
      usersId.hashCode ^
      bprId.hashCode ^
      kdKantor.hashCode ^
      nama.hashCode ^
      tglLahir.hashCode ^
      noIdentitas.hashCode ^
      nomorPonsel.hashCode ^
      bprLogo.hashCode ^
      bprNama.hashCode ^
      perbarindo.hashCode ^
      createdAt.hashCode ^
      sessionToken.hashCode ^
      loginDeviceId.hashCode ^
      loginDeviceName.hashCode ^
      loginExpiredAt.hashCode;
}
