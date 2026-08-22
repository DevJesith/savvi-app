import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/verification_screen.dart';
// import 'package:savvi/shared/widgets/occupationCard_widget.dart';
import 'package:savvi/shared/widgets/usageIntentCard_widget.dart';

class UsageintentScreen extends ConsumerWidget {
  const UsageintentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);

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
        description: 'Define objectivos y monitorea tu progreso semanal',
        icon: Icons.savings_outlined,
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

                const SizedBox(height: 30),

                Text(
                  "¿Como planeas usar Savvi?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  "Personalizaremos tu experiencia segun tu eleccion",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
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

                const SizedBox(height: 8),

                // Boton de siguiente
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.selectedUsageIntent.isEmpty
                        ? null
                        : () {
                            // TODO: Navegar a la pantalla 5
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VerificationScreen(),
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
