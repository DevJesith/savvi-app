import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/notifiers/reset_password_notifier.dart';
import 'package:savvi/features/auth/presentation/states/reset_password_state.dart';

/// Provider que conecta el notifier con la interfaz.
final resetPasswordProvider =
    NotifierProvider<ResetPasswordNotifier, ResetPasswordState>(
  ResetPasswordNotifier.new,
);