import 'dart:typed_data';

class LoanSetupPinjamanModel {
  final int id;
  final int jkWaktuMin;
  final int jkWaktuMaks;
  final double sukuBunga;
  final String status;

  LoanSetupPinjamanModel({required this.id, required this.jkWaktuMin, required this.jkWaktuMaks, required this.sukuBunga, required this.status});

  bool get hasRate => sukuBunga > 0;

  factory LoanSetupPinjamanModel.fromJson(Map<String, dynamic> json) {
    return LoanSetupPinjamanModel(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      jkWaktuMin: int.tryParse("${json['jk_waktumin'] ?? 0}") ?? 0,
      jkWaktuMaks: int.tryParse("${json['jk_waktumaks'] ?? 0}") ?? 0,
      sukuBunga: double.tryParse("${json['suku_bunga'] ?? 0}") ?? 0,
      status: "${json['status'] ?? ''}",
    );
  }
}

class LoanJaminanModel {
  final String kdJaminan;
  final String deskripsi;
  final String status;

  LoanJaminanModel({required this.kdJaminan, required this.deskripsi, required this.status});

  factory LoanJaminanModel.fromJson(Map<String, dynamic> json) {
    return LoanJaminanModel(kdJaminan: "${json['kd_jaminan'] ?? ''}", deskripsi: "${json['deskripsi'] ?? ''}", status: "${json['status'] ?? ''}");
  }
}

class LoanSimulationResultModel {
  final int cicilan;
  final int totalCicilan;
  final int nilaiPinjaman;
  final int jangkaWaktu;
  final double rate;

  LoanSimulationResultModel({
    required this.cicilan,
    required this.totalCicilan,
    required this.nilaiPinjaman,
    required this.jangkaWaktu,
    required this.rate,
  });

  factory LoanSimulationResultModel.fromJson(Map<String, dynamic> json) {
    return LoanSimulationResultModel(
      cicilan: int.tryParse("${json['cicilan'] ?? 0}") ?? 0,
      totalCicilan: int.tryParse("${json['total_cicilan'] ?? 0}") ?? 0,
      nilaiPinjaman: int.tryParse("${json['nilai_pinjaman'] ?? 0}") ?? 0,
      jangkaWaktu: int.tryParse("${json['jangka_waktu'] ?? 0}") ?? 0,
      rate: double.tryParse("${json['rate'] ?? 0}") ?? 0,
    );
  }
}

class LoanApplicationFormModel {
  final String noId;
  final String nama;
  final String noCif;
  final String noHp;
  final String alamat;
  final String jaminan;
  final String nilaiPinjaman;
  final String jkWaktu;
  final String rate;
  final String cicilan;
  final Uint8List? fotoJaminanBytes;
  final String? fotoJaminanName;
  final String? fotoJaminanMimeType;
  final String? fotoJaminanSource;
  final int? fotoJaminanSizeBytes;

  LoanApplicationFormModel({
    required this.noId,
    required this.nama,
    required this.noCif,
    required this.noHp,
    required this.alamat,
    required this.jaminan,
    required this.nilaiPinjaman,
    required this.jkWaktu,
    required this.rate,
    required this.cicilan,
    this.fotoJaminanBytes,
    this.fotoJaminanName,
    this.fotoJaminanMimeType,
    this.fotoJaminanSource,
    this.fotoJaminanSizeBytes,
  });
}

class LoanNotificationRecipientModel {
  final int id;
  final String cif;
  final String nama;
  final String noHp;
  final String status;

  LoanNotificationRecipientModel({required this.id, required this.cif, required this.nama, required this.noHp, required this.status});

  factory LoanNotificationRecipientModel.fromJson(Map<String, dynamic> json) {
    return LoanNotificationRecipientModel(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      cif: "${json['cif'] ?? ''}",
      nama: "${json['nama'] ?? ''}",
      noHp: "${json['no_hp'] ?? ''}",
      status: "${json['status'] ?? ''}",
    );
  }
}

class LoanNotificationResultModel {
  final int totalRecipient;
  final int successCount;
  final int failedCount;

  LoanNotificationResultModel({required this.totalRecipient, required this.successCount, required this.failedCount});
}

class LoanApplicationStatusModel {
  final int id;
  final String noId;
  final String nama;
  final String noCif;
  final String noHp;
  final String alamat;
  final String jaminan;
  final String nilaiPinjaman;
  final String jkWaktu;
  final String rate;
  final String cicilanPerbulan;
  final String status;
  final String alasan;
  final String fotoJaminan;
  final String userHandle;
  final String tglInput;
  final String tglUbah;

  LoanApplicationStatusModel({
    required this.id,
    required this.noId,
    required this.noCif,
    required this.nama,
    required this.noHp,
    required this.alamat,
    required this.jaminan,
    required this.nilaiPinjaman,
    required this.jkWaktu,
    required this.rate,
    required this.cicilanPerbulan,
    required this.status,
    required this.alasan,
    required this.fotoJaminan,
    required this.userHandle,
    required this.tglInput,
    required this.tglUbah,
  });

  factory LoanApplicationStatusModel.fromJson(Map<String, dynamic> json) {
    return LoanApplicationStatusModel(
      id: int.tryParse("${json['id'] ?? 0}") ?? 0,
      noId: "${json['no_id'] ?? ''}",
      nama: "${json['nama'] ?? ''}",
      noCif: "${json['no_cif'] ?? ''}",
      noHp: "${json['no_hp'] ?? ''}",
      alamat: "${json['alamat'] ?? ''}",
      jaminan: "${json['jaminan'] ?? ''}",
      nilaiPinjaman: "${json['nilai_pinjaman'] ?? '0'}",
      jkWaktu: "${json['jk_waktu'] ?? '0'}",
      rate: "${json['rate'] ?? ''}",
      cicilanPerbulan: "${json['cicilan_perbulan'] ?? '0'}",
      status: "${json['status'] ?? ''}",
      alasan: "${json['alasan'] ?? ''}",
      fotoJaminan: "${json['fhoto_jaminan'] ?? ''}",
      userHandle: "${json['user_handle'] ?? ''}",
      tglInput: "${json['tgl_input'] ?? ''}",
      tglUbah: "${json['tgl_ubah'] ?? ''}",
    );
  }
}
