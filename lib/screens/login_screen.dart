// lib/screens/login_screen.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _signIn() async {
    setState(() => isLoading = true);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Sign in error: $e");
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Login failed")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _register() async {
    setState(() => isLoading = true);
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Registration error: $e");
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Registration failed")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login / Register")),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator:
                    (value) => value!.length < 6 ? "Password too short" : null,
              ),
              SizedBox(height: 30),
              isLoading
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text("Login"),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _register();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.green,
                        ),
                        child: Text("Register"),
                      ),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
