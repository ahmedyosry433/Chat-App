// ignore_for_file: unnecessary_import, file_names

import 'package:chat_app/provider/auth-provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class OnlineImage extends StatelessWidget {
  OnlineImage({super.key, required this.index});
  int index;
  @override
  Widget build(BuildContext context) {
    final subAuthProvider =
        Provider.of<AuthProvider>(context).filterAllUsersOnline;
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: CircleAvatar(
                foregroundImage: NetworkImage(subAuthProvider[index].imageUrl),
              )),
          Container(
            height: 15,
            width: 15,
            decoration: const BoxDecoration(
                color: Colors.green, shape: BoxShape.circle),
          )
        ],
      ),
    );
  }
}
