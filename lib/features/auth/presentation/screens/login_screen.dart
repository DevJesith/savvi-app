import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvi/core/constants/app_colors_constants.dart';
import 'package:savvi/features/auth/presentation/providers/auth_providers.dart';
import 'package:savvi/features/auth/presentation/providers/login_providers.dart';
import 'package:savvi/features/auth/presentation/screens/user_profiling/user_profiling_flow_screen.dart';
import 'package:savvi/shared/widgets/inputs_reutilizable_widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MediaQuery para obtener dimensiones del dispositivo (Responsive), es decir cuantos pixeles tiene esta pantalla de ancho y largo
    final size = MediaQuery.of(context).size;

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
                  // Header
                  _LoginHeader(),

                  const SizedBox(height: 16),

                  // FORMULARIO
                  _LoginForm(),

                  SizedBox(height: 20),

                  // Divisor para metodos de iniciar de sesion rapido
                  _DividerWithText(text: "O continuar con"),

                  const SizedBox(height: 15),

                  // Iniciar sesion con servicios
                  _SocialAuthButtons(),

                  const SizedBox(height: 20),

                  // Registro
                  _LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
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
                  backgroundColor: WidgetStateProperty.all(Color(0x1AFF4929)),
                  foregroundColor: WidgetStateProperty.all(
                    AppColorsConstants.primary,
                  ),
                  shape: WidgetStateProperty.all(CircleBorder()),
                ),
              ),
            ),

            // Como el Stack tiene aligmente.center,
            // este texto se queda perfectamente centrado respecto al Container padre.
            Text(
              'Bienvenido',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            color: AppColorsConstants.textSecond,
          ),
        ),
      ],
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtenemos los estados desde el archivo de providers
    final formKey = ref.watch(loginFormKeyProvider);
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);
    final isObscure = ref.watch(obscureTextProvider);

    return Form(
      key: formKey,
      child: Column(
        children: [
          // Campo Email
          InputsReutilizableWidgets(
            controller: emailController,
            nameInput: 'Correo electrónico',
            keyboardType: TextInputType.emailAddress,
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
            prefixIcon: const Icon(Icons.mail_outline),
          ),
          const SizedBox(height: 15),
          // Campo Password
          InputsReutilizableWidgets(
            controller: passwordController,
            obscuredText: isObscure,
            keyboardType: TextInputType.visiblePassword,
            nameInput: 'Contraseña',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ingresa tu contraseña';
              }
              return null;
            },
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF64748B),
              ),
              onPressed: () => ref.read(obscureTextProvider.notifier).toggle(),
            ),
          ),
          // Botón ¿Olvidaste tu contraseña?
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: Ruta para recuperación de contraseña
              },
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColorsConstants.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Botón Ingresar
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsConstants.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // TODO: Llamar al repositorio de login
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
        ],
      ),
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;
  const _DividerWithText({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColorsConstants.textSecond,
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 1, color: Colors.grey[300])),
      ],
    );
  }
}

class _SocialAuthButtons extends ConsumerWidget {
  const _SocialAuthButtons();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google
        ElevatedButton(
          onPressed: () async {
            try {
              await ref.read(authRepositoryProvider).signInWithGoogle();
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(e.toString())));
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black12, width: 1),
            ),
          ),
          child: Row(
            children: [
              Image.asset('assets/logo_google.png', width: 20, height: 20),
              const SizedBox(width: 8),
              Text(
                'Google',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        // Apple
        ElevatedButton(
          onPressed: () {
            // TODO: Implementar Sign in with Apple
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Colors.black12, width: 1),
            ),
          ),
          child: Row(
            children: [
              Image.asset('assets/apple_logo.png', width: 22, height: 22),
              const SizedBox(width: 8),
              Text(
                'Apple',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoginFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: GoogleFonts.plusJakartaSans(fontSize: 16),
        ),

        // Boton de registro manual
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UserProfilingFlowScreen(),
              ),
            );
          },
          child: Text(
            'Registrate',
            style: GoogleFonts.plusJakartaSans(
              color: AppColorsConstants.primary,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
