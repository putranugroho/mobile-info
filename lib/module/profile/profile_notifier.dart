import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_info/module/auth/login_page.dart';
import 'package:mobile_info/module/repository/auth_repository.dart';
import 'package:mobile_info/pref/pref.dart';

import 'package:file_picker/file_picker.dart';
import 'package:mobile_info/utils/button_custom.dart';
import 'package:mobile_info/utils/dialog_loading.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../utils/dialog_custom.dart';

class ProfileNotiifer extends ChangeNotifier {
  final BuildContext context;

  ProfileNotiifer({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      notifyListeners();
    });
  }

  List<PlatformFile>? images;
  final picker = ImagePicker();
  File? image;
  Uint8List? byts;
  ambilCover() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1280,
      maxWidth: 720,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
      upload();
    } else {
      print('No image selected.');
    }
  }

  var hide = true;
  gantihide() {
    hide = !hide;
    notifyListeners();
  }

  upload() async {
    DialogCustom().showLoading(context);
    AuthRepository.gantiPhoto(
      token,
      NetworkURL.gantiPhoto(),
      users!.id,
      image,
    ).then((value) {
      Navigator.pop(context);
      if (value['value'] == 1) {
        // Pref().simpanPhoto(value['image']);
        CustomDialog.messageResponse(context, value['message']);
        getProfile();
      } else {
        CustomDialog.messageResponse(context, value['message']);
      }
    });
  }

  confirm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Anda yakin akan keluar IBPR?"),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ButtonSecondary(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      name: "Tidak",
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ButtonPrimary(
                      onTap: () {
                        Navigator.pop(context);
                        keluar();
                      },
                      name: "Ya",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  keluar() {
    Pref().remove();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }
}
