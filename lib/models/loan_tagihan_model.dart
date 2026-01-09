class LoanTagihanModel {
  final String noRek;
  final int ke;
  final String tglTagihan;
  final double tagihan;
  final double bayarTagihan;
  final double denda;
  final double bayarDenda;
  final double sisaTagihan;
  final double sisaDenda;

  LoanTagihanModel({
    required this.noRek,
    required this.ke,
    required this.tglTagihan,
    required this.tagihan,
    required this.bayarTagihan,
    required this.denda,
    required this.bayarDenda,
    required this.sisaTagihan,
    required this.sisaDenda,
  });

  factory LoanTagihanModel.fromJson(Map<String, dynamic> json) {
    return LoanTagihanModel(
      noRek: json['no_rek'],
      ke: json['ke'],
      tglTagihan: json['tgltagihan'],
      tagihan: (json['tagihan'] ?? 0).toDouble(),
      bayarTagihan: (json['byr_tagihan'] ?? 0).toDouble(),
      denda: (json['denda'] ?? 0).toDouble(),
      bayarDenda: (json['byr_denda'] ?? 0).toDouble(),
      sisaTagihan: (json['sisa_tagihan'] ?? 0).toDouble(),
      sisaDenda: (json['sisa_denda'] ?? 0).toDouble(),
    );
  }
}
