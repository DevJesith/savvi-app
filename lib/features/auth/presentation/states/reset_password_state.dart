/// Representa el estado del flujo de cambio de contraseña.
///
/// La pantalla observa este estado para saber si debe mostrar loading,
/// exito o un mensaje de error.
class ResetPasswordState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage; // Guarda el mensaje si la operacion falla.

  const ResetPasswordState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

/// Crea una copia del estado cambiando unicamente los valores necesarios.
///
/// Se usa para actualizar el estado de forma inmutable.
  ResetPasswordState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResetPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
