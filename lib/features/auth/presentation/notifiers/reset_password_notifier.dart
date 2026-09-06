import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/states/reset_password_state.dart';

/// Coordina el flujo de actualizacion de contraseña.
///
/// Se comunica con el repositorio y expone el resultado a la pantalla
/// mediante ResetPasswordState.
class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() {
    return const ResetPasswordState();
  }

  /// Actualiza la contraseña usando la sesión temporal de recuperacion.
  Future<void> updatePassword({required String newPassword}) async {
    // Indicamos a la interfaz que comenzóo la peticion.
    state = state.copyWith(isLoading: true, isSuccess: false, clearError: true);

    try {
      await ref
          .read(authRepositoryProvider)
          .updatePassword(newPassword: newPassword);

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Cierra la sesion temporal despues de actualizar la contraseña.
  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
  }

  /// Limpia el resultado anterior antes de realizar otra operacion.
  void clearResult() {
    state = const ResetPasswordState();
  }
}
