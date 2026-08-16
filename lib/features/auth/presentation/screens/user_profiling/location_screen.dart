import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/occupation_screen.dart';

class LocationScreen extends ConsumerWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //-----
              Text(
                "Cuentanos sobre ti",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Necesitamos estos datyos para configurar tu experiencia financiera personalizada y tu moeda local",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Nacionalidad",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // --- COMPONENTE PERSONALIZADO ---
              GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    onSelect: (Country country) =>
                        notifier.updateCountry(country),
                    showPhoneCode: false,
                    countryListTheme: CountryListThemeData(
                      borderRadius: BorderRadius.circular(24),
                      inputDecoration: InputDecoration(
                        hintText: 'Buscar pais...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: state.selectedCountry.isNotEmpty
                          ? const Color(0xFFFF4929)
                          : const Color(0xFFFFE4E0),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    // Mostar bandera
                    children: [
                      Text(
                        state.countryFlag.isNotEmpty
                            ? state.countryFlag
                            : "🏳️",
                        style: const TextStyle(fontSize: 12),
                      ),

                      const SizedBox(width: 12),

                      Text(
                        state.selectedCountry.isNotEmpty
                            ? "${state.selectedCountry} (${state.selectedCurrency})"
                            : "Selecciona tu pais",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: state.selectedCountry.isNotEmpty
                              ? const Color(0xFF0F172A)
                              : const Color(0xFF64748B),
                          fontWeight: state.selectedCountry.isNotEmpty
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),

                      const Spacer(),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF64748B),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Informativo
              Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      "Esto definira automaticamente tu divisa principal",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Boton siguiente
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: state.selectedCountry.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OccupationScreen(),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4929),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Siguiente",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
