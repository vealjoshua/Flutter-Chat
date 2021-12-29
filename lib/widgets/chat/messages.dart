import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
      builder: (ctx, chatSnapshot) =>
          chatSnapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => MessageBubble(
                    chatSnapshot.data.docs[index].data()['text'],
                    chatSnapshot.data.docs[index].data()['userId'] == user.uid,
                    chatSnapshot.data.docs[index].data()['username'],
                    chatSnapshot.data.docs[index].data()['userImage'],
                    key: ValueKey(chatSnapshot.data.docs[index].id),
                  ),
                  itemCount: chatSnapshot.data.docs.length,
                ),
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('createdOn', descending: true)
          .snapshots(),
    );
  }
}
