// ignore_for_file: file_names, use_build_context_synchronously, unused_import, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../core/theme/app-colors/app-colors-light.dart';
import '../provider/auth-provider.dart';

// ignore: must_be_immutable
class ProfileForm extends StatelessWidget {
  ProfileForm(
      {super.key,
      required this.firstNameValue,
      required this.lastNameValue,
      required this.phoneNameValue});
  String firstNameValue;
  String lastNameValue;
  String phoneNameValue;

  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController =
        TextEditingController(text: firstNameValue);
    final TextEditingController lastNameController =
        TextEditingController(text: lastNameValue);

    final TextEditingController phoneController =
        TextEditingController(text: phoneNameValue);
    final subAuthProvider = Provider.of<AuthProvider>(context, listen: false);
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
              controller: firstNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: '${subAuthProvider.userAlreadyexist['firstName']}',
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
          const SizedBox(height: 30),
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
              controller: lastNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: '${subAuthProvider.userAlreadyexist['lastName']}',
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
          const SizedBox(height: 30),
          SizedBox(
            width: 370,
            height: 50,
            child: TextFormField(
              enabled: false,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: '${subAuthProvider.userAlreadyexist['email']}',
                  disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          const BorderSide(color: AppColorLight.sceondColor))),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 370,
            height: 50,
            child: TextFormField(
              controller: phoneController,
              validator: (phone) {
                if (phone == null || phone.isEmpty) {
                  return 'Please Enter Your Phone';
                } else if (isAlpha(phone)) {
                  return 'Only Number Please';
                }
                return null;
              },
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '${subAuthProvider.userAlreadyexist['phone']}',
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
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              try {
                if (formKey.currentState!.validate()) {
                  await subAuthProvider.updateUser(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    phone: phoneController.text.trim(),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Updated Successfully ')));
                  Navigator.popAndPushNamed(context, '/chatmain');
                }
              } catch (e) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Faild Update $e')));
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
        ],
      ),
    );
  }
}
