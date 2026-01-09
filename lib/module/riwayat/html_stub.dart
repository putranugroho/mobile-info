class Blob {
  Blob(List<dynamic> list, String type);
}

class Url {
  static String createObjectUrlFromBlob(dynamic blob) => "";
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});

  String download = "";

  void click() {}
}
