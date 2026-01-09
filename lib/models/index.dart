export 'user_ibpr_model.dart';
export 'pascabayar_model.dart';
export 'users_model.dart';
export 'history_model.dart';
export 'bank_account_model.dart';
export 'denomisasi_model.dart';
export 'banners_model.dart';
export 'prefix_model.dart';
export 'user_new_model.dart';
export 'va_model.dart';
export 'produk_model.dart';
export 'prabayar_model.dart';
export 'bank_model.dart';
export 'streaming_model.dart';
export 'aktivasi_users_model.dart';
export 'bpr_model.dart';
import 'package:quiver/core.dart';

T? checkOptional<T>(Optional<T?>? optional, T? Function()? def) {
  // No value given, just take default value
  if (optional == null) return def?.call();

  // We have an input value
  if (optional.isPresent) return optional.value;

  // We have a null inside the optional
  return null;
}
