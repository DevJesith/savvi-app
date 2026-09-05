
/// Clase de estado inmutable para la vista de Registro.
class RegisterState {
  final bool isLoading;
  final String? errorMessage;
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

  RegisterState({
    this.isLoading = false,
    this.errorMessage,
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
  RegisterState copyWith({
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
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
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
