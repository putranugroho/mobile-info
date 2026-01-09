class TabunganModel {
  final String noAcc;
  final String namaProduk;
  final double saldo;

  TabunganModel({required this.noAcc, required this.namaProduk, required this.saldo});

  factory TabunganModel.fromJson(Map<String, dynamic> json) {
    return TabunganModel(noAcc: json['noacc'].toString(), namaProduk: json['namaprd'].toString(), saldo: double.parse(json['saldo'].toString()));
  }
}
