import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/providers/profiling_provider.dart';
import 'package:savvi/shared/widgets/profiling_progress_widgets.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/register_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/location_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/occupation_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/usage_intent_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/verification_screen.dart';

class UserProfilingFlowScreen extends ConsumerStatefulWidget {
  const UserProfilingFlowScreen({super.key});

  @override
  ConsumerState<UserProfilingFlowScreen> createState() => _UserProfilingFlowScreenState();
}

class _UserProfilingFlowScreenState extends ConsumerState<UserProfilingFlowScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Restablecemos al primer paso al iniciar
    Future.microtask(() {
      ref.read(currentProfilingStepProvider.notifier).setStep(ProfilingStep.register);
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
    final flow = ref.watch(profilingFlowProvider);
    final currentPageIndex = flow.indexOf(currentStep);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ProfilingStepText(
          currentStep: currentStep,
        ),
        leading: IconButton(
          onPressed: () {
            if (currentPageIndex == 0) {
              Navigator.of(context).pop();
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
            Center(
              child: ProfilingDotsIndicator(
                currentStep: currentStep,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Evita deslizamientos manuales accidentales
                onPageChanged: (index) {
                  ref.read(currentProfilingStepProvider.notifier).setStep(flow[index]);
                },
                children: [
                  RegisterStepView(pageController: _pageController),
                  LocationStepView(pageController: _pageController),
                  OccupationStepView(pageController: _pageController),
                  UsageIntentStepView(pageController: _pageController),
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
