import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  final formGlobalKey = GlobalKey<FormState>();
  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Form(
          key: formGlobalKey,
          child: Column(
            children: [
              SizedBox(height: 60),
              Image.asset("assets/images/logo.png"),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your name" : null,
                  controller: nameTextController,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text("Name"),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? "Please enter your Email" : null,
                  controller: emailTextController,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text("Email"),
                  ),
                ),
              ),


                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  validator: (value) =>
                      value!.length < 8 ? "Please enter a valid password" : null,
                  controller: passwordTextController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    label: Text("Password"),
                  ),
                ),
              ),
SizedBox(height: 20,),


SizedBox(
  width: MediaQuery.of(context).size.width * .9,
  height: 50,
  child: ElevatedButton(
    onPressed: () {
      if (formGlobalKey.currentState!.validate()) {
        // Process the signup
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    child: const Text("Sign Up",
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  ),
),

SizedBox(height: 20,),

Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text("Already have an account?"),
    TextButton(
      onPressed: () {
        // Navigate to login page
      },
      child: Text("Log In"),
    ),
  ],
),

SizedBox(height: 20,)

              // Add your form fields here
            ],
          ),
        ),
      ),
    );
  }
}
