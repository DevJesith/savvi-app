import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/shared/widgets/usageIntentCard_widget.dart';

// TODO: Tal vez se omita para el MVP
class UsageIntentStepView extends ConsumerStatefulWidget {
  final PageController pageController;
  const UsageIntentStepView({super.key, required this.pageController});

  @override
  ConsumerState<UsageIntentStepView> createState() => _UsageIntentStepViewState();
}

class _UsageIntentStepViewState extends ConsumerState<UsageIntentStepView> {


  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

    // Opciones a elegir
    final List<UsageOption> options = [
      UsageOption(
        title: 'Finanzas personales',
        description: 'Control total de tus ingresos y egresos diarios',
        icon: Icons.person_outline,
      ),
      UsageOption(
        title: 'Control de negocio',
        description: 'Gestiona las cuentas y facturas de tu emprendimiento',
        icon: Icons.storefront_outlined,
      ),
      UsageOption(
        title: 'Metas de ahorro',
        description: 'Define objetivos y monitorea tu progreso semanal',
        icon: Icons.savings_outlined,
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

                Text(
                  "¿Cómo planeas usar Savvi?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  "Personalizaremos tu experiencia según tu elección",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: const Color(0xFF64748B),
                  ),
                ),

                const SizedBox(height: 20),

                // --- LISTA DE OPCIONES ---
                for (final option in options)
                  UsageintentcardWidget(
                    option: option,
                    isSelected: state.selectedUsageIntent == option.title,
                    onTap: () => notifier.updatedUsageIntent(option.title),
                  ),

                const SizedBox(height: 16),

                // Boton de siguiente
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.selectedUsageIntent.isEmpty
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
