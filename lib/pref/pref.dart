import 'dart:math';

import 'package:mobile_info/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static String id = "id";
  static String noCif = "no_cif";
  static String usersId = "users_id";
  static String bprId = "bpr_id";
  static String kdKantor = "kd_kantor";
  static String nama = "nama";
  static String tglLahir = "tgl_lahir";
  static String noIdentitas = "no_identitas";
  static String nomorPonsel = "nomor_ponsel";
  static String bprLogo = "bpr_logo";
  static String bprNama = "bpr_nama";
  static String perbarindo = "perbarindo";
  static String createdAt = "created_at";
  static String token = "token";
  static String splashShownAfterLogin = "splash_shown_after_login";

  static String sessionToken = "session_token";
  static String loginDeviceId = "login_device_id";
  static String loginDeviceName = "login_device_name";
  static String loginExpiredAt = "login_expired_at";
  static String appDeviceId = "app_device_id";

  Future<String> getOrCreateAppDeviceId({required String prefix}) async {
    final pref = await SharedPreferences.getInstance();
    final existing = pref.getString(Pref.appDeviceId) ?? "";

    if (existing.isNotEmpty) {
      return existing;
    }

    final random = Random.secure().nextInt(999999999).toString().padLeft(9, '0');
    final safePrefix = prefix.trim().isNotEmpty ? prefix.trim() : "mobile-info";
    final newDeviceId = "$safePrefix-${DateTime.now().microsecondsSinceEpoch}-$random";
    await pref.setString(Pref.appDeviceId, newDeviceId);
    return newDeviceId;
  }

  saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.token, token);
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Pref.token) ?? "";
  }

  setSplashShownAfterLogin(bool value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(Pref.splashShownAfterLogin, value);
  }

  Future<bool> getSplashShownAfterLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(Pref.splashShownAfterLogin) ?? false;
  }

  simpan(UsersModel users) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(Pref.id, users.id);
    pref.setString(Pref.noCif, users.noCif);
    pref.setString(Pref.usersId, users.usersId);
    pref.setString(Pref.bprId, users.bprId);
    pref.setString(Pref.kdKantor, users.kdKantor);
    pref.setString(Pref.nama, users.nama);
    pref.setString(Pref.tglLahir, users.tglLahir);
    pref.setString(Pref.perbarindo, users.perbarindo);
    pref.setString(Pref.noIdentitas, users.noIdentitas);
    pref.setString(Pref.nomorPonsel, users.nomorPonsel);
    pref.setString(Pref.bprLogo, users.bprLogo);
    pref.setString(Pref.bprNama, users.bprNama);
    pref.setString(Pref.createdAt, users.createdAt);
    await pref.setString(Pref.sessionToken, users.sessionToken);
    await pref.setString(Pref.loginDeviceId, users.loginDeviceId);
    await pref.setString(Pref.loginDeviceName, users.loginDeviceName);
    await pref.setString(Pref.loginExpiredAt, users.loginExpiredAt);
  }

  Future<UsersModel> getUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UsersModel users = UsersModel(
      id: pref.getInt('id') ?? 0,
      noCif: pref.getString('no_cif') ?? '',
      usersId: pref.getString('users_id') ?? '',
      bprId: pref.getString('bpr_id') ?? '',
      kdKantor: pref.getString(Pref.kdKantor) ?? '',
      nama: pref.getString('nama') ?? '',
      tglLahir: pref.getString('tgl_lahir') ?? '',
      noIdentitas: pref.getString('no_identitas') ?? '',
      nomorPonsel: pref.getString('nomor_ponsel') ?? '',
      bprLogo: pref.getString('bpr_logo') ?? '',
      bprNama: pref.getString('bpr_nama') ?? '',
      perbarindo: pref.getString('perbarindo') ?? '',
      createdAt: pref.getString('created_at') ?? '',

      // tambahan baru
      sessionToken: pref.getString(Pref.sessionToken) ?? '',
      loginDeviceId: pref.getString(Pref.loginDeviceId) ?? '',
      loginDeviceName: pref.getString(Pref.loginDeviceName) ?? '',
      loginExpiredAt: pref.getString(Pref.loginExpiredAt) ?? '',
    );
    return users;
  }

  Future<void> updateLoginSession({
    String? sessionToken,
    String? loginDeviceId,
    String? loginDeviceName,
    String? loginExpiredAt,
    String? kdKantor,
  }) async {
    final pref = await SharedPreferences.getInstance();

    if (sessionToken != null) {
      await pref.setString(Pref.sessionToken, sessionToken);
    }
    if (loginDeviceId != null) {
      await pref.setString(Pref.loginDeviceId, loginDeviceId);
    }
    if (loginDeviceName != null) {
      await pref.setString(Pref.loginDeviceName, loginDeviceName);
    }
    if (loginExpiredAt != null) {
      await pref.setString(Pref.loginExpiredAt, loginExpiredAt);
    }
    final normalizedKantor = kdKantor?.trim() ?? '';
    if (normalizedKantor.isNotEmpty) {
      await pref.setString(Pref.kdKantor, normalizedKantor);
    }
  }

  Future<void> mergeSessionProfileFromMap(Map<String, dynamic> data) async {
    final kantor = '${data['kd_kantor'] ?? data['kdKantor'] ?? ''}'.trim();
    await updateLoginSession(
      loginExpiredAt: '${data['login_expired_at'] ?? ''}'.trim().isEmpty ? null : '${data['login_expired_at']}',
      kdKantor: kantor.isEmpty ? null : kantor,
    );
  }

  remove() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Pref.id);
    pref.remove(Pref.noCif);
    pref.remove(Pref.usersId);
    pref.remove(Pref.bprId);
    pref.remove(Pref.kdKantor);
    pref.remove(Pref.nama);
    pref.remove(Pref.tglLahir);
    pref.remove(Pref.noIdentitas);
    pref.remove(Pref.nomorPonsel);
    pref.remove(Pref.perbarindo);
    pref.remove(Pref.bprLogo);
    pref.remove(Pref.bprNama);
    pref.remove(Pref.createdAt);
    pref.remove(Pref.splashShownAfterLogin);
    pref.remove(Pref.token);
    pref.remove(Pref.sessionToken);
    pref.remove(Pref.loginDeviceId);
    pref.remove(Pref.loginDeviceName);
    pref.remove(Pref.loginExpiredAt);
  }
}
