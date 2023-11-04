// ignore_for_file: file_names, must_be_immutable

import 'package:chat_app/core/theme/app-colors/app-colors-light.dart';
import 'package:chat_app/model/user-model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppbarChat extends StatelessWidget {
  AppbarChat({super.key, required this.userinfor});
  UserInformation userinfor;
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
                  foregroundImage: NetworkImage(userinfor.imageUrl),
                ),
              ),
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${userinfor.firstName} ${userinfor.lastName}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    userinfor.isOnline
                        ? 'online'
                        : DateFormat('hh:mm a dd-MMM')
                            .format(userinfor.lastSeen.toDate()),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
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
