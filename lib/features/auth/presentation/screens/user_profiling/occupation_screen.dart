import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/profiling_provider.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';

import 'package:savvi/shared/widgets/occupationCard_widget.dart';

class OccupationStepView extends ConsumerStatefulWidget {
  final PageController pageController;
  const OccupationStepView({super.key, required this.pageController});

  @override
  ConsumerState<OccupationStepView> createState() => _OccupationStepViewState();
}

class _OccupationStepViewState extends ConsumerState<OccupationStepView> {


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    // Opciones a elegir
    final List<OccupationOption> options = [
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

                Text(
                  "¿A qué te dedicas?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
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

                const SizedBox(height: 30),

                // --- LISTA DE OPCIONES (Iteracion Limpia) ---
                for (final option in options)
                  OccupationcardWidget(
                    option: option,
                    isSelected: state.selectedOccupation == option.title,
                    ontap: () => notifier.updateOccupation(option.title),
                  ),

                const SizedBox(height: 24),

                // Boton de siguiente
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.selectedOccupation.isEmpty
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
                ),
              ],
            ),
          ),
        );
      }
}
