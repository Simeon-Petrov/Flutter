import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:calendar_ap/screens/register_screen.dart';
import 'package:calendar_ap/screens/main_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateToMainWrapperWithAnimation() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const MainWrapper(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        print('User signed in successfully.');

        _navigateToMainWrapperWithAnimation();
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found for that email.';
            break;
          case 'wrong-password':
            message = 'Wrong password provided. Please try again.';
            break;
          case 'invalid-email':
            message = 'Invalid email address.';
            break;
          case 'user-disabled':
            message = 'This user account has been disabled.';
            break;
          case 'too-many-requests':
            message = 'Too many failed login attempts. Please try again later.';
            break;
          default:
            message = 'Login error: ${e.message ?? "Unknown error"}';
            break;
        }
        setState(() {
          _errorMessage = message;
        });
        print('Login error: ${e.code} - ${e.message}');
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: ${e.toString()}';
        });
        print('Unexpected error: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _signInAsGuest() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInAnonymously();
      print('Signed in as guest user.');

      _navigateToMainWrapperWithAnimation();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage =
            'Error signing in as guest: ${e.message ?? "Unknown error"}';
      });
      print('Anonymous sign-in error: ${e.code} - ${e.message}');
    } catch (e) {
      setState(() {
        _errorMessage =
            'An unexpected error occurred during guest sign-in: ${e.toString()}';
      });
      print('Unexpected error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to calendar app',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signIn,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Login',
                              style: TextStyle(fontSize: 18),
                            ),
                  ),
                ),
                const SizedBox(height: 10),

                TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                  child: const Text("Don't have an account? Register here."),
                ),

                const SizedBox(height: 20),
                TextButton(
                  onPressed: _isLoading ? null : _signInAsGuest,
                  child: const Text(
                    'Continue as Guest',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
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
