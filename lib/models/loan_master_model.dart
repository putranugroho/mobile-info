class LoanMasterModel {
  final String noRek;
  final String nocif;
  final String nama;
  final String kdProduk;
  final double plafondAwal;
  final double outstanding;
  final double tunggakan;
  final String tglEfektif;
  final String tglJatuhTempo;
  final int jangkaWaktu;
  final String jenisJangkaWaktu;
  final double rate;

  LoanMasterModel({
    required this.noRek,
    required this.nocif,
    required this.nama,
    required this.kdProduk,
    required this.plafondAwal,
    required this.outstanding,
    required this.tunggakan,
    required this.tglEfektif,
    required this.tglJatuhTempo,
    required this.jangkaWaktu,
    required this.jenisJangkaWaktu,
    required this.rate,
  });

  factory LoanMasterModel.fromJson(Map<String, dynamic> json) {
    return LoanMasterModel(
      noRek: json['no_rek'],
      nocif: json['nocif'],
      nama: json['nama'],
      kdProduk: json['kdprd'],
      plafondAwal: (json['plafond_awal'] ?? 0).toDouble(),
      outstanding: (json['os'] ?? 0).toDouble(),
      tunggakan: (json['jml_tunggakan'] ?? 0).toDouble(),
      tglEfektif: json['tgleff'],
      tglJatuhTempo: json['tgljtempo'],
      jangkaWaktu: json['jkwaktu'],
      jenisJangkaWaktu: json['jnsjkwaktu'],
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }
}
