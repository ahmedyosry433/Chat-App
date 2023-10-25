// ignore_for_file: file_names, must_be_immutable, use_build_context_synchronously

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  bool isValidEmail(String email) {
    // Define a regex pattern for a valid email
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailPattern.hasMatch(email);
  }

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context, listen: true);
    return SafeArea(
        child: Scaffold(
      body: Container(
        color: AppColorLight.whiteColor,
        padding: const EdgeInsets.only(top: 20),
        width: double.infinity,
        height: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Log In',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/image/login.jpg',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 370,
                      height: 50,
                      child: TextFormField(
                        controller: _emailController,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Please Enter Your Email';
                          } else if (!isValidEmail(email)) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: AppColorLight.primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: AppColorLight.sceondColor))),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 370,
                      height: 50,
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return 'Please Enter Your Password';
                          } else if (password.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: subAuthProvider.visibility,
                        decoration: InputDecoration(
                            suffixIcon: TextButton(
                              onPressed: () {
                                subAuthProvider.visibilityPassword();
                              },
                              child: Icon(subAuthProvider.visibility
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            prefixIcon: const Icon(Icons.password),
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: AppColorLight.primaryColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: AppColorLight.sceondColor))),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (formKey.currentState!.validate()) {
                            await subAuthProvider.logIn(
                                emailController: _emailController,
                                passwordController: _passwordController);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login Is Sucess')));
                            Navigator.popAndPushNamed(context, '/splash');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Faild Login $e')));
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('If You don\'t Have any Account? '),
                        TextButton(
                          onPressed: () =>
                              Navigator.popAndPushNamed(context, '/signup'),
                          child: const Text(
                            'Signup',
                            style: TextStyle(
                                color: AppColorLight.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () async {
                        await subAuthProvider.resetPassword(
                            email: _emailController.text.trim());
                      },
                      child: const Text('Forget Password?'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
