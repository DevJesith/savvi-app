import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:savvi/features/auth/presentation/providers/reset_password_provider.dart';

// TODO: Se mejorará el diseño
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Valida el formulario y solicita al notifier actualizar la contraseña.
  ///
  /// La pantalla se encarga de la validacion y los dialogos.
  /// El notifier se encarga de la operacion de autenticacion.
  Future<void> _updatePassword() async {
    // Si los campos no son validos, no hacemos ninguna peticion.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Delegamos la actualizacion al notifier.
    await ref
        .read(resetPasswordProvider.notifier)
        .updatePassword(newPassword: _passwordController.text);

    if (!mounted) {
      return;
    }

    final state = ref.read(resetPasswordProvider);

    // Mostramos el resultado exitoso en la interfaz.
    if (state.isSuccess) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Contraseña actualizada'),
            content: const Text('Tu contraseña se actualizó correctamente.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Entendido'),
              ),
            ],
          );
        },
      );

      if (!mounted) {
        return;
      }

      await ref.read(resetPasswordProvider.notifier).signOut();

      // Si falló, mostramos el mensaje guardado por el notifier.
    } else if (state.errorMessage != null) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('No se pudo actualizar'),
            content: Text(state.errorMessage!),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Entendido'),
              ),
            ],
          );
        },
      );

      ref.read(resetPasswordProvider.notifier).clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Observamos el estado para activar el loading y mostrar el resultado
    final resetState = ref.watch(resetPasswordProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Crea una nueva contraseña',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Nueva contraseña',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingresa una contraseña';
                    }

                    if (value.length < 6) {
                      return 'Debe tener al menos 6 caracteres';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirmar contraseña',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirma tu contraseña';
                    }

                    if (value != _passwordController.text) {
                      return 'Las contraseñas no coinciden';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Mientras se procesa la peticion, deshabilitamos el boton
                // para evitar solicitudes duplicadas.
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: resetState.isLoading ? null : _updatePassword,
                    child: resetState.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar contraseña'),
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
