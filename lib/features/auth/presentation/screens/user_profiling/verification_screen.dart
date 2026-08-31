import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';

class VerificationStepView extends ConsumerStatefulWidget {
  final PageController pageController;
  const VerificationStepView({super.key, required this.pageController});

  @override
  ConsumerState<VerificationStepView> createState() =>
      _VerificationStepViewState();
}

class _VerificationStepViewState extends ConsumerState<VerificationStepView> {
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 80,
            color: Color(0xFFFF4929),
          ),

          const SizedBox(height: 30),

          Text(
            "Verifica tu correo",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 12),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                color: const Color(0xFF64748B),
                height: 1.5,
              ),
              children: [
                const TextSpan(
                  text: "Hemos enviado un código de 6 dígitos a:\n",
                ),
                TextSpan(
                  text: state.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // --- CAMPO PIN CODE ---
          PinCodeTextField(
            appContext: context,
            length: 6,
            controller: _otpController,
            keyboardType: TextInputType.number,
            animationType: AnimationType.fade,
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
            onChanged: (value) {
              if (!mounted) return;
            },
          ),

          const SizedBox(height: 40),

          // --- BOTON DE CONFIRMACION ---
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      try {
                        final code = _otpController.text;
                        await ref
                            .read(registerProvider.notifier)
                            .completeRegistration(code);

                        // Si el login es exitoso, el main.dart cambiara de pantalla solo.
                        // Pero por seguridad de UI, limpiamos la pila:
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                      } catch (e) {
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
          const SizedBox(height: 30),

          TextButton(
            onPressed: () {
              // TODO: Lógica de reenviar OTP si es necesario
            },
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
    );
  }
}
