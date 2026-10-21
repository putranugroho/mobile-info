/// Angka -> kata dalam Bahasa Indonesia ("lima ratus ribu rupiah").
String terbilangRupiah(num value) {
  final n = value.truncate();
  if (n == 0) return 'nol rupiah';
  return '${_words(n).replaceAll(RegExp(r'\s+'), ' ').trim()} rupiah';
}

const _satuan = ['', 'satu', 'dua', 'tiga', 'empat', 'lima', 'enam', 'tujuh', 'delapan', 'sembilan', 'sepuluh', 'sebelas'];

String _words(int n) {
  if (n < 12) return ' ${_satuan[n]}';
  if (n < 20) return '${_words(n - 10)} belas';
  if (n < 100) return '${_words(n ~/ 10)} puluh${_words(n % 10)}';
  if (n < 200) return ' seratus${_words(n - 100)}';
  if (n < 1000) return '${_words(n ~/ 100)} ratus${_words(n % 100)}';
  if (n < 2000) return ' seribu${_words(n - 1000)}';
  if (n < 1000000) return '${_words(n ~/ 1000)} ribu${_words(n % 1000)}';
  if (n < 1000000000) return '${_words(n ~/ 1000000)} juta${_words(n % 1000000)}';
  if (n < 1000000000000) return '${_words(n ~/ 1000000000)} miliar${_words(n % 1000000000)}';
  return '${_words(n ~/ 1000000000000)} triliun${_words(n % 1000000000000)}';
}
