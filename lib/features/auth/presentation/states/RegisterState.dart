import 'package:savvi/features/auth/domain/entities/user_entity.dart';

/// Clase de estado inmutable para la vista de Registro.
class Registerstate {
  final bool isLoading;
  final String? erroMessage;
  final String name;
  final String lastname;
  final DateTime? birthDate;
  final String email;
  final String password;
  final bool isObscure;
  final String selectedCountry;
  final String selectedCurrency;
  final String countryFlag;
  final String selectedOccupation;
  final String selectedUsageIntent;

  Registerstate({
    this.isLoading = false,
    this.erroMessage,
    this.name = '',
    this.lastname = '',
    this.birthDate,
    this.email = '',
    this.password  = '',
    this.isObscure = true,
    this.selectedCountry = '',
    this.selectedCurrency = '',
    this.countryFlag = '',
    this.selectedOccupation = '',
    this.selectedUsageIntent = '',
  });

  // Metodo copyWith para respetar la inmutabilidad
  Registerstate copyWith({
    bool? isLoading,
    String? errorMessage,
    String? name,
    String? lastname,
    DateTime? birthDate,
    String? email,
    String? password,
    bool? isObscure,
    String? selectedCountry,
    String? selectedCurrency,
    String? countryFlag,
    String? selectedOccupation,
    String? selectedUsageIntent,
  }) {
    return Registerstate(
      isLoading: isLoading ?? this.isLoading,
      erroMessage: errorMessage ?? this.erroMessage,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedCurrency: selectedCurrency ?? this.selectedCurrency,
      countryFlag: countryFlag ?? this.countryFlag,
      selectedOccupation: selectedOccupation ?? this.selectedOccupation,
      selectedUsageIntent: selectedUsageIntent ?? this.selectedUsageIntent,
    );
  }
}
