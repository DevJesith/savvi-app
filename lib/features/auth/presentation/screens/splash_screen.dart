import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/core/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _startLoading();
  }

  void _startLoading() {
    // Simulamos una carga de 3 segundos
    const duration = Duration(milliseconds: 30); //30ms * 100 = 3 segundos aprox
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.01; // Sube un 1% sucesuvamente
        } else {
          _timer.cancel();
          // Le avisamos al provider que ya terminamos.
          ref.read(splashFinishedProvider.notifier).complete();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF8F6F5),

      body: SafeArea(
        child: Center(
          child: Padding(
            // Margen proporcional: 5% del ancho en cada lado
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.05,
              vertical: size.width * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // El logo de la app
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/Logo_Savvi.png',
                        height: 80,
                        width: 80,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Savvi",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),

                      // const SizedBox(height: 10),
                      Text(
                        'Tu compañero de finanzas personales',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // alinea todo a la izquierda
                    children: [
                      // Texto + porcentaje en una fila
                      Row(
                        children: [
                          Text(
                            "Cargando tu dashboard...",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0XFF475569),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${(_progress * 100).toInt()}%",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF4929),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Barra de progreso debajo del Row
                      SizedBox(
                        width: size.width * 0.8,
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.grey[200],
                          color: const Color(0xFFFF4929),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
