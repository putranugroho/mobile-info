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

class BilyetField {
  final String key;
  final String label;
  final bool aktif;
  final double x; // mm dari kiri
  final double y; // mm dari atas

  const BilyetField({required this.key, required this.label, required this.aktif, required this.x, required this.y});

  factory BilyetField.fromJson(Map<String, dynamic> json) => BilyetField(
    key: '${json['key'] ?? ''}',
    label: '${json['label'] ?? ''}',
    aktif: json['aktif'] == true || '${json['aktif']}' == '1',
    x: double.tryParse('${json['x'] ?? 0}') ?? 0,
    y: double.tryParse('${json['y'] ?? 0}') ?? 0,
  );
}

/// Format bilyet digital (endpoint inquiry/format-bilyet): ukuran kertas, latar, dan posisi tiap field (mm).
class BilyetFormat {
  final String nama;
  final double lebarMm;
  final double tinggiMm;
  final double fontSize;
  final String bgBilyet; // data:image/png;base64,...
  final double bgOpacity; // 0..100
  final List<BilyetField> fields;

  const BilyetFormat({
    required this.nama,
    required this.lebarMm,
    required this.tinggiMm,
    required this.fontSize,
    required this.bgBilyet,
    required this.bgOpacity,
    required this.fields,
  });

  factory BilyetFormat.fromJson(Map<String, dynamic> json) {
    final rawFields = json['fields'];
    return BilyetFormat(
      nama: '${json['nama_format'] ?? ''}',
      lebarMm: double.tryParse('${json['lebar_kertas'] ?? 0}') ?? 160,
      tinggiMm: double.tryParse('${json['tinggi_kertas'] ?? 0}') ?? 95,
      fontSize: double.tryParse('${json['font_size'] ?? 10}') ?? 10,
      bgBilyet: '${json['bg_bilyet'] ?? ''}',
      bgOpacity: double.tryParse('${json['bg_opacity'] ?? 100}') ?? 100,
      fields: rawFields is List ? rawFields.map((e) => BilyetField.fromJson(Map<String, dynamic>.from(e))).where((f) => f.aktif).toList() : const [],
    );
  }
}
