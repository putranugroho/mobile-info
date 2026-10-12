class TrxDigitalSetupModel {
  final String jenis;
  final String label;
  final double minNominal;
  final double maxNominal;
  final int durasiMenit;

  TrxDigitalSetupModel({required this.jenis, required this.label, required this.minNominal, required this.maxNominal, required this.durasiMenit});

  factory TrxDigitalSetupModel.fromJson(Map<String, dynamic> json) {
    return TrxDigitalSetupModel(
      jenis: (json['jenis'] ?? '').toString(),
      label: (json['label'] ?? '').toString(),
      minNominal: double.tryParse((json['min_nominal'] ?? 0).toString()) ?? 0,
      maxNominal: double.tryParse((json['max_nominal'] ?? 0).toString()) ?? 0,
      durasiMenit: int.tryParse((json['durasi_menit'] ?? 0).toString()) ?? 0,
    );
  }
}

class TrxDigitalModel {
  final String trxId;
  final String noRek;
  final String nama;
  final String jenis;
  final String jenisLabel;
  final double nominal;
  final String status; // ACTIVE | EXPIRED | USED | CANCELLED
  final String qr;
  final DateTime expiredAt;
  final DateTime createdAt;

  TrxDigitalModel({
    required this.trxId,
    required this.noRek,
    required this.nama,
    required this.jenis,
    required this.jenisLabel,
    required this.nominal,
    required this.status,
    required this.qr,
    required this.expiredAt,
    required this.createdAt,
  });

  bool get isTarik => jenis == 'TARIK_TUNAI';

  /// Status efektif di sisi device (QR aktif yang sudah lewat masa berlaku dianggap expired).
  String get effectiveStatus => status == 'ACTIVE' && DateTime.now().isAfter(expiredAt) ? 'EXPIRED' : status;

  bool get canShowQr => effectiveStatus == 'ACTIVE' && qr.isNotEmpty;

  factory TrxDigitalModel.fromJson(Map<String, dynamic> json) {
    return TrxDigitalModel(
      trxId: (json['trx_id'] ?? '').toString(),
      noRek: (json['no_rek'] ?? '').toString(),
      nama: (json['nama'] ?? '').toString(),
      jenis: (json['jenis'] ?? '').toString(),
      jenisLabel: (json['jenis_label'] ?? '').toString(),
      nominal: double.tryParse((json['nominal'] ?? 0).toString()) ?? 0,
      status: (json['status'] ?? '').toString(),
      qr: (json['qr'] ?? '').toString(),
      expiredAt: DateTime.tryParse((json['expired_at'] ?? '').toString().replaceFirst(' ', 'T')) ?? DateTime.now(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString().replaceFirst(' ', 'T')) ?? DateTime.now(),
    );
  }
}
