import 'package:flutter/material.dart';
import 'package:ykstravels/view_model/view_model.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  ViewModel viewModel = ViewModel();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formGlobalKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),
                // Logo
                Image.asset(
                  "assets/images/logo.png",
                  width: size.width * 0.25,
                  height: size.width * 0.25,
                ),

                SizedBox(height: size.height * 0.04),
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Sign up to get started",
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),

                SizedBox(height: size.height * 0.04),

                // Name
                _buildInputField(
                  controller: nameTextController,
                  label: "Name",
                  hint: "Enter your full name",
                  icon: Icons.person,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                ),

                const SizedBox(height: 16),

                // Email
                _buildInputField(
                  controller: emailTextController,
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your email" : null,
                ),

                const SizedBox(height: 16),

                // Password
                _buildInputField(
                  controller: passwordTextController,
                  label: "Password",
                  hint: "Enter your password",
                  icon: Icons.lock_outline,
                  obscure: true,
                  validator: (value) => value!.length < 8
                      ? "Password must be at least 8 characters"
                      : null,
                ),

                SizedBox(height: size.height * 0.04),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formGlobalKey.currentState!.validate()) {
                        // Valid form
                        viewModel
                            .createUserAccountWithEmailAndPassword(
                              emailTextController.text.trim(),
                              nameTextController.text.trim(),
                              passwordTextController.text.trim(),
                            )
                            .then((value) {
                              if (value == "true") {
                                Navigator.pushNamed(context, '/login');
                              } else {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(value)));
                              }
                            });
                      } else {}
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),

                // Login Redirect
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                        // navigate to login page
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
