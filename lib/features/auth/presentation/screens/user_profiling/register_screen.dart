import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:savvi/features/auth/domain/entities/user_entity.dart';
import 'package:savvi/features/auth/presentation/providers/login_providers.dart';

import 'package:savvi/features/auth/presentation/providers/register_providers.dart';
import 'package:savvi/shared/widgets/inputs_reutilizable_widgets.dart';

class RegisterStepView extends ConsumerStatefulWidget {
  final PageController pageController;
  const RegisterStepView({super.key, required this.pageController});

  @override
  ConsumerState<RegisterStepView> createState() => _RegisterStepViewState();
}

class _RegisterStepViewState extends ConsumerState<RegisterStepView> {
  // 1. Controladores persistentes
  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _birthDateController; // Controlador para la fecha

  // Crea los controladores para que esten listos antes de que el widget se pinte
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _birthDateController = TextEditingController();
  }

  // Los cierra/libera cuando el widget se destruye, sirve para que sea eficiente la app y no tenga
  // fugas de memoria ni erorres al navegar entre pantallas
  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(registerProvider);
    final notifier = ref.read(registerProvider.notifier);
    final registerKey = ref.watch(registerFormKeyProvider);

    // Lógica de dominio para la edad (No se muestra en pantalla, se usa para logica)
    final tempUser = UserEntity(
      name: state.name,
      lastname: state.lastname,
      email: state.email,
      birthDate: state.birthDate,
    );
    final ageDisplay = tempUser.age?.toString() ?? '--';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Crea tu cuenta",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            "Completa tus datos personales para continuar con la configuración de tu perfil financiero.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 32),

          // --- FORMULARIO ---
          Form(
            key: registerKey,
            child: Column(
              children: [
                // Campo: Nombre
                InputsReutilizableWidgets(
                  controller: _nameController,
                  nameInput: 'Nombre',
                  onChanged: notifier.updateName,
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                  decoration: InputDecoration(
                    hintText: 'Ej. Juan',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CupertinoColors.inactiveGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x8AFF4929),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Campo: Apellido
                InputsReutilizableWidgets(
                  controller: _lastNameController,
                  nameInput: 'Apellido',
                  onChanged: notifier.updateLastname,
                  validator: (value) =>
                      value!.isEmpty ? 'Campo requerido' : null,
                  decoration: InputDecoration(
                    hintText: 'Ej. Perez',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CupertinoColors.inactiveGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x8AFF4929),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Selector de Fecha
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      notifier.updateBirthDate(date);
                      _birthDateController.text = DateFormat(
                        'dd/MM/yyyy',
                      ).format(date);
                    }
                  },
                  child: AbsorbPointer(
                    child: InputsReutilizableWidgets(
                      controller: _birthDateController,
                      nameInput: 'Fecha de nacimiento',
                      validator: (value) =>
                          value!.isEmpty ? 'Selecciona tu fecha' : null,
                      decoration: InputDecoration(
                        hintText: 'dd/mm/yyyy',
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: CupertinoColors.inactiveGray,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x8AFF4929),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Campo: Email
                InputsReutilizableWidgets(
                  controller: _emailController,
                  nameInput: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: notifier.updateEmail,
                  validator: (value) =>
                      !value!.contains('@') ? 'Email inválido' : null,
                  decoration: InputDecoration(
                    hintText: 'ejemplo@correo.com',
                    prefixIcon: Icon(Icons.mail_outline),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CupertinoColors.inactiveGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x8AFF4929),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Campo: Password
                InputsReutilizableWidgets(
                  controller: _passwordController,
                  nameInput: 'Crear contraseña',
                  onChanged: notifier.updatePassword,
                  obscuredText: state.isObscure,
                  validator: (value) =>
                      value!.length < 8 ? 'Mínimo 8 caracteres' : null,
                  decoration: InputDecoration(
                    hintText: 'Mínimo 8 caracteres',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        state.isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: notifier.toggleObscure,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CupertinoColors.inactiveGray,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0x8AFF4929),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // --- INFO CARD SEGURIDAD ---
          _buildSecurityCard(),

          const SizedBox(height: 32),

          // --- BOTON ACCION ---
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: state.isLoading
                  ? null // deshabilita el boton mientras carga
                  : () async {
                      if (registerKey.currentState!.validate()) {
                        try {
                          // 1. Guardamos la contraseña en el estado
                          notifier.updatePassword(_passwordController.text);

                          // 2. Disparamos el registro en Supabase
                          await notifier.startSignUp();

                          // 3. Avanzamos a la siguiente pantalla SOLO si fue exitoso
                          if (context.mounted) {
                            widget.pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF4929),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              // Boton de continuar
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continuar",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 18),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 238, 234),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE4E0), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Color(0xFFFF4929),
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Tus datos están seguros. Utilizamos encriptación de grado bancario para proteger tu información.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFF71717A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
