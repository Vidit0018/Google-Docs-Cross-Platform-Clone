
import 'dart:async';

import 'package:docs_clone/colors.dart';
import 'package:docs_clone/common/widgets/loader.dart';
import 'package:docs_clone/models/document_model.dart';
import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:docs_clone/repository/document_repository.dart';
import 'package:docs_clone/repository/socket_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:routemaster/routemaster.dart';

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
  QuillController? _controller = QuillController.basic();
  //  quill.QuillController? _controller;
  ErrorModel ? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();

    socketRepository.changeListener((data) {
  _controller?.compose(
    Delta.fromJson(data['delta']),
    _controller?.selection ?? const TextSelection.collapsed(offset: 0),
    ChangeSource.remote,
    // Source.remote,
  );

      Timer.periodic(const Duration(seconds: 2), (timer) {
      socketRepository.autoSave(<String, dynamic>{
        'delta': _controller!.document.toDelta(),
        'room': widget.id,
      });
    });

});

  }
  void updateTitle(WidgetRef ref,String title)
  {print('update title called');
    ref.read(DocumentRepositoryProvider).updateTitle(token: ref.read(userProvider)!.token, id: widget.id , title: title);
    ref.read(DocumentRepositoryProvider).getDocuments(ref.read(userProvider)!.token);
    fetchDocumentData();
  }
  void fetchDocumentData()async{
    errorModel= await ref.read(DocumentRepositoryProvider).getDocumentById(ref.read(userProvider)!.token, widget.id);

    if(errorModel!.data !=null){
      setState(() {
      titleController.text = (errorModel!.data as DocumentModel).title;
      var content = errorModel!.data.content;
      _controller = QuillController(
          document: content.isEmpty
              ? Document()
              : Document.fromJson(content), // Assuming content is in JSON format
          selection: const TextSelection.collapsed(offset: 0),
        );
        
      });
    }

    _controller!.document.changes.listen((DocChange change) {
  if (change.source == ChangeSource.local) {
    Map<String, dynamic> map = {
      'delta': change.change.toJson(),
      'room': widget.id,
    };
    socketRepository.typing(map);
  }
});
  }


  
  @override
  Widget build(BuildContext context) {
    if(_controller ==null){
      return const Scaffold(
        body: Loader(),
      );
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
    icon: Icon(
      Icons.arrow_back,
      color: kBlueColor, // Customize the color of the back arrow
    ),
    onPressed: () {
      Navigator.pop(context);
      Routemaster.of(context).push('/'); // Go back when the icon is pressed
    },
  ),

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
        padding: EdgeInsets.all(10), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Minimal rounding
        ),
      ),
    ),
    SizedBox(
      width: 8,
    )
  ],
  title: Row(
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 4), // Adjust padding near the logo
        child: Image.asset(
          'assets/icons/google-docs.png',
          height: 40,
        ),
      ),
      Expanded(
        child: SizedBox(
          
          height: 40, // Ensure the height matches the logo
          child: TextField(
            onSubmitted: (value)=> 
              updateTitle(ref, value),
            controller: titleController,
            focusNode: focusNode,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kBlueColor,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              filled: true,
              fillColor: Colors.grey[200], // Optional for better visibility
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ],
  ),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(1),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: kGreyColor, width: 0.1),
      ),
    ),
  ),
),

        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              QuillSimpleToolbar(
                controller: _controller!,
                configurations: const QuillSimpleToolbarConfigurations(
                  color: kBlueColor,
                  
                  // decoration: 
                  
                ),
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
