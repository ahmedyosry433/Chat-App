// ignore_for_file: file_names, use_build_context_synchronously, unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../core/theme/app-colors/app-colors-light.dart';
import '../provider/auth-provider.dart';

// ignore: must_be_immutable
class SignupForm extends StatelessWidget {
  SignupForm({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isValidEmail(String email) {
    // Define a regex pattern for a valid email
    final emailPattern = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailPattern.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 370,
            height: 50,
            child: TextFormField(
              validator: (name) {
                if (name == null || name.isEmpty) {
                  return 'Please Enter Last Name';
                } else if (!isAlpha(name)) {
                  return 'Only Letters Please';
                }
                return null;
              },
              controller: _firstNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'First Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: AppColorLight.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: AppColorLight.sceondColor))),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 370,
            height: 50,
            child: TextFormField(
              validator: (name) {
                if (name == null || name.isEmpty) {
                  return 'Please Enter Last Name';
                } else if (!isAlpha(name)) {
                  return 'Only Letters Please';
                }
                return null;
              },
              controller: _lastNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Last Name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: AppColorLight.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: AppColorLight.sceondColor))),
            ),
          ),
          const SizedBox(height: 10),
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
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Email',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: AppColorLight.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: AppColorLight.sceondColor))),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 370,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 180,
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
                    controller: _passwordController,
                    obscureText: subAuthProvider.visibility,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: AppColorLight.primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: AppColorLight.sceondColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  height: 50,
                  child: TextFormField(
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Enter Your Confirm Password';
                      } else if (password.length < 6) {
                        return 'Password must be at least 6 characters';
                      } else if (password != _passwordController.text) {
                        return 'Password Not Matching';
                      }

                      return null;
                    },
                    controller: _confirmpasswordController,
                    obscureText: subAuthProvider.visibility,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                        suffixIcon: TextButton(
                          onPressed: () {
                            subAuthProvider.visibilityPassword();
                          },
                          child: Icon(subAuthProvider.visibility
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        hintText: 'Confirm',
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
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 370,
            height: 50,
            child: TextFormField(
              validator: (phone) {
                if (phone == null || phone.isEmpty) {
                  return 'Please Enter Your Phone';
                } else if (isAlpha(phone)) {
                  return 'Only Number Please';
                }
                return null;
              },
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'Phone',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: AppColorLight.primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: AppColorLight.sceondColor))),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () async {
              try {
                if (formKey.currentState!.validate()) {
                  await subAuthProvider.signUp(
                    emailController: _emailController,
                    passwordController: _passwordController,
                  );

                  await subAuthProvider.addUserInfoInFirebase(
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      phone: _phoneController.text);

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup Successfully')));

                  Navigator.pushNamed(context, '/splash');
                }
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Faild Signup $e')));
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
              const Text('If You Have Account? '),
              GestureDetector(
                onTap: () {
                  Navigator.popAndPushNamed(context, '/login');
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(
                      color: AppColorLight.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
