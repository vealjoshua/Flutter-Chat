import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, futureSnapshot) =>
          futureSnapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : StreamBuilder(
                  builder: (ctx, chatSnapshot) =>
                      chatSnapshot.connectionState == ConnectionState.waiting
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              reverse: true,
                              itemBuilder: (ctx, index) => MessageBubble(
                                chatSnapshot.data.documents[index]['text'],
                                chatSnapshot.data.documents[index]['userId'] ==
                                    futureSnapshot.data.uid,
                                chatSnapshot.data.documents[index]['username'],
                                key: ValueKey(
                                  chatSnapshot.data.documents[index].documentID,
                                ),
                              ),
                              itemCount: chatSnapshot.data.documents.length,
                            ),
                  stream: Firestore.instance
                      .collection('chats')
                      .orderBy('createdOn', descending: true)
                      .snapshots(),
                ),
    );
  }
}
