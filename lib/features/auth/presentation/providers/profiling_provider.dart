import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. El mapa de pasos posibles
enum ProfilingStep {
  register, // Paso 1
  location, // Paso 2
  occupation, // Paso 3
  intent, // Paso 4
  verification, // Paso 5
}

// 2. El orden oficial del flujo.
// Este provider es la "Verdad Absoluta" sobre cuantos pasos hay y en que orden van.
final profilingFlowProvider = Provider<List<ProfilingStep>>((ref) {
  return [
    ProfilingStep.register,
    ProfilingStep.location,
    ProfilingStep.occupation,
    ProfilingStep.intent,
    ProfilingStep.verification,
  ];
});

// 3. El Notifier que maneja el paso activo actual
class CurrentProfilingStepNotifier extends Notifier<ProfilingStep> {
  @override
  ProfilingStep build() => ProfilingStep.register;

  void setStep(ProfilingStep step) {
    state = step;
  }
}

// 4. El Provider global para el paso activo actual
final currentProfilingStepProvider =
    NotifierProvider<CurrentProfilingStepNotifier, ProfilingStep>(
      CurrentProfilingStepNotifier.new,
    );
