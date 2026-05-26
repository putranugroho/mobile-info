import 'package:flutter/material.dart';
import 'package:mobile_info/models/users_model.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/dialog_loading.dart';

import '../../network/network.dart';
import '../../utils/dialog_custom.dart';

class EditProfileNotifier extends ChangeNotifier {
  final BuildContext context;

  EditProfileNotifier({required this.context}) {
    _init();
  }

  UsersModel? users;
  final keyForm = GlobalKey<FormState>();

  TextEditingController nama = TextEditingController();
  TextEditingController noHp = TextEditingController();
  TextEditingController tglLahir = TextEditingController();

  Future<void> _init() async {
    users = await Pref().getUsers();
    nama.text = users?.nama ?? '';
    noHp.text = users?.nomorPonsel ?? '';
    tglLahir.text = users?.tglLahir ?? '';
    notifyListeners();
  }

  Future<void> pilihTanggal() async {
    DateTime initial = DateTime.now();
    try {
      if (tglLahir.text.isNotEmpty) {
        initial = DateTime.parse(tglLahir.text);
      }
    } catch (_) {}

    if (!context.mounted) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      tglLahir.text =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      notifyListeners();
    }
  }

  Future<void> simpan() async {
    if (!keyForm.currentState!.validate()) return;
    if (users == null) return;
    if (!context.mounted) return;

    DialogCustom().showLoading(context);
    try {
      final resp = await AuthRepository.updateProfileMedfo(
        token,
        NetworkURL.updateProfileMedfo(),
        users!.id,
        nama.text.trim(),
        noHp.text.trim(),
        tglLahir.text.trim(),
      );
      if (!context.mounted) return;
      Navigator.pop(context); // tutup loading

      if (resp['value'] == 1) {
        final updated = users!.copyWith(
          nama: nama.text.trim(),
          nomorPonsel: noHp.text.trim(),
          tglLahir: tglLahir.text.trim(),
        );
        await Pref().simpan(updated);
        users = updated;
        notifyListeners();

        if (!context.mounted) return;
        // Tampilkan alert, setelah OK tutup halaman edit
        await showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (ctx) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 48),
                const SizedBox(height: 8),
                Text(
                  resp['message'] ?? 'Profil berhasil diperbarui',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Ok'),
                ),
              ],
            ),
          ),
        );
        if (!context.mounted) return;
        Navigator.pop(context); // kembali ke ProfilePage
      } else {
        await showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (ctx) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                Text(
                  resp['message'] ?? 'Gagal memperbarui profil',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Ok'),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context);
      CustomDialog.messageResponse(context, 'Terjadi kesalahan, coba lagi');
    }
  }
}
