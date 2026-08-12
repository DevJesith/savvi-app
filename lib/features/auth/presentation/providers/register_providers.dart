import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/notifiers/RegisterNotifier.dart';
import 'package:savvi/features/auth/presentation/states/RegisterState.dart';

/// Exponemos el Notifier (ViewModel) a la UI.
/// Usamos [NotifierProvider] siguiendo el estando de Riverpod 3.0
final registerProvider = NotifierProvider<Registernotifier, Registerstate>(
  Registernotifier.new,
);
