import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey/screen/authentication.dart';
import 'package:hey/services/firebase.dart';
import 'package:hey/widget/chatMessage.dart';
import 'package:hey/widget/newMessage.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = '';
  String userEmail = '';
  String imageUrl = '';
  String collection = 'chat';

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

  void updateCollection(String newCollection) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.pop(context);
    });
    setState(() {
      collection = newCollection;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 47, 63, 0.5),
      drawer: Drawer(
        child: Container(
          color: const Color.fromRGBO(41, 47, 63, 0.5),
          child: ListView(
            children: [
              Container(
                color: const Color.fromRGBO(41, 47, 63, 0.5),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    userEmail,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    updateCollection('chat');
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/general.png'),
                    ),
                    title: Text(
                      'General Channel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    updateCollection('Anime Soul');
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/animeSoul.png'),
                    ),
                    title: Text(
                      'Anime Soul',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    updateCollection('Humor');
                  },
                  child: const ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/humor.png'),
                    ),
                    title: Text(
                      'Humor',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
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
      body: BodyWidget(collectionName: collection),
    );
  }
}

class BodyWidget extends StatefulWidget {
  final String collectionName;

  const BodyWidget({Key? key, required this.collectionName}) : super(key: key);

  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ChatMessage(collectionName: widget.collectionName),
        ),
        NewMessage(collectionName: widget.collectionName),
      ],
    );
  }
}
