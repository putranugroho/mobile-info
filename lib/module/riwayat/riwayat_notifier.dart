import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/module/repository/history_repository.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:intl/intl.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

// import '../../models/users_model.dart';
import '../../network/network.dart';
import '../../utils/button_custom.dart';

class RiwayatNotifier extends ChangeNotifier {
  final BuildContext context;

  RiwayatNotifier({required this.context}) {
    getProfile();
  }

  UsersModel? users;
  getProfile() async {
    Pref().getUsers().then((value) {
      users = value;
      getRiwayat();
      notifyListeners();
    });
  }

  DateTime tglAwal = DateTime.now();
  DateTime tglAkhir = DateTime.now();

  pilihTanggalAwal() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: tglAwal,
                  onDateTimeChanged: (e) {
                    tglAwal = e;

                    notifyListeners();
                  },
                ),
              ),
              SizedBox(height: 16),
              ButtonPrimary(
                onTap: () {
                  Navigator.pop(context);
                  getRiwayat();
                },
                name: "Simpan",
              ),
            ],
          ),
        );
      },
    );
  }

  pilihTanggalAkhir() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: ScrollDatePicker(
                  selectedDate: tglAkhir,
                  onDateTimeChanged: (e) {
                    tglAkhir = e;
                    notifyListeners();
                  },
                ),
              ),
              SizedBox(height: 16),
              ButtonPrimary(
                onTap: () {
                  Navigator.pop(context);
                  getRiwayat();
                },
                name: "Simpan",
              ),
            ],
          ),
        );
      },
    );
  }

  var isLoading = true;
  List<HistoryModel> list = [];
  int limit = 20;
  int offset = 0;
  Future getRiwayat() async {
    list.clear();
    isLoading = true;
    notifyListeners();
    HistoryRepository.riwayat(
      token,
      NetworkURL.riwayat(),
      users!.nomorPonsel,
      users!.bprId,
      limit,
      offset,
      DateFormat('y-MM-d').format(tglAwal),
      DateFormat('y-MM-d').format(tglAkhir),
    ).then((value) {
      if (value['value'] == 1) {
        for (Map<String, dynamic> i in value['history']) {
          list.add(HistoryModel.fromJson(i));
        }
        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
