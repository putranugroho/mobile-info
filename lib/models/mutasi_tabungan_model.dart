class MutasiTabunganModel {
  final String noRek;
  final String tanggal; // yyyyMMdd
  final double nominal;
  final String keterangan;
  final String mutasi; // D / K

  MutasiTabunganModel({required this.noRek, required this.tanggal, required this.nominal, required this.keterangan, required this.mutasi});

  factory MutasiTabunganModel.fromJson(Map<String, dynamic> json) {
    return MutasiTabunganModel(
      noRek: json['noacc'].toString(),
      tanggal: json['tgltrn'].toString(),
      nominal: double.parse(json['nominal'].toString()),
      keterangan: json['keterangan'].toString(),
      mutasi: json['mutasi'].toString(),
    );
  }

  /// KREDIT jika K
  bool get isCredit => mutasi == "C";

  DateTime get date => DateTime(int.parse(tanggal.substring(0, 4)), int.parse(tanggal.substring(4, 6)), int.parse(tanggal.substring(6, 8)));
}
