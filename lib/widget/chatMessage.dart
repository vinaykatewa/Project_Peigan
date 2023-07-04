import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hey/widget/messageBubble.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Message Found.'),
            );
          }
          if (chatSnapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          }

          final loadedMessage = chatSnapshot.data!.docs;
          return ListView.builder(
              padding: const EdgeInsets.only(bottom: 30, left: 13, right: 13),
              reverse: true,
              itemCount: loadedMessage.length,
              itemBuilder: (context, index) {
                final chatMessage = loadedMessage[index].data();
                
                final nextChatMessage = index + 1 < loadedMessage.length ?  loadedMessage[index + 1].data() : null;
                final currentUserId = chatMessage['userId'];
                final nextUserId = nextChatMessage != null ? nextChatMessage['userId'] : null;

                final nextUserIsSame = currentUserId == nextUserId;

                if(nextUserIsSame){
                  return MessageBubble.next(message: chatMessage['text'], isMe: authenticatedUser.uid == currentUserId);
                }
                else{
                    return MessageBubble.first(userImage: chatMessage['userIamge'], username: chatMessage['userName'], message: chatMessage['text'], isMe: authenticatedUser.uid == currentUserId);
                }

              });
        });
  }
}
