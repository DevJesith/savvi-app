import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/notifiers/register_notifier.dart';
import 'package:savvi/features/auth/presentation/states/register_state.dart';

/// Exponemos el Notifier (ViewModel) a la UI.
/// Usamos [NotifierProvider] siguiendo el estando de Riverpod 3.0
final registerProvider = NotifierProvider<RegisterNotifier, RegisterState>(
  RegisterNotifier.new,
);
