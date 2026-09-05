import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';
import '../../features/auth/presentation/providers/profiling_provider.dart';

/// Widget 1: Solo el texto "Paso X de Y"
class ProfilingStepText extends ConsumerWidget {
  final ProfilingStep currentStep;

  const ProfilingStepText({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(profilingFlowProvider);
    final currentStepIndex = flow.indexOf(currentStep) + 1;
    final totalSteps = flow.length;

    return Text(
      "Paso $currentStepIndex de $totalSteps",
      style: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColorsConstants.textPrimary,
      ),
    );
  }
}

/// Widget 2: Solo los Dots animados
class ProfilingDotsIndicator extends ConsumerWidget {
  final ProfilingStep currentStep;

  const ProfilingDotsIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(profilingFlowProvider);
    final currentStepIndex = flow.indexOf(currentStep) + 1;
    final totalSteps = flow.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = (index + 1) == currentStepIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 40 : 12,
          height: 7,
          decoration: BoxDecoration(
            color: isActive
                ? AppColorsConstants.primary
                : const Color(0x33FF4929),
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}
