import 'package:ibpr/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  static String id = "id";
  static String nocif = "nocif";
  static String namaLengkap = "nama_lengkap";
  static String usersId = "users_id";
  static String bprId = "bpr_id";
  static String bprNama = "bpr_nama";
  static String bprLogo = "bpr_logo";
  static String noRekening = "no_rekening";
  static String nomorPonsel = "nomor_ponsel";
  static String noKtp = "no_ktp";
  static String photo = "photo";
  static String createdDate = "createdDate";

  simpanPhoto(String photo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Pref.photo, photo);
  }

  simpan(UsersModel users) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(Pref.id, users.id);
    pref.setString(Pref.namaLengkap, users.namaLengkap);
    pref.setString(Pref.bprId, users.bprId);
    pref.setString(Pref.usersId, users.usersId);
    pref.setString(Pref.bprNama, users.bprNama);
    pref.setString(Pref.bprLogo, users.bprLogo);
    pref.setString(Pref.noRekening, users.noRekening);
    pref.setString(Pref.nomorPonsel, users.nomorPonsel);
    pref.setString(Pref.noKtp, users.noKtp);
    pref.setString(Pref.photo, users.photo);
    pref.setString(Pref.createdDate, users.createdDate);
  }

  Future<UsersModel> getUsers() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UsersModel users = UsersModel(
      id: pref.getInt(Pref.id) ?? 0,
      nocif: pref.getString(Pref.nocif) ?? "",
      namaLengkap: pref.getString(Pref.namaLengkap) ?? "",
      usersId: pref.getString(Pref.usersId) ?? "",
      bprId: pref.getString(Pref.bprId) ?? "",
      bprLogo: pref.getString(Pref.bprLogo) ?? "",
      bprNama: pref.getString(Pref.bprNama) ?? "",
      noRekening: pref.getString(Pref.noRekening) ?? "",
      nomorPonsel: pref.getString(Pref.nomorPonsel) ?? "",
      noKtp: pref.getString(Pref.noKtp) ?? "",
      photo: pref.getString(Pref.photo) ?? "",
      createdDate: pref.getString(Pref.createdDate) ?? "",
    );
    return users;
  }

  remove() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Pref.id);
    pref.remove(Pref.namaLengkap);
    pref.remove(Pref.usersId);
    pref.remove(Pref.bprId);
    pref.remove(Pref.bprNama);
    pref.remove(Pref.noRekening);
    pref.remove(Pref.nomorPonsel);
    pref.remove(Pref.noKtp);
    pref.remove(Pref.photo);
    pref.remove(Pref.createdDate);
    pref.remove(Pref.bprLogo);
  }
}
