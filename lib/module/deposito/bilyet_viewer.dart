// Penampil PDF bilyet. Web: penampil PDF bawaan browser (iframe, tanpa PDF.js). Android/iOS: PdfPreview native.
export 'bilyet_viewer_native.dart' if (dart.library.js_interop) 'bilyet_viewer_web.dart';
