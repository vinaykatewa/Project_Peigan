import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NewMessage extends StatefulWidget{
  final String collectionName;
  const NewMessage({Key? key, required this.collectionName});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage>{
  final messageController = TextEditingController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMessage = messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    messageController.clear();
    FocusScope.of(context).unfocus();

    final userId = FirebaseAuth.instance.currentUser;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId!.uid)
        .get();
    //send it to firebase
    FirebaseFirestore.instance.collection(widget.collectionName).add({
      'text': enteredMessage,
      'time': Timestamp.now(),
      'userId': userId.uid,
      'userName': userData.data()!['userName'],
      'userIamge': userData.data()!['imageUrl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 5, bottom: 4),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(55, 62, 78, 0.8),
              borderRadius: BorderRadius.circular(50),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                controller: messageController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                cursorColor: const Color.fromRGBO(39, 42, 53, 1),
                style: const TextStyle(color:Colors.white ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.chat, color: Color.fromRGBO(249, 246, 238, 0.6),),
                  border: InputBorder.none,
                  hintText: 'Send a message',
                  hintStyle: TextStyle(color: Color.fromRGBO(249, 246, 238, 0.7),)
                ),
              ),
            ]),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 5, left: 5, bottom: 5),
          child: Ink(
            decoration: const ShapeDecoration(
              color: Color.fromRGBO(39, 42, 53, 1),
              shape: CircleBorder(),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Color.fromRGBO(249, 246, 238, 0.7),),
              onPressed: submitMessage,
            ),
          ),
        ),
      ],
    );
  }
}
