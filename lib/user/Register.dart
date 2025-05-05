import 'package:flutter/material.dart';
import 'package:flutter_application_33/components/auth_service.dart';
import 'package:flutter_application_33/components/my_text_field.dart';
import 'package:flutter_application_33/universal_components/project_logo.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  String? selectedGovernorate;
  final List<String> governorateOptions = [
    'Amman',
    'Irbid',
    'Zarqa',
    'Balqa',
    'Madaba',
    'Mafraq',
    'Jerash',
    'Ajloun',
    'Karak',
    'Tafilah',
    ' Ma\'an ',
    'Aqaba'
  ];

  void SignUp() async {
    if (passwordController.text != confirmpasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: const Color.fromARGB(255, 144, 223, 170),
        ),
      ),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              SizedBox(height: 150, width: 150, child: logo()),
              const Text(
                "Register",
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: MyTextField(
                  controller: usernameController,
                  hintText: "Username",
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: DropdownButtonFormField<String>(
                  value: selectedGovernorate,
                  hint: Text(
                    "Select Governorate",
                    style: TextStyle(color: Colors.grey[400], fontSize: 18),
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  onChanged: (newValue) =>
                      setState(() => selectedGovernorate = newValue!),
                  items: governorateOptions.map((governorate) {
                    return DropdownMenuItem(
                      value: governorate,
                      child: Text(governorate),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade200,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(0, 159, 162, 160),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
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
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: MyTextField(
                  controller: confirmpasswordController,
                  hintText: "Confirm Password",
                  obscureText: isObscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscureConfirmPassword = !isObscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: SignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: customGreen,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}