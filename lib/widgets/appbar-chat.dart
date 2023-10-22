// ignore_for_file: file_names

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarChat extends StatelessWidget {
  const AppbarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          border: Border.all(color: AppColorLight.sceondColor, width: 0.5),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [
                AppColorLight.gradientColorStart,
                AppColorLight.gradientColorEnd
              ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back)),
              SizedBox(
                width: 60,
                height: 60,
                child: CircleAvatar(
                  child: Image.asset(
                    'assets/image/avatar.png',
                  ),
                ),
              ),
              const SizedBox(width: 5),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Person name',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Last Seen',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logOut();
                  },
                  icon: const Icon(Icons.logout_sharp)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.video_call_rounded)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.call_sharp)),
            ],
          )
        ],
      ),
    );
  }
}
