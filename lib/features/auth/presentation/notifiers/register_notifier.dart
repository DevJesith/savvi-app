import 'package:country_picker/country_picker.dart';
import 'package:savvi/features/auth/domain/entities/user_entity.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/states/register_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() => RegisterState();

  /// Limpia los datos del formulario para iniciar un registro nuevo.
  void resetState() {
    state = RegisterState();
  }

  /// Inicializar el formulario con los datos recibidos desde Google.
  ///
  /// La contraseña no se completa porque la autenticacion la gestion Google
  void initializeFromGoogle({
    required String email,
    required String name,
    required String lastname,
  }) {
    state = state.copyWith(
      email: email.trim().toLowerCase(),
      name: name,
      lastname: lastname,
      password: '',
      isGoogleUser: true,
    );
  }

  // Metodos para actualizar el estado
  void updateName(String value) => state = state.copyWith(name: value);
  void updateLastname(String value) => state = state.copyWith(lastname: value);
  void updateEmail(String value) =>
      state = state.copyWith(email: value.trim().toLowerCase());

  void updateBirthDate(DateTime date) {
    state = state.copyWith(birthDate: date);
  }

  void updatePassword(String p) => state = state.copyWith(password: p);

  void updateCountry(Country country) {
    state = state.copyWith(
      selectedCountry: country.name,
      selectedCurrency: country.countryCode,
      countryFlag: country.flagEmoji,
    );
  }

  void updateOccupation(String occupation) {
    state = state.copyWith(selectedOccupation: occupation);
  }

  void updatedUsageIntent(String intent) {
    state = state.copyWith(selectedUsageIntent: intent);
  }

  // Función para iniciar el registro (Paso 1)
  Future<void> startSignUp() async {
    state = state.copyWith(isLoading: true);
    try {
      // Inicia
      final start = DateTime.now();

      // Creamos una entidad sin password
      final userEntity = UserEntity(
        name: state.name,
        lastname: state.lastname,
        email: state.email,
      );

      // Enviamos la entidad y el password por separado al repositorio
      await ref
          .read(authRepositoryProvider)
          .registerWithEmail(
            user: userEntity,
            password: state.password, // Usamos la del estado
          );

      // finalizacion
      final end = DateTime.now();
      final duration = end.difference(start);
      print("⏱️ Tiempo de respuesta registro: ${duration.inMilliseconds} ms");

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Guarda el perfil completado por un usuario autenticado con Google.
  Future<void> completeGoogleProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final userId = ref.read(authRepositoryProvider).currentUser?.id;

      if (userId == null) {
        throw Exception('No hay un usuario autenticado.');
      }

      final userEntity = UserEntity(
        name: state.name,
        lastname: state.lastname,
        email: state.email,
        birthDate: state.birthDate,
        currency: state.selectedCurrency,
        country: state.selectedCountry,
      );

      await ref
          .read(authRepositoryProvider)
          .updateProfile(
            userId: userId,
            user: userEntity,
            occupation: state.selectedOccupation,
            usageIntent: state.selectedUsageIntent,
          );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());

      rethrow;
    }
  }

  Future<void> completeRegistration(String otpCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Inicio
      final start = DateTime.now();

      // 1. Verificamos el codigo (esto loguea al usuario automaticamente si es correcto)
      await ref
          .read(authRepositoryProvider)
          .verifyOTP(
            email: state.email.trim().toLowerCase(),
            token: otpCode.trim(),
          );

      // 2. Obtenemos el ID del usuario recien verificado
      final userId = ref.read(authRepositoryProvider).currentUser?.id;

      if (userId != null) {
        // 3. Mapeamos el estado a una Entidad limpia
        final userEntity = UserEntity(
          name: state.name,
          lastname: state.lastname,
          email: state.email,
          birthDate: state.birthDate,
          currency: state.selectedCurrency,
          country: state.selectedCountry,
        );

        // 4. Guardamos los datos de profiling en Supabase
        await ref
            .read(authRepositoryProvider)
            .updateProfile(
              userId: userId,
              user: userEntity,
              occupation: state.selectedOccupation,
              usageIntent: state.selectedUsageIntent,
            );

        // Finalizacion
        final end = DateTime.now();
        final duration = end.difference(start);
        print(
          "⏱️ Tiempo de respuesta verificación: ${duration.inMilliseconds} ms",
        );

        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow; // Lanzamos el error para que la UI lo muestre
    }
  }

  /// Solicita a Supabase que reenvíe el código de confirmación.
  Future<void> resendCode() async {
    state = state.copyWith(isResending: true, errorMessage: null);

    try {
      await ref
          .read(authRepositoryProvider)
          .resendVerificationCode(email: state.email);

      state = state.copyWith(isResending: false);
    } catch (e) {
      state = state.copyWith(isResending: false, errorMessage: e.toString());

      rethrow;
    }
  }

  void toggleObscure() {
    state = state.copyWith(isObscure: !state.isObscure);
  }
}
