class MutasiTabunganModel {
  final String noRek;
  final String tanggal; // yyyyMMdd
  final double nominal;
  final String keterangan;
  final String mutasi; // D / K
  final String trxCode;

  MutasiTabunganModel({
    required this.noRek,
    required this.tanggal,
    required this.nominal,
    required this.keterangan,
    required this.mutasi,
    required this.trxCode,
  });

  factory MutasiTabunganModel.fromJson(Map<String, dynamic> json) {
    return MutasiTabunganModel(
      noRek: (json['noacc'] ?? json['no_acc'] ?? '').toString(),
      tanggal: (json['tgltrn'] ?? json['tgl_trn'] ?? json['tanggal'] ?? '').toString(),
      nominal: double.tryParse((json['nominal'] ?? 0).toString()) ?? 0,
      keterangan: (json['keterangan'] ?? '').toString(),
      mutasi: (json['mutasi'] ?? '').toString(),
      trxCode: (json['trx_code'] ?? json['tcode'] ?? json['kode_transaksi'] ?? '').toString(),
    );
  }

  /// KREDIT jika K/C, DEBET jika D.
  bool get isCredit {
    final value = mutasi.trim().toUpperCase();
    return value == 'K' || value == 'C' || value == 'CR' || value == 'CREDIT';
  }

  DateTime get date {
    final clean = tanggal.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.length >= 8) {
      return DateTime(
        int.tryParse(clean.substring(0, 4)) ?? DateTime.now().year,
        int.tryParse(clean.substring(4, 6)) ?? 1,
        int.tryParse(clean.substring(6, 8)) ?? 1,
      );
    }

    return DateTime.tryParse(tanggal) ?? DateTime.now();
  }
}
