// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarMainChat extends StatelessWidget {
  const AppbarMainChat({super.key});

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.only(left: 5),
            child: Text(
              'Chats',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 30),
              decoration: BoxDecoration(
                  color: AppColorLight.whiteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: CircleAvatar(
                    child: Image.asset(
                      'assets/image/avatar.png',
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .logOut();
                    },
                    child: Text('Login',
                        style: Theme.of(context).textTheme.titleSmall)),
              ],
            ),
          )
        ],
      ),
    );
  }
}