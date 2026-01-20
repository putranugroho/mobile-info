import 'package:mobile_info/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static String id = "id";
  static String noCif = "no_cif";
  static String usersId = "users_id";
  static String bprId = "bpr_id";
  static String nama = "nama";
  static String tglLahir = "tgl_lahir";
  static String noIdentitas = "no_identitas";
  static String nomorPonsel = "nomor_ponsel";
  static String bprLogo = "bpr_logo";
  static String bprNama = "bpr_nama";
  static String perbarindo = "perbarindo";
  static String createdAt = "created_at";
  static String token = "token";

  saveToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.token, token);
  }

  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(Pref.token) ?? "";
  }

  simpan(UsersModel users) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(Pref.id, users.id);
    pref.setString(Pref.noCif, users.noCif);
    pref.setString(Pref.usersId, users.usersId);
    pref.setString(Pref.bprId, users.bprId);
    pref.setString(Pref.nama, users.nama);
    pref.setString(Pref.tglLahir, users.tglLahir);
    pref.setString(Pref.perbarindo, users.perbarindo);
    pref.setString(Pref.noIdentitas, users.noIdentitas);
    pref.setString(Pref.nomorPonsel, users.nomorPonsel);
    pref.setString(Pref.bprLogo, users.bprLogo);
    pref.setString(Pref.bprNama, users.bprNama);
    pref.setString(Pref.createdAt, users.createdAt);
  }

  Future<UsersModel> getUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UsersModel users = UsersModel(
      id: pref.getInt(Pref.id) ?? 0,
      noCif: pref.getString(Pref.noCif) ?? "",
      usersId: pref.getString(Pref.usersId) ?? "",
      bprId: pref.getString(Pref.bprId) ?? "",
      nama: pref.getString(Pref.nama) ?? "",
      perbarindo: pref.getString(Pref.perbarindo) ?? "",
      tglLahir: pref.getString(Pref.tglLahir) ?? "",
      noIdentitas: pref.getString(Pref.noIdentitas) ?? "",
      nomorPonsel: pref.getString(Pref.nomorPonsel) ?? "",
      bprLogo: pref.getString(Pref.bprLogo) ?? "",
      bprNama: pref.getString(Pref.bprNama) ?? "",
      createdAt: pref.getString(Pref.createdAt) ?? "",
    );
    return users;
  }

  remove() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Pref.id);
    pref.remove(Pref.noCif);
    pref.remove(Pref.usersId);
    pref.remove(Pref.bprId);
    pref.remove(Pref.nama);
    pref.remove(Pref.tglLahir);
    pref.remove(Pref.noIdentitas);
    pref.remove(Pref.nomorPonsel);
    pref.remove(Pref.perbarindo);
    pref.remove(Pref.bprLogo);
    pref.remove(Pref.bprNama);
    pref.remove(Pref.createdAt);
  }
}
