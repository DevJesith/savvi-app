import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/core/constants/api_constants.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
// import 'package:savvi/features/auth/presentation/screens/login_screen.dart';
import 'package:savvi/shared/widgets/onboarding_content_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class WelcomeScreenOnboarding extends ConsumerStatefulWidget {
  const WelcomeScreenOnboarding({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WelcomeScreenOnboardingState();
}

class _WelcomeScreenOnboardingState
    extends ConsumerState<WelcomeScreenOnboarding> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bloque central con PageView
            Expanded(
              child: PageView(
                // Es el volante que nos permite mover las paginas por codigo
                controller: _pageController,
                // Cada vez que el usuario desliza el dedo, avisamos a Riverpod
                onPageChanged: (index) {
                  ref.read(pageIndexProvider.notifier).setPage(index);
                },
                physics: NeverScrollableScrollPhysics(),
                children: [
                  OnboardingContentWidget(
                    imagePath: 'assets/Onboarding - gastos.png',
                    title: 'Controla tus gastos',
                    subtitle:
                        'Registra cada transacción en segundos y visualiza hacia dónde se va tu dinero con gráficos inteligentes',
                    buttonText: 'Siguiente',
                    onButtonPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnboardingContentWidget(
                    imagePath: 'assets/Onboarding - metas.png',
                    title: 'Alcanza tus metas',
                    subtitle:
                        'Crea objetivos de ahorro personalizados y visualiza tu progreso con herramientas inteligentes',
                    buttonText: 'Siguiente',
                    onButtonPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  OnboardingContentWidget(
                    imagePath: 'assets/Onboarding - graficas.png',
                    title: 'Visualiza tus reportes',
                    subtitle:
                        'Administra tus finanzas con reportes claros y prácticos',
                    buttonText: 'Comenzar',
                    onButtonPressed: () async {
                      // 1. Guardamos en la memoria local que ya vio el Onboarding
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(ApiConstants.seenOnboardingKey, true);

                      // 2. Navegamos al login
                      // Obligamos al provider a leer el disco de nuevo
                      ref.invalidate(hasSeenOnboardingProvider);
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
