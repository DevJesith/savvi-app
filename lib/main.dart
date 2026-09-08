import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savvi/core/constants/api_constants.dart';
import 'package:savvi/core/theme/app_theme.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/screens/login_screen.dart';
import 'package:savvi/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:savvi/features/auth/presentation/screens/splash_screen.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/user_profiling_flow_screen.dart';
import 'package:savvi/features/auth/presentation/screens/welcome_screen.dart';
import 'package:savvi/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Asegura que Flutter se encuentre inicializado antes de conectar con Supabase
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializacion de Supabase
    await Supabase.initialize(
      url: ApiConstants.supabaseUrl,
      publishableKey: ApiConstants.supabasePublishKey,
    );
    print("Success conexion ✅");
  } catch (e) {
    print("Error de conexión: $e ❌");
  }

  // ProviderScope es como la planta electica que actica los providers
  runApp(const ProviderScope(child: SavviApp()));
}

// ConsumerWidget permite que este widget use el objeto ref para leer datos
class SavviApp extends ConsumerWidget {
  const SavviApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch hace que esta pantalla se redibuje sola si el usuario entra o sale
    final authState = ref.watch(authStateProvider);

    // Escucha el provider para saber si la animacion o espera del Splash ya terminO.
    // Al usar ref.watch, Riverpod reconstruira este build() automaticamente cuando el valor cambie de false a true.
    final isSplashFinished = ref.watch(splashFinishedProvider);

    return MaterialApp(
      title: 'Savvi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // LA PUERTA INTELIGENTE (Auth Guard)
      // Usamos .when para manejar los 3 estados del StreamProvider
      home: !isSplashFinished
          ? const SplashScreen()
          : authState.when(
              // CASO A: Tenemos una respuesta de Supabase
              data: (data) {
                if (data.event == AuthChangeEvent.passwordRecovery) {
                  return const ResetPasswordScreen();
                }

                // ESCENARIO 1: Usuario logueado
                if (data.session != null) {
                  final user = data.session!.user;
                  final isGoogleUser =
                      user.appMetadata['provider'] == 'google' ||
                      user.identities?.any(
                            (identity) => identity.provider == 'google',
                          ) ==
                          true;

                  print('☁️ Proveedor: ${user.appMetadata['provider']}');
                  print('☁️ Identidades: ${user.identities}');
                  print('☁️ Es Google: $isGoogleUser');

                  final profileState = ref.watch(hasProfileProvider(user.id));

                  return profileState.when(
                    loading: () => const SplashScreen(),
                    error: (error, stackTrace) {
                      return Scaffold(
                        body: Center(
                          child: Text('No se pudo consultar el perfil: $error'),
                        ),
                      );
                    },
                    data: (hasProfile) {
                      // Un perfil completo puede acceder directamente al Dashboard.
                      // Un perfil incompleto de Google debe terminar UserProfiling.
                      print('☁️ Tiene perfil: $hasProfile');
                      print('☁️ User ID consultado: ${user.id}');
                      if (hasProfile) {
                        return const DashboardScreen();
                      }

                      if (!isGoogleUser) {
                        return const DashboardScreen();
                      }

                      final metadata = user.userMetadata ?? {};

                      final fullName =
                          (metadata['full_name'] ?? metadata['name'] ?? '')
                              .toString()
                              .trim();

                      final nameParts = fullName.isEmpty
                          ? <String>[]
                          : fullName.split(RegExp(r'\s+'));

                      final googleName = nameParts.isNotEmpty
                          ? nameParts.first
                          : '';

                      final googleLastname = nameParts.length > 1
                          ? nameParts.sublist(1).join(' ')
                          : '';

                      return UserProfilingFlowScreen(
                        googleEmail: user.email ?? '',
                        googleName: googleName,
                        googleLastName: googleLastname,
                      );
                    },
                  );
                }

                // ESCENARIO 2: Usuario deslogueado
                // Aqui llamamos al otro provider
                final hasSeenOnboarding = ref.watch(hasSeenOnboardingProvider);

                return hasSeenOnboarding.when(
                  data: (seen) {
                    if (seen) {
                      // Ya lo vio -> va directo al Login
                      return const LoginScreen();
                    } else {
                      // Es nuevo -> Va al Onboarding (welcome)
                      return const WelcomeScreenOnboarding();
                    }
                  },
                  loading: () => const SplashScreen(),
                  error: (_, __) =>
                      const LoginScreen(), // Por si falla, mejor mandarlo al login
                );
              },
              // TODO: CASO B: Si el splash terminó pero Supabase sigue cargando,
              // simplemente mantenemos el Splash o un fondo neutro.
              loading: () => SplashScreen(),
              // CASO C: Algo exploto (ej. No hay internet)
              error: (err, stack) => Scaffold(
                body: Center(child: Text("Error de conexion; $err")),
              ),
            ),
    );
  }
}
