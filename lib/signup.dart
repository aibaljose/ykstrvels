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
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController otpTextController = TextEditingController();

  bool isLoading = false;
  bool isOtpSent = false;
  bool isPhoneVerified = false;

  ViewModel viewModel = ViewModel();

  String selectedCountryCode = '+1'; // Default country code
  List<String> countryCodes = [
    '+1',
    '+91',
    '+44',
    '+61',
    '+81',
  ]; // Add more as needed

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
                SizedBox(height: size.height * 0.02),
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        value: selectedCountryCode,
                        items: countryCodes.map((code) {
                          return DropdownMenuItem(
                            value: code,
                            child: Text(
                              code,
                              style: TextStyle(
                                fontSize: 16,
                              ), // Increased font size for better visibility
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountryCode = value!;
                          });
                        },
                        decoration: InputDecoration(
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
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: _buildInputField(
                        controller: phoneTextController,
                        label: "Phone Number",
                        hint: "Enter your phone number",
                        icon: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your phone number";
                          }
                          return null;
                        },
                        enabled: !isOtpSent || !isPhoneVerified,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isOtpSent || isPhoneVerified || isLoading
                              ? null
                              : () => _sendOTP(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  isPhoneVerified ? "Verified" : "Send OTP",
                                  style: const TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // OTP input field (only visible after OTP is sent)
                if (isOtpSent && !isPhoneVerified)
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildInputField(
                              controller: otpTextController,
                              label: "OTP",
                              hint: "Enter 6-digit OTP",
                              icon: Icons.lock_outline,
                              validator: (value) =>
                                  value!.isEmpty || value.length != 6
                                  ? "Please enter valid 6-digit OTP"
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _verifyOTP(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Verify OTP",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Resend OTP button
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => _sendOTP(context, isResend: true),
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(color: Colors.blue.shade700),
                        ),
                      ),
                    ],
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
                        // Check if phone verification is required and not yet verified
                        if (phoneTextController.text.isNotEmpty &&
                            !isPhoneVerified) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please verify your phone number first',
                              ),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        // Valid form
                        viewModel
                            .createUserAccountWithEmailAndPassword(
                              emailTextController.text.trim(),
                              nameTextController.text.trim(),
                              passwordTextController.text.trim(),
                              phoneNumber: isPhoneVerified
                                  ? phoneTextController.text.trim()
                                  : null,
                            )
                            .then((value) {
                              setState(() {
                                isLoading = false;
                              });

                              if (value == "true") {
                                Navigator.pushNamed(context, '/login');
                              } else {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(value)));
                              }
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
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

                // Or sign up with Google
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "OR",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade400)),
                  ],
                ),

                const SizedBox(height: 20),

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            final result = await viewModel.signInWithGoogle();

                            setState(() {
                              isLoading = false;
                            });

                            if (result == "true") {
                              if (mounted) {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/home',
                                );
                              }
                            } else {
                              if (mounted) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(result)));
                              }
                            }
                          },
                    icon: Image.network(
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Sign up with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                      backgroundColor: Colors.white,
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

  // Send OTP to phone number
  Future<void> _sendOTP(BuildContext context, {bool isResend = false}) async {
    if (phoneTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    // Combine country code with phone number
    String fullPhoneNumber = '$selectedCountryCode${phoneTextController.text}';

    // Show loading state
    setState(() {
      isLoading = true;
    });

    try {
      final result = await viewModel.verifyPhoneNumber(fullPhoneNumber);

      // Hide loading state
      setState(() {
        isLoading = false;
      });

      // Handle the result
      if (result['status'] == 'code-sent') {
        setState(() {
          isOtpSent = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      } else if (result['status'] == 'auto-verified') {
        setState(() {
          isOtpSent = true;
          isPhoneVerified = true;
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result['message'])));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending OTP: $e')));
    }
  }

  // Verify OTP code
  Future<void> _verifyOTP(BuildContext context) async {
    if (otpTextController.text.isEmpty || otpTextController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP code')),
      );
      return;
    }

    // Show loading state
    setState(() {
      isLoading = true;
    });

    try {
      final result = await viewModel.verifyOTPCode(otpTextController.text);

      // Hide loading state
      setState(() {
        isLoading = false;
      });

      // Handle the result
      if (result == "true") {
        setState(() {
          isPhoneVerified = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Phone number verified successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verification failed: $result')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error verifying OTP: $e')));
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscure = false,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscure,
      enabled: enabled,
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
