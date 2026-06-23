import 'package:supabase_flutter/supabase_flutter.dart';

// 1. Creamos la "Oficina" de autenticacion
class AuthRepository {
  // 2. El "Telefono" privado para hablar con Supabase.
  // El guion bajo (_) significa que es PRIVADO.
  // Solo la gente dentro de esta oficina puede usar este telefono
  final SupabaseClient _supabase = Supabase.instance.client;

  // 3. El "Sensor de la puerta" (Stream).
  // Imagina un sensor que avisa cada vez que alguien entra o sale.
  // La app usara esto para saber si debe mostrar el login o el Dashboard.
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  Future<void> signInWithGoogle() async {
    try {
      // 1. Llamammos al flujo de Google
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        // Este link le dice a Supabase a donde volver tras el login.
        // Por ahora usamos el estanda de Supabase.
        redirectTo: 'io.supabase.flutter://callback',
      );
    } catch (e) {
      // Si algo falla (ej. internet), lanzamos el error para que la UI lo muestre
      throw Exception("Error al conectar con Google; $e");
    }
  }
  
  // Funcion para cerrar sesion
  Future<void> signOut() async {
    // await le dice a la app: "Espera a que Supabase me cofnrime que ya cerro la sesion antes de seguir"
    await _supabase.auth.signOut();
  }


  
}
