// ignore_for_file: file_names, use_build_context_synchronously

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarMainChat extends StatelessWidget {
  const AppbarMainChat({super.key});

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);

    return Container(
      height: 100,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                AppColorLight.gradientColorStart,
                AppColorLight.gradientColorEnd
              ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Chats',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              decoration: BoxDecoration(
                  color: AppColorLight.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                  onChanged: (value) => subAuthProvider.searchUsers(value),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      icon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                          )))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircleAvatar(
                      radius: 50,
                      foregroundImage: NetworkImage(
                          '${subAuthProvider.getCurrentUser['imageUrl']}'),
                    ),
                  ),
                ),
                Text('${subAuthProvider.getCurrentUser['firstName']}'),
                const SizedBox(height: 5),
                GestureDetector(
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Log out ?'),
                              content: const Text('You Want to Logout ?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    try {
                                      Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .logOut();
                                      Navigator.pushNamed(context, '/splash');
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text('LogOut sucsess')));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              SnackBar(content: Text('$e')));
                                    }
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cansel"),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text('Logout',
                        style: Theme.of(context).textTheme.titleSmall)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
