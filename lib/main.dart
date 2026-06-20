import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:savvi/core/constants/api_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  runApp(const SavviApp());
}

class SavviApp extends StatelessWidget {
  const SavviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savvi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Savvi Online 🚀',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
