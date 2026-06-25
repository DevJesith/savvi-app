import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/providers/auth_provider.dart';
import 'package:savvi/shared/widgets/inputs_reutilizable_widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final formKey = ref.watch(formKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final obscureTextt = ref.watch(obscureTextProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6F5),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              width: size.width * 0.9,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            print('Atrás');
                          },
                          icon: Icon(Icons.arrow_back),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color(0x1AFF4929),
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Color(0xFFFF4929),
                            ),
                            shape: MaterialStateProperty.all(CircleBorder()),
                          ),
                        ),
                      ),

                      Text(
                        'Bienvenido',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text(
                    'Iniciar sesion',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    // textAlign: TextAlign.left,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Gestiona tus finanzas de forma segura y alcanza tus metas',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        // Email
                        InputsReutilizableWidgets(
                          controller: emailController,
                          nameInput: 'Correo electronico',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Correo inválido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: 'ejemplo@correo.com',
                            prefixIcon: const Icon(Icons.mail_outline),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x8AFF4929),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Password
                        InputsReutilizableWidgets(
                          controller: passwordController,
                          obscuredText: obscureTextt,
                          keyboardType: TextInputType.visiblePassword,
                          nameInput: 'Contraseña',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Correo inválido';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '******',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: CupertinoColors.inactiveGray,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0x8AFF4929),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureTextt
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => ref
                                  .read(obscureTextProvider.notifier)
                                  .toggle(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Implement the route for the new direction page
                        print("¡Open the password recovery page!");
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF4929),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(50),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Ingresar',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1, // grosor
                          color: Colors.grey[400], // color
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "O continuar con",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[400]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            // 1. Accedemos al repositorio a traves del provider
                            await ref
                                .read(authRepositoryProvider)
                                .signInWithGoogle();
                          } catch (e) {
                            // 2. Si hay error, mostramos un mensaje rapido (SnackBar)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(20),
                            side: BorderSide(color: Colors.black, width: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/logo_google.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Google',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(20),
                            side: BorderSide(color: Colors.black, width: 0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/apple_logo.png',
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Apple',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: GoogleFonts.plusJakartaSans(fontSize: 16),
                      ),

                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Registrate',
                          style: GoogleFonts.plusJakartaSans(
                            color: Color(0xFFFF4929),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
