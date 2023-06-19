// ignore_for_file: unnecessary_import, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/views/createNoteScreen.dart';
import 'package:note_app/views/editNoteScreen.dart';
import 'package:note_app/views/singinScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? userId = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Get.to(() => const LoginScreen());
            },
            child: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("notes")
                .where("userId", isEqualTo: userId?.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              /*if (snapshot.hasError) {
                return const Text("Something went Wrong!");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              }*/
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No Data Found!"));
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    var note = snapshot.data?.docs[index]['note'];
                    var docId = snapshot.data?.docs[index].id;
                    // var noteId = snapshot.data?.docs[index]['userId'];

                    return Card(
                      child: ListTile(
                        title: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!.get('userName'));
                              }
                              return Container();
                            }),
                        subtitle: Text(note),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => EditNoteScreen(),
                                  arguments: {
                                    'note': note,
                                    'docId': docId,
                                  },
                                );
                              },
                              child: Icon(Icons.edit),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () async {
                                await FirebaseFirestore.instance
                                    .collection("notes")
                                    .doc(docId)
                                    .delete();
                              },
                              child: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Container();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const CreateNoteScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
