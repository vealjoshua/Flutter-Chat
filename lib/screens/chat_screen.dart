import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chats/ulVTGZhdHM8fNN314crm/messages')
            .snapshots(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemBuilder: (ctx, index) => Container(
                      padding: EdgeInsets.all(8),
                      child: Text(snapshot.data.documents[index]['text']),
                    ),
                    itemCount: snapshot.data.documents.length,
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/ulVTGZhdHM8fNN314crm/messages')
              .add({'text': 'This was added by clicking the button!'});
        },
      ),
    );
  }
}
