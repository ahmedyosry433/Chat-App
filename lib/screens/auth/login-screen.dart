// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  GlobalKey<FormState> formKey = GlobalKey();
  bool isValidEmail(String email) {
    // Define a regex pattern for a valid email
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailPattern.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
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
                'assets/image/9.jpg',
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
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Please Enter Your Password';
                            } else if (password.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              suffixIcon: TextButton(
                                onPressed: () {},
                                child: const Icon(Icons.visibility),
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
                        onPressed: () {},
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
                          GestureDetector(
                            onTap: () =>
                                Navigator.popAndPushNamed(context, '/signup'),
                            child: const Text(
                              'Signup',
                              style: TextStyle(
                                  color: AppColorLight.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
