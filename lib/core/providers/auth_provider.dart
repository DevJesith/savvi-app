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
