import 'package:country_picker/country_picker.dart';
import 'package:savvi/features/auth/domain/entities/user_entity.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/states/RegisterState.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Registernotifier extends Notifier<Registerstate> {
  @override
  Registerstate build() => Registerstate();

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

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> completeRegistration(String otpCode) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
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

        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow; // Lanzamos el error para que la UI lo muestre
    }
  }

  void toggleObscure() {
    state = state.copyWith(isObscure: !state.isObscure);
  }
}
