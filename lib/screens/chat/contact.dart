// ignore_for_file: file_names, use_build_context_synchronously

import 'package:chat_app/provider/message-provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app-colors/app-colors-light.dart';
import '../../provider/auth-provider.dart';
import 'chat-details/chat-screen.dart';

class AllContact extends StatelessWidget {
  const AllContact({super.key});

  Future logOut(BuildContext context) async {
    try {
      final myToken = await FirebaseMessaging.instance.getToken();
      await Provider.of<MessageProvider>(context, listen: false)
          .deleteNotificationTokensFromfirebase(token: myToken!);
      Provider.of<AuthProvider>(context, listen: false).logOut();
      Navigator.pushNamed(context, '/splash');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('LogOut sucsess')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final subAuthProvider = Provider.of<AuthProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Contact',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                // Expanded(
                //   child:
                // ),
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
                                        onPressed: () => logOut(context),
                                        child: const Text("Yes"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
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
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
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
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
                itemCount: subAuthProvider.filterUsers(user!.uid).length,
                itemBuilder: ((context, index) {
                  final allUsers =
                      subAuthProvider.filterAllUsersFormFirebase[index];

                  return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatDetails(
                                  user: allUsers,
                                ))),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(allUsers.imageUrl),
                                    )),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${allUsers.firstName} ${allUsers.lastName}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
          ),
        ],
      ),
    ));
  }
}
