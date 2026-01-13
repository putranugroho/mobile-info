import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/main.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:http/http.dart' as http;

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/notification_api.dart';
import '../../utils/pin_code_textfield.dart';

class VerifikasiKTPNotifier extends ChangeNotifier {
  final BuildContext context;

  VerifikasiKTPNotifier({required this.context}) {
    getProfile();
  }
  List<BprModel> list = [];
  BprModel? bprModel;
  var isLoading = true;

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

  getProfile() async {
    isLoading = true;
    list.clear();
    notifyListeners();
    FirebaseMessaging.instance.getToken().then((value) {
      fCMtoken = value;
      print("TOKEN $fCMtoken");
      getList();
      notifyListeners();
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage messages) async {
      // NotificationApi.notifications.show(
      //     1,
      //     messages.notification!.title,
      //     messages.notification!.body,
      //     await NotificationApi.notificationDetails());
    });
    deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    print("${deviceData['id']}");
    notifyListeners();
  }

  getList() {
    AuthRepository.listBpr(token, NetworkURL.listBpr()).then((value) {
      if (value['code'] == "000") {
        for (Map<String, dynamic> i in value['data']) {
          list.add(BprModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  gantiBpr(BprModel value) {
    bprModel = value;
    notifyListeners();
  }

  TextEditingController noKtp = TextEditingController();
  TextEditingController noRekening = TextEditingController();
  TextEditingController nomorPonsel = TextEditingController();

  final keyForm = GlobalKey<FormState>();

  cek() async {
    if (keyForm.currentState!.validate()) {
      simpan();
    }
  }

  var ketmu = false;
  AktivasiUsersModel? aktivasiUsersModel;
  List<AktivasiUsersModel> listUser = [];
  TextEditingController namaLengkap = TextEditingController();

  TextEditingController userId = TextEditingController();
  TextEditingController kataSandi = TextEditingController();
  TextEditingController konfirmasiKataSandi = TextEditingController();

  simpan() async {
    DialogCustom().showLoading(context);
    AuthRepository.validasiKtp(
      token,
      NetworkURL.validasiKtp(),
      noKtp.text.trim(),
      bprModel!.bprId,
      nomorPonsel.text.trim(),
      noRekening.text.trim(),
      fCMtoken!,
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        var status = value['data']['status_data'];
        if (status == "0") {
          ketmu = true;
          namaLengkap.text = value['data']['nama'];

          notifyListeners();
        } else {
          CustomDialog.messageResponse(context, value['data']['message']);
        }
      } else {
        CustomDialog.messageResponse(context, value['message']);
        ketmu = false;
        notifyListeners();
      }
    });
  }

  Future<void> getPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }
  }

  pin() async {
    if (keyForm.currentState!.validate()) {
      pinTransaksiBank();
    }
  }

  TextEditingController smsController = TextEditingController();
  int _messageCount = 0;
  String constructFCMPayload(String? token, String mpin) {
    _messageCount++;
    return jsonEncode({
      'token': token,
      'data': {'via': 'FlutterFire Cloud Messaging!!!', 'count': _messageCount.toString()},
      'notification': {'title': 'RAHASIAKAN MPIN ANDA', 'body': 'M PIN Anda adalah $mpin'},
    });
  }

  String? fCMtoken;
  Future<void> sendPushMessage(String mpin) async {
    if (fCMtoken == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
        body: constructFCMPayload(fCMtoken, mpin),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  var obSecure1 = true;
  var obSecure2 = true;

  gantiObsecure1() async {
    obSecure1 = !obSecure1;
    notifyListeners();
  }

  gantiObsecure2() async {
    obSecure2 = !obSecure2;
    notifyListeners();
  }

  pinTransaksiBank() async {
    smsController.clear();
    notifyListeners();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(width: 48, height: 48, child: Icon(Icons.arrow_back, size: 24)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "PIN",
                        style: TextStyle(fontFamily: "Satoshi", fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF5F5F5)),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(height: 12),
                Text(
                  "Masukan MPIN Kamu...",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Mohon masukan MPIN kamu untuk transaksi", style: TextStyle(fontFamily: "Satoshi", fontSize: 16)),
                SizedBox(height: 20),
                PinCodeTextField(
                  pinBoxHeight: 52,
                  pinBoxWidth: 48,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: smsController,
                  hideCharacter: true,
                  highlight: false,
                  maskCharacter: "⚫",
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.grey[300] ?? Colors.transparent,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  onTextChanged: (text) {},
                  onDone: (text) {
                    // value.login();
                  },
                  pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.normal,
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 8.0),
                  pinTextAnimatedSwitcherTransition: ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    cekPin();
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: colorPrimary),
                    child: Text(
                      "lanjut",
                      style: TextStyle(fontFamily: "Satoshi", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  cekPin() async {
    DialogCustom().showLoading(context);
    AuthRepository.mPinGenerated(
      token,
      NetworkURL.generatedMpin(),
      "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}${nomorPonsel.text.substring((nomorPonsel.text.length - 4), nomorPonsel.text.length)}",
    ).then((value) {
      if (value['data']['code'] == "000") {
        var mpIn = value['data']['data'];
        AuthRepository.aktivasiAkun(
          token,
          NetworkURL.aktivasiAkun(),
          namaLengkap.text.trim(),
          mpIn,
          // "${smsController.text.trim()}${nomorPonsel.text.substring((nomorPonsel.text.length - 4), nomorPonsel.text.length)}",
          // "${(((int.parse((smsController.text)) * 2) + 999999) - 111111).toString()}${nomorPonsel.text.substring((nomorPonsel.text.length - 4), nomorPonsel.text.length)}",
          noRekening.text.trim(),
          nomorPonsel.text.trim(),
          noKtp.text.trim(),
          bprModel!.bprId,
          userId.text.trim(),
          kataSandi.text.trim(),
          deviceData['id'],
          bprModel!.bprLogo,
        ).then((values) {
          Navigator.pop(context);
          if (values['value'] == 1) {
            Navigator.pop(context);
            CustomDialog.messageResponse(context, values['data']['message']);
          } else {
            CustomDialog.messageResponse(context, values['message']);
          }
        });
      }
    });
  }
}
