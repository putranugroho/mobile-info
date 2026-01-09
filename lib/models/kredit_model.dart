class KreditModel {
  final String noAcc;
  final String noCif;
  final String nama;
  final String namaProduk;
  final double tagihan;

  KreditModel({required this.noAcc, required this.noCif, required this.nama, required this.namaProduk, required this.tagihan});

  factory KreditModel.fromJson(Map<String, dynamic> json) {
    return KreditModel(
      noAcc: json['noacc'].toString(),
      noCif: json['nocif'].toString(),
      nama: json['nama'].toString(),
      namaProduk: json['namaprd'].toString(),
      tagihan: (json['tagihan'] as num).toDouble(),
    );
  }
}
