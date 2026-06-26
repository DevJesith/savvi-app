import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/providers/auth_provider.dart';
import 'package:savvi/features/auth/presentation/providers/login_providers.dart';
import 'package:savvi/shared/widgets/inputs_reutilizable_widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MediaQuery para obtener dimensiones del dispositivo (Responsive), es decir cuantos pixeles tiene esta pantalla de ancho y largo
    final size = MediaQuery.of(context).size;

    // Obtenemos los estados desde el archivo de providers
    final formKey = ref.watch(loginFormKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final isObscure = ref.watch(obscureTextProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F5),
      // Evita que el contenido toque el notch/camara
      body: SafeArea(
        child: Center(
          // El mejor amigo del responsive. Cuando el usuario abre el teclado para escribir, el espacio de la pantalla se reduce a la mitad. Este widget permite que la app se deslice y no "explote" al abrir el teclado.
          child: SingleChildScrollView(
            child: Container(
              width:
                  size.width * 0.9, // Responsive 90% del ancho del dispositivo
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: BoxBorder.all(
                  color: Color.fromARGB(34, 255, 73, 41),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECCION DE ENCABEZADO: STACK CENTRADO ABSOLUTO
                  Stack(
                    // Asegura que todos los hijos que NO tengan un Align
                    // propio se ubiquen en el centro del Stack
                    alignment: Alignment.center,
                    children: [
                      // Usamos Align para anclar el boton a la izquierda
                      // sin que interfiera con la posicion del titulo
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            //TODO: Boton funcional pronto cuando este completo el Onboarding
                            print('Atrás');
                          },
                          icon: Icon(Icons.arrow_back),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              Color(0x1AFF4929),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              Color(0xFFFF4929),
                            ),
                            shape: WidgetStateProperty.all(CircleBorder()),
                          ),
                        ),
                      ),

                      // Como el Stack tiene aligmente.center,
                      // este texto se queda perfectamente centrado respecto al Container padre.
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

                  // Titulo de iniciar sesion
                  Text(
                    'Iniciar sesion',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Subtitulo de proposito
                  Text(
                    'Gestiona tus finanzas de forma segura y alcanza tus metas',
                    style: GoogleFonts.plusJakartaSans(fontSize: 16),
                  ),

                  const SizedBox(height: 16),

                  // FORMULARIO
                  Form(
                    // Asignamos la llave (el control remoto)
                    // Ahora ref.watch(LoginFormKeyProvider) tiene el poder sobre este form
                    key: formKey,
                    child: Column(
                      children: [
                        // Email - Widget reutilizable/modificable
                        InputsReutilizableWidgets(
                          controller: emailController,
                          nameInput: 'Correo electronico',
                          //Validacion del campo
                          validator: (value) {
                            // Si se encuentra vacio retorna mensaje
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu correo';
                            }
                            // Parametro que cumpla la direccion del email
                            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Correo inválido';
                            }
                            return null; // Significa que "Todo esta perfecto"
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

                        // Password - Widget reutilizable/modificable
                        InputsReutilizableWidgets(
                          controller: passwordController,
                          obscuredText: isObscure,
                          keyboardType: TextInputType.visiblePassword,
                          nameInput: 'Contraseña',
                          validator: (value) {
                            // Si se encuentra vacio retorna mensaje
                            if (value == null || value.trim().isEmpty) {
                              return 'Ingresa tu contraseña';
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
                            // Funcionalidad del ocultar/mostrar contraseña
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscure
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

                  // Posicionamiento LATERAL
                  Align(
                    // Usamos Align porque el Column padre tiene crossAxisAligment.start.
                    // Si no psuieramos este Align, el boton apareciera a la izquierda
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

                  // Boton de iniciar sesion
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
                      onPressed: () {
                        // DISPARADORES DE VALIDACION

                        // Usamos la llave para preguntar: "¿Todos los validadores devolvieron null?"
                        if (formKey.currentState!.validate()) {
                          //SI: los datos son correctos. Aqui llamariamos al Repositorio de iniciar sesion.
                          print("Formulario valido. Iniciando sesion...");
                        } else {
                          // NO: Flutter automaticamente pondre los textos en rojo.
                          print("ERROR: hay campos invalidos");
                        }
                      },
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

                  // Divisor para metodos de iniciar de sesion rapido
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1, // grosor
                          color: Colors.grey[400],
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
                      // Boton de iniciar sesion con Google
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

                      // Boton de iniicar sesion con iOS (por el momento)
                      ElevatedButton(
                        onPressed: () {
                          //TODO: Implement sing in with iOS
                          print('iOS');
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

                      // Boton de registro manual
                      TextButton(
                        onPressed: () {
                          //TODO: Implement Form manual
                          print('Registro');
                        },
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
