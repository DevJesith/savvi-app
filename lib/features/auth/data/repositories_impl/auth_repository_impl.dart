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

  // Comprueba si el usuario tiene todos los datos obligatorios
  // antes de permitirle acceder al Dashboard.
  @override
  Future<bool> hasProfile({required String userId}) async {
    try {
      final profile = await _supabase
          .from('profiles')
          .select('country, occupation, usage_intent, birth_date')
          .eq('id', userId)
          .maybeSingle();

      if (profile == null) {
        return false;
      }

      final country = profile['country'];
      final occupation = profile['occupation'];
      final usageIntent = profile['usage_intent'];
      final birthDate = profile['birth_date'];

      return country != null &&
          country.toString().trim().isNotEmpty &&
          occupation != null &&
          occupation.toString().trim().isNotEmpty &&
          usageIntent != null &&
          usageIntent.toString().trim().isNotEmpty &&
          birthDate != null;
    } on PostgrestException catch (e) {
      throw Exception('Error al consultar el perfil: ${e.message}');
    } catch (e) {
      throw Exception(
        'No se pudo comprobar el perfil. Revisa tu conexión a internet.',
      );
    }
  }

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
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      print('🔴 Sesión creada: ${_supabase.auth.currentSession != null}');
      print(' 🔴Usuario autenticado: ${_supabase.auth.currentUser?.email}');
    } on AuthApiException catch (e) {
      print('🔴 Error de Supabase: ${e.message}');
      //Traducimos los errores mas comunes de supabase a mensaje amigables
      if (e.message.contains('Invalid login credentials')) {
        throw Exception('🔴 Correo o contraseña incorrectos.');
      } else if (e.message.contains('Email not confirmed')) {
        throw Exception('🔴 Por favor confirma tu correo antes ingresar.');
      }
      throw Exception(e.message);
    } catch (e) {
      print('🔴 Error de autenticación: $e');
      throw Exception(
        '🔴 Error al conectar con el servidor. Revisa tu conexion a internet',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      // Solicitamos la funcion de supbase de restablecer contraseña por medio de email
      await _supabase.auth.resetPasswordForEmail(
        email.trim().toLowerCase(),
        redirectTo: 'io.supabase.flutter://callback',
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Error al enviar el correo de recuperacion. '
        'Revisa tu conexion a internet.',
      );
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      // Actualizamos el registro con la contraseña nueva
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Error al actualizar la contraseña. '
        'Revisa tu conexion a internet',
      );
    }
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
      emailRedirectTo: 'io.supabase.flutter://callback',
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
  Future<void> resendVerificationCode({required String email}) async {
    try {
      // Solicitar reenvio de OTP
      await _supabase.auth.resend(
        type: OtpType.signup,
        email: email.trim().toLowerCase(),
      );
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
        'Error al reenviar el codigo.'
        'Revisa tu conexion a internet',
      );
    }
  }

  // Inserta o actualiza los datos adicionales del perfil.
  // El usuario ya debe estar autenticado antes de ejecutar este metodo.
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
          .upsert({
            'id': userId,
            'full_name': '${user.name} ${user.lastname}',
            'email': user.email,
            'birth_date': user.birthDate?.toIso8601String(),
            'currency': user.currency,
            'occupation': occupation,
            'usage_intent': usageIntent,
            'country': user.country,
          })
          .eq('id', userId);
    } on PostgrestException catch (e) {
      throw Exception("Error al guardar el perfil: $e");
    } catch (e) {
      throw Exception('Error inesperado al guardar el perfil.');
    }
  }
}
