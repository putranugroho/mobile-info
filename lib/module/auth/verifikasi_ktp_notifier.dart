import 'dart:convert';

// import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_info/main.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/dialog_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
// import 'package:mobile_info/utils/pin_code_textfield.dart';

import '../../network/network.dart';
import '../../utils/colors.dart';
import '../../utils/notification_api.dart';
// import '../../utils/pin_code_textfield.dart';

class VerifikasiKTPNotifier extends ChangeNotifier {
  final BuildContext context;

  VerifikasiKTPNotifier({required this.context}) {
    getProfile();
    _hiddenController.addListener(() {
      if (_hiddenController.text.length <= 6) {
        pinController.text = _hiddenController.text;
      }
    });
  }
  List<BprModel> list = [];
  BprModel? bprModel;
  var isLoading = true;

  final FocusNode otpFocusNode = FocusNode();

  getProfile() async {
    isLoading = true;
    list.clear();
    notifyListeners();
    FirebaseMessaging.instance.getToken().then((value) {
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
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        pinTransaksi();
      } else {
        CustomDialog.messageResponse(context, value['message']);
        ketmu = false;
        notifyListeners();
      }
    });
  }

  final FocusNode _hiddenFocus = FocusNode();
  final TextEditingController _hiddenController = TextEditingController();

  TextEditingController pinController = TextEditingController();
  var obSecurePin = true;
  var hasError = false;
  pinTransaksi() {
    smsController.clear();
    notifyListeners();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
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
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.arrow_back, size: 24),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "OTP",
                        style: TextStyle(
                          fontFamily: "Satoshi",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 48,
                        width: 48,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF5F5F5),
                        ),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  "Masukan OTP Kamu...",
                  style: TextStyle(
                    fontFamily: "Satoshi",
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Silahkan cek OTP Verifikasi akun Anda",
                  style: TextStyle(fontFamily: "Satoshi", fontSize: 16),
                ),
                SizedBox(height: 20),
                PinCodeTextField(
                  pinBoxHeight: 52,
                  pinBoxWidth: 48,
                  // autofocus: true,
                  keyboardType: TextInputType.number,
                  controller: smsController,
                  hideCharacter: false,
                  highlight: false,
                  // maskCharacter: "⚫",
                  highlightColor: Colors.black,
                  defaultBorderColor: Colors.black,
                  hasTextBorderColor: Colors.black,
                  maxLength: 6,
                  hasError: hasError,
                  onTextChanged: (text) {},
                  onDone: (text) {
                    // value.login();
                    // value.authentication();
                  },
                  wrapAlignment: WrapAlignment.start,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 18),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.defaultNoTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 50),
                ),

                SizedBox(height: 24),
                ButtonPrimary(
                  onTap: () {
                    Navigator.pop(context);
                    verify();
                  },
                  name: "Continue",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  verify() async {
    DialogCustom().showLoading(context);
    AuthRepository.verifyOtp(
      token,
      NetworkURL.verifyOtp(),
      nomorPonsel.text.trim(),
      smsController.text.trim(),
    ).then((value) {
      Navigator.pop(context);
      if (value['status']) {
        ketmu = true;
        namaLengkap.text = value['user']['nama'];
        notifyListeners();
      } else {
        ketmu = false;
        CustomDialog.messageResponse(context, value['message']);
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
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': _messageCount.toString(),
      },
      'notification': {
        'title': 'RAHASIAKAN MPIN ANDA',
        'body': 'M PIN Anda adalah $mpin',
      },
    });
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
    DialogCustom().showLoading(context);
    AuthRepository.aktivasiMobileInfo(
      NetworkURL.aktivasiAkun(),
      nomorPonsel.text.trim(),
      userId.text.trim(),
      kataSandi.text.trim(),
    ).then((values) {
      Navigator.pop(context);
      if (values['status']) {
        Navigator.pop(context);
        CustomDialog.messageResponse(context, values['message']);
      } else {
        CustomDialog.messageResponse(context, values['message']);
      }
    });
  }
}
