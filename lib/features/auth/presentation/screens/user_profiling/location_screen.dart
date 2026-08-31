import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/profiling_provider.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/occupation_screen.dart';
import 'package:savvi/shared/widgets/profiling_progress_widgets.dart';

class LocationStepView extends ConsumerStatefulWidget {
  final PageController pageController;
  const LocationStepView({super.key, required this.pageController});

  @override
  ConsumerState<LocationStepView> createState() => _LocationStepViewState();
}

class _LocationStepViewState extends ConsumerState<LocationStepView> {


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

              Text(
                "Cuéntanos sobre ti",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Necesitamos estos datos para configurar tu experiencia financiera personalizada y tu moneda local.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 32),

              Text(
                "Nacionalidad",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 12),

              // Selector de Pais
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
                        hintText: 'Buscar país...',
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
                    children: [
                      Text(
                        state.countryFlag.isNotEmpty
                            ? state.countryFlag
                            : "🏳️",
                        style: const TextStyle(
                          fontSize: 22,
                        ), // Bandera más grande
                      ),
                      const SizedBox(width: 12),
                      Text(
                        state.selectedCountry.isNotEmpty
                            ? "${state.selectedCountry} (${state.selectedCurrency})"
                            : "Selecciona tu país",
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

              // Texto informativo
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
                      "Esto definirá automáticamente tu divisa principal.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Boton Siguiente
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: state.selectedCountry.isEmpty
                          ? null
                          : () {
                              widget.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
}
