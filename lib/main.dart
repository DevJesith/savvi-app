import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savvi/core/constants/api_constants.dart';
import 'package:savvi/core/providers/auth_provider.dart';
import 'package:savvi/features/auth/presentation/pages/login_screen.dart';
import 'package:savvi/features/auth/presentation/pages/welcome_screen.dart';
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

    return MaterialApp(
      title: 'Savvi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent),
        useMaterial3: true,
      ),

      // LA PUERTA INTELIGENTE (Auth Guard)
      // Usamos .when para manejar los 3 estados del StreamProvider
      home: authState.when(
        // CASO A: Tenemos una respuesta de Supabase
        data: (data) {
          if (data.session != null) {
            // Si hay sesion activa, lo dirige al Dashboard
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hola, ${data.session!.user.email}'),
                    const SizedBox(height: 20),
                    ElevatedButton(onPressed: () async {
                      await ref.read(authRepositoryProvider).signOut();
                    }, child: Text("Cerrar sesion")),
                  ],
                ),
              ),
            );
          } else {
            // Si no hay sesion, lo dirige al Login
            return LoginScreen();
          }
        },
        // CASO B: Supabase esta pensando...
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        // CASO C: Algo exploto (ej. No hay internet)
        error: (err, stack) =>
            Scaffold(body: Center(child: Text("Error de conexion; $err"))),
      ),
    );
  }
}
