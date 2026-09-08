import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/providers/profiling_provider.dart';
import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/shared/widgets/profiling_progress_widgets.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/register_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/location_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/occupation_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/usage_intent_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/verification_screen.dart';

class UserProfilingFlowScreen extends ConsumerStatefulWidget {
  final String? googleEmail;
  final String? googleName;
  final String? googleLastName;

  const UserProfilingFlowScreen({
    super.key,
    this.googleEmail,
    this.googleName,
    this.googleLastName,
  });

  @override
  ConsumerState<UserProfilingFlowScreen> createState() =>
      _UserProfilingFlowScreenState();
}

class _UserProfilingFlowScreenState
    extends ConsumerState<UserProfilingFlowScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // El flujo comienza desde el registro y, si corresponde,
    // carga los datos proporcionados por Google.
    Future.microtask(() {
      ref
          .read(currentProfilingStepProvider.notifier)
          .setStep(ProfilingStep.register);

      ref.read(registerProvider.notifier).resetState();

      final email = widget.googleEmail;
      final name = widget.googleName;
      final lastname = widget.googleLastName;

      if (email != null && name != null && lastname != null) {
        ref
            .read(registerProvider.notifier)
            .initializeFromGoogle(email: email, name: name, lastname: lastname);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = ref.watch(currentProfilingStepProvider);
    // Google no necesita contraseña ni verificacion OTP.
    // El registro manual conserva todos los pasos.
    final flow = widget.googleEmail != null
        ? [
            ProfilingStep.register,
            ProfilingStep.location,
            ProfilingStep.occupation,
            ProfilingStep.intent,
          ]
        : ref.watch(profilingFlowProvider);
    final currentPageIndex = flow.indexOf(currentStep);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ProfilingStepText(currentStep: currentStep),
        leading: IconButton(
          onPressed: () async {
            if (currentPageIndex == 0) {
              if (widget.googleEmail != null) {
                await ref.read(authRepositoryProvider).signOut();
              } else if (context.mounted) {
                Navigator.of(context).pop();
              }
            } else {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Center(child: ProfilingDotsIndicator(currentStep: currentStep)),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Evita deslizamientos manuales accidentales
                onPageChanged: (index) {
                  ref
                      .read(currentProfilingStepProvider.notifier)
                      .setStep(flow[index]);
                },
                children: [
                  RegisterStepView(pageController: _pageController),
                  LocationStepView(pageController: _pageController),
                  OccupationStepView(pageController: _pageController),
                  UsageIntentStepView(pageController: _pageController),
                  if (widget.googleEmail == null)
                    VerificationStepView(pageController: _pageController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
