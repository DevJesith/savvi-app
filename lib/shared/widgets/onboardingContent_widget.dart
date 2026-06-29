import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/features/auth/presentation/screens/welcome_screen.dart';

class OnboardingcontentWidget extends ConsumerWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final VoidCallback? onSkipPressed;

  const OnboardingcontentWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.onSkipPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final currentPage = ref.watch(pageIndexProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.width * 0.05,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkipPressed,
              child: Text(
                'Saltar',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF4929),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Flexible(
            flex: 6,
            child: Center(
              child: Column(
                children: [
                  Image.asset(imagePath, height: 330, width: 330),
                  const SizedBox(height: 20),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: const Color(0xFF0F172A),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Generamos los dots dinamicamente
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Se genera 3 dots, esto aplica mucho el DRY porque en vez de copiar y pegar 3 container, el generate nos ayuda a generar 3 dots. Ayuda mucho a la escalabilidad y ahorrar codigo
                    children: List.generate(3, (index) {
                    // Comparamos el dot actual con el estado de Riverpod
                      final isActive = index == currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 40 : 12, // Si esta activo es mas largo
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFFFF4929)
                              : const Color(0x33FF4929),
                          borderRadius: BorderRadius.circular(50),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4929),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                buttonText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
