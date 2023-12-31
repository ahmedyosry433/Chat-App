// ignore_for_file: must_be_immutable, file_names

import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../forms/profile-form.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  GlobalKey<FormState> formKey = GlobalKey();

  pickedImage({required BuildContext context}) async {
    await Provider.of<AuthProvider>(context, listen: false)
        .pickImageProfile(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    final imageFromFirebase =
        Provider.of<AuthProvider>(context).pickedImageProfile;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Stack(children: [
                  CircleAvatar(
                    radius: 50,
                    foregroundImage: imageFromFirebase == null
                        ? subAuthProvider.getCurrentUser['imageUrl'] == null
                            ? const NetworkImage(
                                'https://upload.wikimedia.org/wikipedia/commons/9/9a/No_avatar.png')
                            : NetworkImage(
                                subAuthProvider.getCurrentUser['imageUrl'])
                        : null,
                    backgroundImage: imageFromFirebase != null
                        ? FileImage(imageFromFirebase)
                        : null,
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => pickedImage(context: context),
                        child: !subAuthProvider.isLoad
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.add_a_photo_sharp),
                      ))
                ]),
                const SizedBox(height: 50),
                ProfileForm(
                  firstNameValue: subAuthProvider.getCurrentUser['firstName'],
                  lastNameValue: subAuthProvider.getCurrentUser['lastName'],
                  phoneNameValue: subAuthProvider.getCurrentUser['phone'],
                ),
              ],
            ),
            Positioned(
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)),
            ),
          ],
        ),
      ),
    ));
  }
}
