import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// 1. Notifier que maneja la edad seleccionada
class AgeNotifier extends Notifier<String?> {
  @override
  String? build() => null; // al inicio no hay selección

  void selectAge(String age) {
    state = age;
  }
}

// 2. Provider que expone el Notifier
final ageProvider = NotifierProvider<AgeNotifier, String?>(() {
  return AgeNotifier();
});

class CountryRegisterScreen extends ConsumerWidget {
  const CountryRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final List<String> ageRanges = ["-17", "18-24", "25-34", "35-44", "45+"];
    final selectedAge = ref.watch(ageProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.width * 0.05,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_back, size: 50),
                  Text(
                    'Paso 1 de 5',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),

              //TODO: PAGWVIEW PARA EL CAMBIO DE LAS PAGINAS CON DOTS
              const SizedBox(height: 20),

              Text(
                'Cuentanos sobre ti',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Necesitamos estos datos para configurar tu experiecnia financiera personalizada y tu moneda local.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: Color(0xFF475569),
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 8,
                children: ageRanges.map((age) {
                  return ChoiceChip(
                    label: Text(age),
                    selected: selectedAge == age,
                    selectedColor: Colors.red,
                    onSelected: (bool selected) {
                      if (selected) {
                        ref.read(ageProvider.notifier).selectAge(age);
                      }
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
