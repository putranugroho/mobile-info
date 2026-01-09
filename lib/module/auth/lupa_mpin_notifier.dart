import 'package:flutter/material.dart';

class LupaMpinNotifier extends ChangeNotifier {
  final BuildContext context;

  LupaMpinNotifier({required this.context});

  TextEditingController usersId = TextEditingController();
  TextEditingController noRekening = TextEditingController();
  TextEditingController kataSandi = TextEditingController();
  final keyForm = GlobalKey<FormState>();
  var obSecure = true;
  gantiObsecure() {
    obSecure = !obSecure;
    notifyListeners();
  }

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  simpan() async {}
}
