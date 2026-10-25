/// Deposito digital milik nasabah (endpoint inquiry/deposito-digital-nasabah).
class DepositoDigitalInfo {
  final String noRek;
  final String noCif;
  final String noBilyet;
  final String tglBuka;

  const DepositoDigitalInfo({required this.noRek, required this.noCif, required this.noBilyet, required this.tglBuka});

  factory DepositoDigitalInfo.fromJson(Map<String, dynamic> json) => DepositoDigitalInfo(
    noRek: '${json['no_rek'] ?? ''}'.trim(),
    noCif: '${json['no_cif'] ?? ''}'.trim(),
    noBilyet: '${json['no_bilyet'] ?? ''}'.trim(),
    tglBuka: '${json['tgl_buka'] ?? ''}'.trim(),
  );
}
