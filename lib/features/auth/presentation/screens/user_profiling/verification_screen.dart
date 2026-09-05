import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';
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

  Future<void> _submitOtp(String code) async {
    if (code.length < 6) return;
    try {
      await ref.read(registerProvider.notifier).completeRegistration(code);
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
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
            color: AppColorsConstants.primary,
          ),

          const SizedBox(height: 30),

          _VerificationHeader(email: state.email),

          const SizedBox(height: 40),

          // --- CAMPO PIN CODE ---
          _OtpInputField(
            controller: _otpController,
            onCompleted: _submitOtp,
            onChanged: (value) => setState(() {}),
          ),

          const SizedBox(height: 40),

          // --- BOTON DE CONFIRMACION ---
          _ConfirmButton(
            isLoading: state.isLoading,
            isEnabled: _otpController.text.length == 6,
            onPressed: () => _submitOtp(_otpController.text),
          ),

          const SizedBox(height: 30),

          // Boton de reenviar
          _ResendButton(
            onPressed: () {
              //TODO: Logica de reenviar OTP si es necesario
            },
          ),
        ],
      ),
    );
  }
}

class _VerificationHeader extends StatelessWidget {
  final String email;
  const _VerificationHeader({required this.email});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Verifica tu correo",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColorsConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: AppColorsConstants.textSecond,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: "Hemos enviado un código de 6 dígitos a:\n"),
              TextSpan(
                text: email,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColorsConstants.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String> onChanged;
  const _OtpInputField({
    required this.controller,
    required this.onCompleted,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: controller,
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
        activeColor: AppColorsConstants.primary,
        inactiveColor: const Color(0xFFE2E8F0),
        selectedFillColor: AppColorsConstants.primary,
      ),
      cursorColor: AppColorsConstants.primary,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;
  const _ConfirmButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: (!isLoading && isEnabled) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorsConstants.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                "Confirmar y empezar",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}

class _ResendButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _ResendButton({required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        "¿No recibiste el código? Reenviar",
        style: GoogleFonts.plusJakartaSans(
          color: AppColorsConstants.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
