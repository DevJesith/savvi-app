import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para la llave del formulario
/// Permite validar el formulario desde cualquier parte si fuera necesario
final loginFormKeyProvider = Provider.autoDispose(
  (ref) => GlobalKey<FormState>(),
);

/// Poviders para los controladores de texto
/// Usamos .autodispose para que se destruyan al salir de la pantalla y no consuman RAM
final emailControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);
final passwordControllerProvider = Provider.autoDispose(
  (ref) => TextEditingController(),
);

/// Clase Notifier (Cerebro de este estado)
///
/// Esta clase se encga de la logica de negocio para ocultar/mostrar texto.
/// Hereda de [Notifier<bool>] porque el dato que vamos a menajar es un Booleano.
class ObscureTextNotifier extends Notifier<bool> {
  /// El metodo build es OBLIGATORIO.
  /// Define cual es el valor inicial apenas la app arranca o se carga el provider.
  @override
  bool build() {
    return true; // Estado inicial: La contraseña emepieza oculta
  }

  ///Metodo personalizado para cambiar el estado.
  /// En los Notifiers, usamos la palabra reservada 'state' para referirnos al valor actual
  void toggle() {
    // Aqui decimos: "El nuevo estado sera lo opuesto al estado actual"
    state = !state;
  }
}

/// El provider (el enlace para que la UI pueda usar el cerebro)
///
/// Declaramos que el Provider de forma global para que cualquioer pantalla pueda "escucharlo".
// ignore: unintended_html_in_doc_comment
/// NotifierProvider<Cerebro, TipoDeDato>
final obscureTextProvider = NotifierProvider<ObscureTextNotifier, bool>(() {
  return ObscureTextNotifier();
});
