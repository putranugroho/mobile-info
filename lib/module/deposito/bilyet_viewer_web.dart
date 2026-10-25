import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

int _seq = 0;

/// Menampilkan PDF dengan penampil bawaan browser lewat blob URL di dalam iframe.
Widget buildBilyetViewer(Uint8List bytes, String fileName) {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'application/pdf'));
  final url = web.URL.createObjectURL(blob);
  final viewType = 'bilyet-pdf-${_seq++}';

  ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
    final iframe = web.HTMLIFrameElement()
      ..src = '$url#toolbar=0&navpanes=0'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
    return iframe;
  });

  return HtmlElementView(viewType: viewType);
}
