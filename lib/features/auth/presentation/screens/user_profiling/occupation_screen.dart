import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';

import 'package:savvi/shared/widgets/occupation_card_widget.dart';

// 1. Lista de opciones estatica fuera del build para optimizar memoria
final List<OccupationOption> _occupationOptions = [
  OccupationOption(
    title: 'Estudiante',
    description: 'En formación académica',
    icon: Icons.school_outlined,
  ),
  OccupationOption(
    title: 'Empleado',
    description: 'Trabajo por cuenta ajena',
    icon: Icons.work_outline,
  ),
  OccupationOption(
    title: 'Autónomo / Freelance',
    description: 'Trabajo independiente',
    icon: Icons.person_outline,
  ),
  OccupationOption(
    title: 'Jubilado',
    description: 'Retirado de la vida laboral',
    icon: Icons.bed_outlined,
  ),
  OccupationOption(
    title: 'Otros',
    description: 'Situación diversa o desempleado',
    icon: Icons.more_horiz_outlined,
  ),
];

// 2. ConsumerWidget limpio
class OccupationStepView extends ConsumerWidget {
  final PageController pageController;

  const OccupationStepView({super.key, required this.pageController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _OccupationHeader(),

          const SizedBox(height: 30),

          // --- LISTA DE OPCIONES ---
          for (final option in _occupationOptions)
            OccupationCardWidget(
              option: option,
              isSelected: state.selectedOccupation == option.title,
              ontap: () => notifier.updateOccupation(option.title),
            ),

          const SizedBox(height: 24),

          // Boton de siguiente
          _NextButton(
            isEnabled: state.selectedOccupation.isNotEmpty,
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
}

class _OccupationHeader extends StatelessWidget {
  const _OccupationHeader();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "¿A qué te dedicas?",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColorsConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Selecciona la opción que mejor describa tu situación laboral para personalizar tu experiencia.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
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
          backgroundColor: AppColorsConstants.primary,
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
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
