// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile_info/models/index.dart';
// import 'package:mobile_info/module/menu_page/menu_page.dart';
// import 'package:mobile_info/pref/pref.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class DashboardNotifier extends ChangeNotifier {
//   final BuildContext context;

//   DashboardNotifier({required this.context}) {
//     getProfile();
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//     context.go('/login');
//   }

//   var isLoading = true;

//   List<UserIbprModel> list = [];

//   Future<void> getProfile() async {
//     isLoading = true;
//     list.clear();
//     notifyListeners();

//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');

//       if (token == null) {
//         await logout();
//         return;
//       }

//       final result = await http.get(
//         Uri.parse(
//           "https://infoservices.medtrans.id/webServices/users-ibpr.php",
//         ),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (result.statusCode == 200) {
//         for (Map<String, dynamic> i in jsonDecode(result.body)['data']) {
//           list.add(UserIbprModel.fromJson(i));
//         }
//         isLoading = false;
//         notifyListeners();
//       } else {
//         await logout();
//       }
//     } catch (_) {
//       await logout();
//     }
//   }

//   pilihAkun(UserIbprModel value) {
//     UsersModel users = UsersModel(
//       id: value.id,
//       nocif: value.nocif,
//       namaLengkap: value.namaLengkap,
//       usersId: value.usersId,
//       bprId: value.bprId,
//       bprLogo: value.bprLogo,
//       bprNama: value.bprNama,
//       noRekening: value.noRekening,
//       nomorPonsel: value.nomorPonsel,
//       noKtp: value.noKtp,
//       photo: value.photo,
//       createdDate: value.createdDate,
//     );
//     Pref().simpan(users);
//     context.go('/menu');
//   }
// }
