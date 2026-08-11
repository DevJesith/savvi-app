import 'package:savvi/features/auth/domain/entities/user_entity.dart';
import 'package:savvi/features/auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  @override
  Stream<AuthState> get onAuthStateChange => _supabase.auth.onAuthStateChange;

  @override
  User? get currentUser => _supabase.auth.currentUser;

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://callback',
      );
    } catch (e) {
      throw Exception("Error al conectar con Google: $e");
    }
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> registerWithEmail({
    required UserEntity user,
    required String password,
  }) async {
    // 1. Registro en la tabla Auth de Supabase
    await _supabase.auth.signUp(
      email: user.email.trim().toLowerCase(),
      password: password,
      emailRedirectTo: 'io.supabase.flutter://callback'
    );

    // if (response.user != null) {
    //   // 2. Si el registro fue exitoso, guardamos los datos extra en la tabla 'profiles'
    //   await _supabase.from('profiles').insert({
    //     'id': response.user!.id,
    //     'full_name': '${user.name} ${user.lastname}',
    //     'birth_date': user.birthDate?.toIso8601String(),
    //   });
    // }
  }

  @override
  Future<void> verifyOTP({required String email, required String token}) async {
    try {
      await _supabase.auth.verifyOTP(
        type: OtpType.signup,
        email: email.trim(),
        token: token.trim(),
      );
    } on AuthApiException catch (e) {
      // Capturamos erroes especificos de Supabase (ej. codigo incorrecto)
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Error inesperado al verificar el codigo");
    }
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required UserEntity user,
    required String occupation,
    required String usageIntent,
  }) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            'full_name': '${user.name} ${user.lastname}',
            'birth_date': user.birthDate?.toIso8601String(),
            'currency': user.currency,
            'occupation': occupation,
            'usage_intent': usageIntent,
            'country': user.country
          })
          .eq('id', userId);
    } catch (e) {
      throw Exception("Error al guardar el perfil: $e");
    }
  }
}
