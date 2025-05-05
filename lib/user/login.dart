import 'package:flutter/material.dart';
import 'package:flutter_application_33/universal_components/Botton_nav_bar.dart';
import 'package:flutter_application_33/components/auth_service.dart';
import 'package:flutter_application_33/components/my_text_field.dart';
import 'package:flutter_application_33/universal_components/project_logo.dart';
import 'package:flutter_application_33/user/Register.dart';
import 'package:flutter_application_33/user/dashboard_user.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_background/animated_background.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isObscurePassword = true;

  void login() async {
    final authService = Provider.of<AuthService>(context, listen: false);
  print("login called");
    try {
      await authService.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      ).whenComplete((){
        print("login successful");
        return Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => user_dashboard(),
                                ),
                              );
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customGreen = const Color.fromARGB(255, 192, 228, 194);

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBackground(
        vsync: this,
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 200,
            spawnMinRadius: 10,
            spawnMinSpeed: 10,
            spawnMaxSpeed: 15,
            particleCount: 4,
            spawnOpacity: 0.1,
            maxOpacity: 0.1,
            baseColor: customGreen,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: logo(),
                ),
                const SizedBox(height: 50),
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false, suffixIcon: null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: isObscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                        
                          isObscurePassword = !isObscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
               

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(onPressed: ()=> AuthService().signInWithGoogle, style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ), 
                    icon: FaIcon(FontAwesomeIcons.google,color: Colors.grey,size: 25,),
                    label: Text("Sign in with Google",style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => const Register()),
);

                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
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
