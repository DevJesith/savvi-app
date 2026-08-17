import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/usageIntent_screen.dart';
import 'package:savvi/shared/widgets/occupationCard_widget.dart';

class OccupationScreen extends ConsumerWidget {
  OccupationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    // Definimios las opciones de la ocupacion
    final List<OccupationOption> options = [
      OccupationOption(
        title: 'Estudiante',
        description: 'En formacion academica',
        icon: Icons.school_outlined,
      ),
      OccupationOption(
        title: 'Empleado',
        description: 'Trabajo por cuenta ajena',
        icon: Icons.work_outline,
      ),
      OccupationOption(
        title: 'Autonomo / Freenlace',
        description: 'Trabajo independiente',
        icon: Icons.person_outline,
      ),
      OccupationOption(
        title: 'Jubiliado',
        description: 'Retirado de la vida laboral',
        icon: Icons.bed_outlined,
      ),
      OccupationOption(
        title: 'Otros',
        description: 'Desempleado o situaction diverssa',
        icon: Icons.more_horiz_outlined,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LinearProgressIndicator(
                  value: 0.75,
                  backgroundColor: Color(0xFFE2E8F0),
                  color: Color(0xFFFF4929),
                  minHeight: 6,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
            
                const SizedBox(height: 35),
            
                Text(
                  "¿A que te dedicas?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            
                const SizedBox(height: 15),
            
                Text(
                  "Selecciona la opcion que mejor describa tu situacion laboral actual para personalizar tu experiencia.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            
                const SizedBox(height: 30),
            
                // --- LISTA DE OPCIONES ---
                for (final option in options)
                  OccupationcardWidget(
                    option: option,
                    isSelected: state.selectedOccupation == option.title,
                    ontap: () => notifier.updateOccupation(option.title),
                  ),
            
                const SizedBox(height: 16),
            
                // Boton de siguiente
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.selectedOccupation.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsageintentScreen(),
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
        ),
      ),
    );
  }
}
