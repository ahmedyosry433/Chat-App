// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/auth-provider.dart';
import '../../../../widgets/online-image.dart';
import '../../chat-details/chat-screen.dart';

class UserActiveCard extends StatelessWidget {
  const UserActiveCard({super.key});

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    final subsubAuthProvider =
        Provider.of<AuthProvider>(context, listen: false);
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: subsubAuthProvider.filterUsersOnline().length,
          itemBuilder: ((context, index) {
            final userFilter = subAuthProvider.filterAllUsersOnline[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDetails(
                            user: userFilter,
                          ))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: OnlineImage(
                        index: index,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('${userFilter.firstName} ',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600)),
                        Text(
                          ' ${userFilter.lastName}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }
}
