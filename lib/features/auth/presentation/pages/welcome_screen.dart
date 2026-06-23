import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/core/providers/auth_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // Usamos un SafeArea para que el notch del celular no tape nada
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Icono o logo
              const Icon(
                Icons.account_balance_wallet_rounded,
                size: 100,
                color: Colors.greenAccent,
              ),

              const SizedBox(height: 20),

              // 2. Titulo y Eslogan
              const Text(
                "Savvi",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                "Toma el control de tus finanzas",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 60),

              // 3. Boton de Google (SIMULADO POR AHORA)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // // Llamamos a la ligica de Google mas adelante
                    // print("Intentando entrar con Google");

                    try {
                      // 1. Accedemos al repositorio a traves del provider
                      await ref.read(authRepositoryProvider).signInWithGoogle();
                    } catch (e) {
                      // 2. Si hay error, mostramos un mensaje rapido (SnackBar)
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: const Icon(Icons.login_rounded),
                  label: const Text(
                    "Continuar con Google",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4. Opcion de registro clasico (Solo visual por ahora)
              TextButton(
                onPressed: () {},
                child: const Text("O usa tu correo electronico "),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
