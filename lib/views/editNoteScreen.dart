// ignore_for_file: unnecessary_string_interpolations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/views/homeScreen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({Key? key}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              maxLines: null,
              controller: noteController
                ..text = "${Get.arguments['note'].toString()}",
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("notes")
                    .doc(Get.arguments["docId"].toString())
                    .update({
                  'note': noteController.text.trim(),
                }).then(
                  (value) => {
                    Get.offAll(() => const HomeScreen()),
                  },
                );
              },
              child: const Text("Update"),
            ),
          ],
        ),
      ),
    );
  }
}
