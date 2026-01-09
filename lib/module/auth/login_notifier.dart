import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ibpr/models/index.dart';
import 'package:ibpr/module/auth/lupa_mpin_page.dart';
import 'package:ibpr/module/auth/lupa_sandi_page.dart';
import 'package:ibpr/module/auth/verifikasi_ktp_page.dart';
import 'package:ibpr/module/menu_page/menu_page.dart';
import 'package:ibpr/module/repository/auth_repository.dart';
import 'package:ibpr/pref/pref.dart';
import 'package:ibpr/services/auth_service.dart';
import 'package:ibpr/utils/dialog_custom.dart';
import 'package:ibpr/utils/dialog_loading.dart';
import '../../network/network.dart';

class LoginNotifier extends ChangeNotifier {
  final BuildContext context;

  LoginNotifier({required this.context}) {
    getProfile();
  }

  String? fcmToken;
  getProfile() async {
    // FirebaseMessaging.instance.getToken().then((value) {
    //   fcmToken = value;
    //   notifyListeners();
    // });
    deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  }

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'systemFeatures': build.systemFeatures,
      'serialNumber': build.serialNumber,
    };
  }

  var deviceData = <String, dynamic>{};

  TextEditingController usersId = TextEditingController();
  TextEditingController password = TextEditingController();
  final keyForm = GlobalKey<FormState>();

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  var obSecure = true;

  gantiObsecure() {
    obSecure = !obSecure;
    notifyListeners();
  }

  simpan() async {
    DialogCustom().showLoading(context);
    AuthRepository.login(
      token,
      NetworkURL.login(),
      usersId.text.trim(),
      "",
      password.text.trim(),
      "",
    ).then((value) async {
      Navigator.pop(context);
      if (value['value'] == 1) {
        UsersModel users = UsersModel.fromJson(value);
        Pref().simpan(users);
        await AuthService.setLoggedIn(true);
        context.go('/menu');
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }

  aktivasiAkun() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerifikasiKTPPage()),
    );
  }

  lupaPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LupaSandiPage()),
    );
  }

  lupaMpin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LupaMpinPage()),
    );
  }
}
