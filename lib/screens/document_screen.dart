import 'package:docs_clone/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class DocumentScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  FocusNode focusNode = FocusNode();
  TextEditingController titleController =
      TextEditingController(text: 'Untitled Document');
  QuillController _controller = QuillController.basic();
  //  quill.QuillController? _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            ElevatedButton.icon(
              onPressed: () {},
              label: Text(
                'Share',
                style: TextStyle(
                  color: kWhiteColor,
                ),
              ),
              icon: Icon(
                Icons.lock,
                size: 16,
                color: kWhiteColor,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kBlueColor,
                padding: EdgeInsets.all(
                    10), // Updated to use ElevatedButton.styleFrom
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      4), // Minimal rounding for rectangular shape
                ),
              ),
            ),
            SizedBox(
              width: 16,
            )
          ],
          title: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/google-docs.png',
                  height: 40,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: titleController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kBlueColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: kGreyColor, width: 0.1)),
              )),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              QuillSimpleToolbar(
                controller: _controller,
                configurations: const QuillSimpleToolbarConfigurations(),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: 750,
                  height: 1050,
                  child: Card(
                    color: kWhiteColor,
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: QuillEditor.basic(
                        controller: _controller,
                        configurations: const QuillEditorConfigurations(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
