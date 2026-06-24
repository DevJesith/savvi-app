import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 218, 218),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                      // const SizedBox(width: 10,)
                      Text('Bienvenido')
                      
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Iniciar sesion',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    // textAlign: TextAlign.left,
                  ),
                    
                  const SizedBox(height: 15),
                    
                  Text(
                    'Gestiona tus finanzas de forma segura y alcanza tus metas',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                    
                  Form(
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Correo electrónico",
                          ),
                        ),
                        TextField(
                          decoration: InputDecoration(labelText: "Contraseña"),
                        ),
                      ],
                    ),
                  ),
                    
                  const SizedBox(height: 15),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement the route for the new direction page
                      print("¡Open the password recovery page!");
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                    
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
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                    
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
                          style: TextStyle(
                            fontSize: 16,
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
                        onPressed: () {},
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/logo_google.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 5),
                            Text('Google'),
                          ],
                        ),
                      ),
                    
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/apple_logo.png',
                              width: 22,
                              height: 22,
                            ),
                            const SizedBox(width: 5),
                            Text('Apple'),
                          ],
                        ),
                      ),
                    ],
                  ),
                    
                  const SizedBox(height: 20),
                    
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No tienes cuenta?'),
                    
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Registrate',
                          style: TextStyle(color: Color(0xFFFF4929)),
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
