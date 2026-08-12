/// Entidad del negocio.
class UserEntity {
  final String name;
  final String lastname;
  final DateTime? birthDate;
  final String email;
  final String country;
  final String currency;

  UserEntity({
    required this.name,
    required this.lastname,
    this.birthDate,
    required this.email,
    this.country = '',
    this.currency = '',
  });

  // Calcular edad
  int? get age {
    if (birthDate == null) return null;
    final today = DateTime.now();
    int age = today.year - birthDate!.year;
    if (today.month < birthDate!.month ||
        (today.month == birthDate!.month && today.day < birthDate!.day)) {
      age--;
    }
    return age;
  }
}
