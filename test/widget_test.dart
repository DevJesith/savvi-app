import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:savvi/features/auth/presentation/screens/login_screen.dart';

void main() {
  // Verifica que el login se renderice y permita escribir en el campo de email.
  testWidgets('la pantalla de login se renderiza', (tester) async {
    // Construye LoginScreen con el ProviderScope necesario para Riverpod.
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );
    expect(find.text('Iniciar sesion'), findsOneWidget);

    final emailField = find.byType(TextFormField);
    expect(emailField, findsWidgets);

    await tester.enterText(emailField.first, 'usuario@test.com');
    expect(find.text('usuario@test.com'), findsOneWidget);
  });

  // Verifica que el formulario rechace un correo sin formato valido.
  testWidgets('muestra error cuando el email es inválido', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    final emailField = find.byType(TextFormField).first;

    await tester.enterText(emailField, 'correo-invalido');

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Correo inválido'), findsOneWidget);
  });

  // Verifica que no se pueda iniciar sesión sin escribir una contraseña.
  testWidgets('muestra error con contraseña esta vacia', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    final fields = find.byType(TextFormField);

    await tester.enterText(fields.at(0), 'usuario@gmail.com');
    await tester.enterText(fields.at(1), '');

    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu contraseña'), findsOneWidget);
  });

  // Verifica la validacion del correo vacío en el dialogo de recuperacion.
  testWidgets('valida correo vacio al recuperar contraseña', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    await tester.tap(find.text('¿Olvidaste tu contraseña?'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(find.text('Ingresa tu correo'), findsOneWidget);
  });

  // Verifica que el dialogo de recuperacion rechace un correo con formato invalido.
  testWidgets('muestra error con correo esta vacio', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginScreen())),
    );

    await tester.tap(find.text('¿Olvidaste tu contraseña?'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField).last;
    await tester.enterText(fields, 'correo-invalido');

    await tester.tap(find.text('Enviar'));
    await tester.pumpAndSettle();

    expect(find.text('Correo inválido'), findsOneWidget);
  });
}
