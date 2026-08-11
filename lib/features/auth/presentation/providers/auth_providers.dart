import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/core/constants/api_constants.dart';
import 'package:savvi/features/auth/data/repositories_impl/auth_repository_impl.dart';
import 'package:savvi/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider que expone la implementacion real de Supabase
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

// Provider que expone la interfaz del Repositorio
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Le pasamos el cliente de Supabase al constructor
  final client = ref.watch(supabaseClientProvider);
  return AuthRepositoryImpl(client);
});

// Este provider se encarga de gritale a la app si el usuario esta:
// 1. Logueado 2. Deslogueado o 3. Cargando
final authStateProvider = StreamProvider<AuthState>((ref) {
  // Le pedimos al repositorio su "radio" (Stream)
  return ref.watch(authRepositoryProvider).onAuthStateChange;
});

// // SplashNotifier es un "Notifier" de Riverpod que maneja un estado de tipo booleano (`bool`).
// // Sirve para controlar si la pantalla de bienvenida (Splash Screen) ya terminó de mostrarse.
class SplashNotifier extends Notifier<bool> {
  // El metodo build inicializa el estado.
  // Al empezar, el estado es `false` porque el Splash aún no ha terminado.
  @override
  build() => false;

  // Metodo público que permite cambiar el estado a `true` cuando queramos
  // marcar que la animacion o visualizacion del Splash ha finalizado.
  void complete() {
    state = true;
  }
}

final splashFinishedProvider = NotifierProvider<SplashNotifier, bool>(
  SplashNotifier.new,
);

// Este provider leera si el usuario ya vio el onboarding
// Lo ponemos como FutureProvider porque leer el disco del cel toma tiempo.
final hasSeenOnboardingProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(ApiConstants.seenOnboardingKey) ?? false;
});
