import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  // CORRECCIÓN VITAL: Vinculación exacta de tipos
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    // Primero limpiamos nuestros recursos
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);

    return Scaffold(
      backgroundColor: Color(0XFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 80,
                  color: Color(0xFFFF4929),
                ),
                const SizedBox(height: 12),
                Text(
                  "Verifica tu correo",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Hemos enviado un código de 6 dígitos a \n${state.email}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF71717A),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  obscureText: false,
                  hintCharacter: "•",
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 55,
                    fieldWidth: 45,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedColor: const Color(0xFFFFF7F5),
                    activeColor: const Color(0xFFFF4929),
                    inactiveColor: const Color(0xFFE2E8F0),
                    selectedFillColor: const Color(0xFFFF4929),
                  ),
                  cursorColor: const Color(0xFFFF4929),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  onChanged: (value) {},
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            try {
                              // 1. CAPTURA: Guardamos el código antes de que la pantalla muera
                              final code = _otpController.text;

                              // 2. LÓGICA: Ejecutamos el registro en Supabase
                              await ref
                                  .read(registerProvider.notifier)
                                  .completeRegistration(code);

                              // 3. LIMPIEZA: Si todo salió bien, quitamos las "alfombras"
                              if (mounted) {
                                // Este comando quita todas las pantallas hasta llegar al main.dart
                                Navigator.of(
                                  context,
                                ).popUntil((route) => route.isFirst);
                              }
                            } catch (e) {
                              // Solo mostramos el error si el widget sigue en pantalla
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF4929),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: state.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Confirmar y empezar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "¿No recibiste el código? Reenviar",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFFF4929),
                      fontWeight: FontWeight.bold,
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
