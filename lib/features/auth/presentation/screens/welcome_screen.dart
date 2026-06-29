import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/screens/login_screen.dart';
import 'package:savvi/shared/widgets/onboardingContent_widget.dart';

// Notifier para manejar el índice de página
class PageIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setPage(int index) {
    state = index;
  }
}

final pageIndexProvider = NotifierProvider<PageIndexNotifier, int>(
  PageIndexNotifier.new,
);

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = PageController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bloque central con PageView
            Expanded(
              child: PageView(
                // Es el volante que nos permite mover las paginas por codigo
                controller: pageController,
                // Cada vez que el usuario desliza el dedo, avisamos a Riverpod
                onPageChanged: (index) {
                  ref.read(pageIndexProvider.notifier).setPage(index);
                },
                physics: NeverScrollableScrollPhysics(),
                children: [
                  OnboardingcontentWidget(
                    imagePath: 'assets/Onboarding - gastos.png',
                    title: 'Controla tus gastos',
                    subtitle:
                        'Registra cada transacción en segundos y visualiza hacia dónde se va tu dinero con gráficos inteligentes',
                    buttonText: 'Siguiente',
                    onButtonPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnboardingcontentWidget(
                    imagePath: 'assets/Onboarding - metas.png',
                    title: 'Alcanza tus metas',
                    subtitle:
                        'Crea objetivos de ahorro personalizados y visualiza tu progreso con herramientas inteligentes',
                    buttonText: 'Siguiente',
                    onButtonPressed: () {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnboardingcontentWidget(
                    imagePath: 'assets/Onboarding - graficas.png',
                    title: 'Visualiza tus reportes',
                    subtitle:
                        'Administra tus finanzas con reportes claros y prácticos',
                    buttonText: 'Comenzar',
                    onButtonPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
