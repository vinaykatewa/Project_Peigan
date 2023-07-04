import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey/screen/authentication.dart';
import 'package:hey/services/firebase.dart';
import 'package:hey/widget/chatMessage.dart';
import 'package:hey/widget/newMessage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = '';
  String userEmail = '';
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    usernameAppBar();
  }

  Future<void> usernameAppBar() async {
    final userId = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId!.uid)
        .get();
    setState(() {
      userName = userData['userName'];
      userEmail = userData['email'];
      imageUrl = userData['imageUrl'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    final chatscreen = ChatMessage();
    return Scaffold(
        backgroundColor: const Color.fromRGBO(41, 47, 63, 0.5),
        drawer: Drawer(
          child: Container(
            color: const Color.fromRGBO(
                41, 47, 63, 0.5), // Set background color for the entire drawer
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(userName),
                  accountEmail: Text(
                    userEmail,
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(41, 47, 63, 0.5),
                  ),
                ),
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {
                    // Handle item 1 tap
                  },
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {
                    // Handle item 2 tap
                  },
                ),
                ListTile(
                  title: Text('Item 3'),
                  onTap: () {
                    // Handle item 3 tap
                  },
                ),
                ListTile(
                  title: Text('Item 4'),
                  onTap: () {
                    // Handle item 4 tap
                  },
                ),
                ListTile(
                  title: Text('Item 5'),
                  onTap: () {
                    // Handle item 5 tap
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(size * 0.06),
          child: AppBar(
            backgroundColor: const Color.fromRGBO(41, 47, 63, 0.5),
            centerTitle: true,
            title: Text(
              userName,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  FirebaseClass().signOut().then((value) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Auth()),
                        (route) => false);
                  }).catchError((error) {
                    // Handle any errors here.
                  });
                },
                icon: const Icon(Icons.exit_to_app_outlined),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [Expanded(child: chatscreen), NewMessage()],
        ));
  }
}
