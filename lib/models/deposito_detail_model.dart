class DepositoDetailModel {
  final String noRek;
  final String nocif;
  final String nama;
  final String noBilyet;
  final double nominal;
  final int jkwaktu;
  final String jnsjkwaktu;
  final String tglEff;
  final String tglJatuhTempo;
  final bool aro;
  final bool tambahNominal;
  final double rate;

  DepositoDetailModel({
    required this.noRek,
    required this.nocif,
    required this.nama,
    required this.noBilyet,
    required this.nominal,
    required this.jkwaktu,
    required this.jnsjkwaktu,
    required this.tglEff,
    required this.tglJatuhTempo,
    required this.aro,
    required this.tambahNominal,
    required this.rate,
  });

  factory DepositoDetailModel.fromJson(Map<String, dynamic> json) {
    return DepositoDetailModel(
      noRek: json['no_rek'].toString(),
      nocif: json['nocif'].toString(),
      nama: json['nama'].toString(),
      noBilyet: json['no_bilyet'].toString(),
      nominal: (json['nominal'] as num).toDouble(),
      jkwaktu: json['jkwaktu'],
      jnsjkwaktu: json['jnsjkwaktu'].toString(),
      tglEff: json['tgleff'].toString(),
      tglJatuhTempo: json['tgljtempo'].toString(),
      aro: json['aro'] == 'Y',
      tambahNominal: json['tambahnom'] == 'Y',
      rate: (json['rate'] as num).toDouble(),
    );
  }
}
