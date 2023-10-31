// ignore_for_file: unnecessary_import, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OnlineImage extends StatelessWidget {
  const OnlineImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          const SizedBox(height: 50, width: 50, child: CircleAvatar()),
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
