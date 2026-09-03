import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';

class LocationStepView extends ConsumerWidget {
  final PageController pageController;

  const LocationStepView({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LocationHeader(),

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
          _CountrySelectorCard(
            flag: state.countryFlag,
            countryName: state.selectedCountry,
            currencyCode: state.selectedCurrency,
            onTap: () => _openCountryPicker(context, notifier),
          ),
          const SizedBox(height: 12),

          // Texto informativo
          const _InfoNote(),

          const Spacer(),

          // Boton Siguiente
          _NextButton(
            isEnabled: state.selectedCountry.isNotEmpty,
            onPressed: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
    );
  }

  void _openCountryPicker(BuildContext context, dynamic notifier) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) => notifier.updateCountry(country),
      showPhoneCode: false,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(24),
        inputDecoration: InputDecoration(
          hintText: 'Buscar país...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF8F6F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 14, color: Color(0xFF64748B)),
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
    );
  }
}

class _LocationHeader extends StatelessWidget {
  const _LocationHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
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
      ],
    );
  }
}

class _CountrySelectorCard extends StatelessWidget {
  final String flag;
  final String countryName;
  final String currencyCode;
  final VoidCallback onTap;

  const _CountrySelectorCard({
    required this.flag,
    required this.countryName,
    required this.currencyCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSelected = countryName.isNotEmpty;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(50),
      // Boton interactivo con animacion al toque
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: hasSelected
                  ? const Color(0xFFFF4929)
                  : const Color(0xFFFFE4E0),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                hasSelected ? flag : "🏳️",
                style: const TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  hasSelected
                      ? "$countryName ($currencyCode)"
                      : "Selecciona tu pais",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: hasSelected
                        ? const Color(0xFF0F172A)
                        : const Color(0xFF64748B),
                    fontWeight: hasSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;

  const _NextButton({required this.isEnabled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF4929),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Siguiente",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}
