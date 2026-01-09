enum ProdukKategori { tabungan, deposito, kartuKredit, pinjaman, investasi }

extension ProdukKategoriExt on ProdukKategori {
  String get label {
    switch (this) {
      case ProdukKategori.tabungan:
        return "Tabungan";
      case ProdukKategori.deposito:
        return "Deposito";
      case ProdukKategori.kartuKredit:
        return "Kartu Kredit";
      case ProdukKategori.pinjaman:
        return "Pinjaman";
      case ProdukKategori.investasi:
        return "Investasi";
    }
  }
}
