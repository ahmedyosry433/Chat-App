// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:flutter/material.dart';

import '../../forms/signup-form.dart';

class Signuppage extends StatelessWidget {
  const Signuppage({super.key});

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
                'SignUP',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Image.asset(
                'assets/image/81.jpg',
                width: 300,
                height: 250,
              ),
              SignupForm(),
            ],
          ),
        ),
      ),
    ));
  }
}
