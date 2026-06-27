import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Patron Singleton
// Creamos una instancia unica de nuestro oficina de auth.
// Esto permite que toda la app use el mismo cajero/repositorio
final authRepositoryProvider = Provider((ref) {
  return AuthRepository();
});

// Este provider se encarga de gritale a la app si el usuario esta:
// 1. Logueado 2. Deslogueado o 3. Cargando
final authStateProvider = StreamProvider<AuthState>((ref) {
  // Le pedimos al repositorio su "radio" (Stream)
  return ref.read(authRepositoryProvider).onAuthStateChange;
});

//--------- SPLASH -----------

// SplashNotifier es un "Notifier" de Riverpod que maneja un estado de tipo booleano (`bool`).
// Sirve para controlar si la pantalla de bienvenida (Splash Screen) ya terminó de mostrarse.
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

// Este provider expone la logica y el estado de SplashNotifier para que cualquier
// pantalla o widget de la aplicacion pueda saber si el Splash ya termino.
final splashFinishedProvider = NotifierProvider<SplashNotifier, bool>(() {
  return SplashNotifier();
});
