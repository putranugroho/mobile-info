import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mobile_info/models/loan_application_model.dart';
import 'package:mobile_info/network/network.dart';

class LoanApplicationRepository {
  /// Untuk produksi harus false agar data benar-benar dikirim ke endpoint.
  /// Ubah sementara ke true hanya saat debug payload multipart tanpa menyimpan data.
  static const bool debugDryRunSubmit = false;

  static Future<LoanSetupPinjamanModel> inquirySetupPinjaman({required String bprId, required String flag}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquirySetupPinjaman(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB", "flag": flag});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("INQUIRY SETUP PINJAMAN FLAG $flag RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) {
      throw Exception("Response setup pinjaman tidak valid.");
    }

    if (res['code'] != '000') {
      throw Exception(res['message'] ?? "Layanan pengajuan pinjaman belum tersedia.");
    }

    final data = res['data'];
    if (data is! Map<String, dynamic>) {
      throw Exception("Data setup pinjaman tidak valid.");
    }

    return LoanSetupPinjamanModel.fromJson(data);
  }

  static Future<List<LoanJaminanModel>> inquiryJaminanAll({required String bprId}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquiryJaminanAll(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB"});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response jaminan tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal mengambil data jaminan.");

    final data = res['data'];
    if (data is! List) return [];

    return data.map((e) => LoanJaminanModel.fromJson(Map<String, dynamic>.from(e))).where((e) => e.status == "A" && e.kdJaminan.isNotEmpty).toList();
  }

  static Future<LoanSimulationResultModel> simulasiTagihan({
    required String bprId,
    required int nilaiPinjaman,
    required int jangkaWaktu,
    required double rate,
  }) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(
      NetworkURL.simulasiTagihanPinjaman(),
      data: {"bpr_id": bprId, "nilai_pinjaman": nilaiPinjaman, "jangka_waktu": jangkaWaktu, "rate": rate, "jenis_rate": "F"},
    );

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response simulasi tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal menghitung simulasi pinjaman.");

    final data = res['data'];
    if (data is! Map<String, dynamic>) throw Exception("Data simulasi tidak valid.");

    return LoanSimulationResultModel.fromJson(data);
  }

  static Future<dynamic> submitLoanApplication({
    required String bprId,
    required LoanApplicationFormModel form,
    required String kdKantor,
  }) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final normalizedKantor = kdKantor.trim();
    if (normalizedKantor.isEmpty) {
      throw Exception("Kode kantor wajib diisi (ambil dari session login nasabah).");
    }

    final formData = FormData.fromMap({
      "bpr_id": bprId,
      "user_login": "SYSTEM",
      "no_cif": form.noCif,
      "cif": form.noCif,
      "term": "web",
      "no_id": form.noId,
      "nama": form.nama,
      "no_hp": form.noHp,
      "alamat": form.alamat,
      "kd_kantor": normalizedKantor,
      "jaminan": form.jaminan,
      "nilai_pinjaman": form.nilaiPinjaman,
      "jk_waktu": form.jkWaktu,
      "rate": form.rate,
      "cicilan": form.cicilan,
    });

    if (form.fotoJaminanBytes != null && form.fotoJaminanBytes!.isNotEmpty) {
      formData.files.add(
        MapEntry(
          "fhoto_jaminan",
          MultipartFile.fromBytes(
            form.fotoJaminanBytes!,
            filename: form.fotoJaminanName ?? "foto_jaminan.jpg",
            contentType: _fotoJaminanContentType(form.fotoJaminanMimeType),
          ),
        ),
      );
    }

    _debugSubmitLoanMultipart(formData, form);

    if (debugDryRunSubmit) {
      if (kDebugMode) {
        print("========== DRY RUN SUBMIT PINJAMAN ==========");
        print("Submit ke endpoint DIBATALKAN karena debugDryRunSubmit = true.");
        print("Data TIDAK dikirim dan TIDAK tersimpan di backend.");
        print("Untuk submit asli, ubah debugDryRunSubmit menjadi false.");
        print("=============================================");
      }

      return {
        "code": "000",
        "status": "debug_dry_run",
        "message": "DEBUG ONLY: payload berhasil dibentuk, tetapi tidak dikirim ke endpoint.",
        "data": {
          "dry_run": true,
          "endpoint": NetworkURL.daftarPermohonanPinjaman(),
          "file_field": "fhoto_jaminan",
          "foto_source": form.fotoJaminanSource,
          "foto_filename": form.fotoJaminanName,
          "foto_mime_type": form.fotoJaminanMimeType,
          "foto_size_bytes": form.fotoJaminanSizeBytes ?? form.fotoJaminanBytes?.length ?? 0,
        },
      };
    }

    final response = await dio.post(
      NetworkURL.daftarPermohonanPinjaman(),
      data: formData,
      onSendProgress: (sent, total) {
        if (kDebugMode) {
          print("SUBMIT LOAN UPLOAD PROGRESS: $sent / $total");
        }
      },
    );
    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("SUBMIT LOAN FIELDS: ${formData.fields}");
      print("SUBMIT LOAN FILES: ${formData.files.map((e) => e.value.filename).toList()}");
      print("SUBMIT LOAN RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) throw Exception("Response permohonan pinjaman tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal mendaftarkan permohonan pinjaman.");

    return res;
  }


  static MediaType _fotoJaminanContentType(String? mimeType) {
    final mime = (mimeType ?? '').toLowerCase().trim();

    if (mime == 'image/png') return MediaType('image', 'png');
    if (mime == 'image/webp') return MediaType('image', 'webp');

    // Hasil dari notifier sudah dinormalisasi menjadi JPEG.
    return MediaType('image', 'jpeg');
  }

  static void _debugSubmitLoanMultipart(FormData formData, LoanApplicationFormModel form) {
    if (!kDebugMode) return;

    print("========== DEBUG SUBMIT PINJAMAN MULTIPART ==========");
    print("endpoint              : ${NetworkURL.daftarPermohonanPinjaman()}");
    print("field_file_name       : fhoto_jaminan");
    print("foto_source           : ${form.fotoJaminanSource}");
    print("foto_filename         : ${form.fotoJaminanName}");
    print("foto_mime_type        : ${form.fotoJaminanMimeType}");
    print("foto_size_bytes       : ${form.fotoJaminanSizeBytes ?? form.fotoJaminanBytes?.length ?? 0}");
    print("foto_bytes_null       : ${form.fotoJaminanBytes == null}");
    print("foto_bytes_empty      : ${form.fotoJaminanBytes?.isEmpty ?? true}");
    print("fields:");
    for (final field in formData.fields) {
      print("  ${field.key}: ${field.value}");
    }
    print("files:");
    for (final file in formData.files) {
      print("  field=${file.key}, filename=${file.value.filename}, length=${file.value.length}, contentType=${file.value.contentType}");
    }
    print("=====================================================");
  }

  /// Ambil semua username Pejabat aktif (role_user='1') di bpr yang sama --
  /// SAMA PERSIS pola yang dipakai untuk notifikasi deposito
  /// (_getAllPejabatUsername di deposit_opening_repository.dart), TAPI
  /// filter kd_kantor di sini OPSIONAL (kosong = tidak difilter per kantor).
  ///
  /// RIWAYAT: sebelumnya penerima notif pinjaman diambil lewat
  /// inquiryNotificationRecipients() yang memanggil /inquiry/notifikasi-pinjaman
  /// dengan filter bpr_id SAJA -- dan filter bpr_id itu sendiri TIDAK
  /// dihormati oleh endpoint tsb: pengajuan pinjaman nasabah bpr 609999
  /// kantor 001 sempat mengirim notif ke 5 penerima lintas BPR & lintas
  /// kantor (termasuk bpr 600931 yang BEDA BANK SAMA SEKALI). Endpoint
  /// /inquiry/data-petugas terbukti lebih bisa diandalkan, jadi sumbernya
  /// dipindah ke situ.
  ///
  /// kd_kantor SEMPAT dibuat wajib (fail-closed, tidak kirim sama sekali
  /// kalau kosong) supaya tidak menjangkau kantor lain seperti bug di
  /// atas -- tapi berdasarkan keputusan: sampai ada sumber kd_kantor
  /// nasabah yang bisa diandalkan untuk alur pinjaman (modul ini tidak
  /// lewat verifikasi OTP seperti deposito, jadi belum ada sumbernya),
  /// untuk SEMENTARA filter kd_kantor dibuat opsional -- kalau kosong,
  /// notif dikirim ke SEMUA Pejabat aktif se-BPR (bukan dibatalkan sama
  /// sekali). bpr_id TETAP WAJIB & di-double-check di client, supaya
  /// bug paling parah (notif nyasar lintas BPR/bank lain) tetap tertutup.
  static Future<List<String>> _getAllPejabatUsername({
    required String bprId,
    String kdKantor = '',
  }) async {
    final normalizedKantor = kdKantor.trim();
    final normalizedBprId = bprId.trim();
    if (normalizedBprId.isEmpty) {
      if (kDebugMode) print("⚠️ _getAllPejabatUsername (pinjaman) dipanggil tanpa bpr_id -- dibatalkan.");
      return [];
    }

    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final body = {
      "bpr_id": bprId,
      "filter": {
        "username": "",
        "nama": "",
        "no_hp": "",
        "kd_kantor": normalizedKantor,
        "no_identitas": "",
        "jabatan": "",
        "role_user": "1",
        "status": "",
        "status_aktif": "",
        "tgl_lahir_from": "",
        "tgl_lahir_to": "",
        "created_at_from": "",
        "created_at_to": "",
      },
      "sort": {"by": "created_at", "type": "desc"},
      "pagination": {"page": 1, "limit": 100},
    };

    if (kDebugMode) {
      print("ENDPOINT INQUIRY DATA PETUGAS (Pejabat pinjaman) : ${NetworkURL.inquiryDataPetugasMedfo()}");
      print("REQUEST INQUIRY DATA PETUGAS (Pejabat pinjaman) : $body");
      if (normalizedKantor.isEmpty) {
        print("⚠️ kd_kantor kosong -- notif pinjaman untuk SEMENTARA broadcast ke semua Pejabat se-BPR (belum di-scope per kantor).");
      }
    }

    try {
      final response = await dio.post(NetworkURL.inquiryDataPetugasMedfo(), data: body);
      final res = response.data is String ? jsonDecode(response.data) : response.data;

      if (kDebugMode) {
        print("RESPONSE INQUIRY DATA PETUGAS (Pejabat pinjaman) : $res");
      }

      if (res is! Map<String, dynamic>) return [];
      if ('${res['code'] ?? ''}' != '000') return [];

      // Parsing defensif -- sama seperti versi deposito, karena bentuk
      // `data` bisa berupa list langsung, {data:[...]}, atau {items:[...]}.
      final data = res['data'];
      List<dynamic> rows = [];
      if (data is List) {
        rows = data;
      } else if (data is Map) {
        if (data['data'] is List) {
          rows = data['data'];
        } else if (data['items'] is List) {
          rows = data['items'];
        }
      }

      return rows
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .where((e) {
            final roleUser = '${e['role_user'] ?? ''}'.trim();
            final status = '${e['status'] ?? e['status_aktif'] ?? ''}'.trim().toUpperCase();
            final kantorRow = '${e['kd_kantor'] ?? ''}'.trim();
            // CATATAN: item respons /inquiry/data-petugas TIDAK menyertakan
            // bpr_id sama sekali per baris (sudah dikonfirmasi dari log
            // asli), jadi tidak bisa di-double-check di sini seperti yang
            // sempat dicoba sebelumnya -- itu ternyata bikin SEMUA baris
            // ketolak diam-diam (bprRow selalu '', jadi tidak akan pernah
            // sama dengan normalizedBprId). Filter bpr_id sepenuhnya
            // diandalkan dari request (sudah terbukti benar lewat
            // pemakaian yang sama di alur deposito). kd_kantor tetap
            // dicek kalau memang diminta.
            //
            // deleted_at SENGAJA TIDAK dipakai sebagai filter (sempat
            // dicoba, lalu dibatalkan): alurnya di backend ternyata
            // dibuat -> dihapus (status A->C, deleted_at keisi) -> dibuat
            // ulang (status C->A lagi, TAPI deleted_at dibiarkan tetap
            // keisi, tidak ikut di-clear). Jadi deleted_at yang terisi
            // bukan berarti petugasnya masih tidak aktif -- bisa saja
            // cuma sisa riwayat dari penghapusan sebelumnya. status='A'
            // satu-satunya sumber kebenaran yang bisa diandalkan di sini.
            final kantorMatch = normalizedKantor.isEmpty || kantorRow == normalizedKantor;
            return roleUser == '1' && status == 'A' && kantorMatch;
          })
          .map((e) => '${e['username'] ?? ''}'.trim())
          .where((username) => username.isNotEmpty)
          .toList();
    } catch (e) {
      if (kDebugMode) print("⚠️ Error inquiry data petugas (Pejabat pinjaman): $e");
      return [];
    }
  }

  static Future<List<LoanNotificationRecipientModel>> inquiryNotificationRecipients({required String bprId}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.inquiryNotifikasiPinjaman(), data: {"bpr_id": bprId, "user_login": "admin", "term": "WEB"});

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (res is! Map<String, dynamic>) throw Exception("Response inquiry notifikasi tidak valid.");
    if (res['code'] != '000') throw Exception(res['message'] ?? "Gagal inquiry penerima notifikasi.");

    final data = res['data'];
    if (data is! List) return [];

    return data.map((e) => LoanNotificationRecipientModel.fromJson(Map<String, dynamic>.from(e))).where((e) => e.cif.trim().isNotEmpty).toList();
  }

  static Future<bool> sendPushNotification({required String title, required String body, required String bprId, required String noCif}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(NetworkURL.pushNotifPinjaman(), data: {"title": title, "bpr_id": bprId, "body": body, "no_cif": noCif});

    final res = response.data is String ? jsonDecode(response.data) : response.data;
    return res is Map<String, dynamic> && res['value'] == 1;
  }

  static Future<LoanNotificationResultModel> notifyLoanStaff({
    required String bprId,
    String kdKantor = '',
    required LoanApplicationFormModel form,
  }) async {
    final pejabatUsernames = await _getAllPejabatUsername(bprId: bprId, kdKantor: kdKantor);
    if (pejabatUsernames.isEmpty) throw Exception("Pejabat aktif belum tersedia.");

    final title = "Pengajuan Pinjaman Baru";
    final body = "${form.nama} mengajukan pinjaman Rp ${form.nilaiPinjaman} dengan tenor ${form.jkWaktu} bulan.";

    int successCount = 0;
    int failedCount = 0;

    for (final username in pejabatUsernames) {
      final success = await sendPushNotification(title: title, body: body, bprId: bprId, noCif: username);

      success ? successCount++ : failedCount++;
    }

    return LoanNotificationResultModel(totalRecipient: pejabatUsernames.length, successCount: successCount, failedCount: failedCount);
  }

  static Future<List<LoanApplicationStatusModel>> inquiryStatusPinjaman({required String bprId, required String nama, required String noHp}) async {
    final dio = Dio();
    dio.options.headers['api-key'] = '123';

    final response = await dio.post(
      NetworkURL.inquiryPermohonanPinjaman(),
      data: {
        "bpr_id": bprId,
        "filter": {
          "status": "",
          "nama": nama,
          "no_hp": noHp,
          "user_handle": "",
          "nilai_pinjaman": {"min": 0, "max": 0},
          "jk_waktu": 0,
          "created_at": {"from": "", "to": ""},
        },
        "pagination": {"page": 1, "limit": 100},
        "sort": {"by": "created_at", "order": "desc"},
      },
    );

    final res = response.data is String ? jsonDecode(response.data) : response.data;

    if (kDebugMode) {
      print("INQUIRY STATUS PINJAMAN RESPONSE: $res");
    }

    if (res is! Map<String, dynamic>) {
      throw Exception("Response status pinjaman tidak valid.");
    }

    if (res['code'] != '000') {
      throw Exception(res['message'] ?? "Data permohonan pinjaman tidak ditemukan.");
    }

    final data = res['data'];
    if (data is! Map<String, dynamic>) return [];

    final rows = data['data'];
    if (rows is! List) return [];

    return rows.map((e) => LoanApplicationStatusModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
