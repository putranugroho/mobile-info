class DepositoModel {
  final String noAcc;
  final String namaProduk;
  final double nominal;

  DepositoModel({required this.noAcc, required this.namaProduk, required this.nominal});

  factory DepositoModel.fromJson(Map<String, dynamic> json) {
    return DepositoModel(noAcc: json['noacc'].toString(), namaProduk: json['namaprd'].toString(), nominal: double.parse(json['nominal'].toString()));
  }
}
