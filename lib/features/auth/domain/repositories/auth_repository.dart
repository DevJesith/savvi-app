import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:savvi/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<AuthState> get onAuthStateChange;

  User? get currentUser;

  //Funciones de entrada y salida
  Future<void> signInWithGoogle();
  Future<void> signOut();

  // Registra un usuario y devuelve exito o un error
  Future<void> registerWithEmail({
    required UserEntity user,
    required String password,
  });

  Future<void> verifyOTP({required String email, required String token});

  Future<void> updateProfile({
    required String userId,
    required UserEntity user,
    required String occupation,
    required String usageIntent,
  });
}
