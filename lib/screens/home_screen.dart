import 'package:cached_network_image/cached_network_image.dart';
import 'package:docs_clone/colors.dart';
import 'package:docs_clone/common/widgets/loader.dart';
import 'package:docs_clone/models/document_model.dart';
import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:docs_clone/repository/document_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  void signOut(WidgetRef ref) {
    ref.read(authRepositoryProvider).signOut();
    ref.read(userProvider.notifier).update((state) => null);
  }

  void createDocument(WidgetRef ref, BuildContext context) async {
    String token = ref.read(userProvider)!.token;
    final navigator = Routemaster.of(context);
    final snackBar = ScaffoldMessenger.of(context);
    final errorModel =
        await ref.read(DocumentRepositoryProvider).createDocument(token);

    if (errorModel.data != null) {
      navigator.push('/document/${errorModel.data.id}');
    } else {
      snackBar
          .showSnackBar(SnackBar(content: Text(errorModel.error.toString())));
    }
  }

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => createDocument(ref, context),
              icon: Icon(Icons.add),
              color: kBlackColor,
            ),
            IconButton(
              onPressed: () => signOut(ref),
              icon: Icon(Icons.logout),
              color: kRedColor,
            )
          ],
        ),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(ref.watch(userProvider)!.email),
        //       Center(
        //         child: _buildProfileImage(ref.watch(userProvider)!.profilePic),
        //       ),
        //     ],
        //   ),
        // ),
        body: FutureBuilder<ErrorModel?>(
          future: ref
              .watch(DocumentRepositoryProvider)
              .getDocuments(ref.watch(userProvider)!.token),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader(); // Display a loading indicator while fetching data
            }

            // Handle errors or empty data
            if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.data.isEmpty) {
              return const Center(
                child: Text(
                  'No documents available',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }

            // Render the ListView with valid data
            return Center(
              child: Container(
                padding: EdgeInsets.all(16),
                height: 600,
                width: 600,
                child: ListView.builder(
                  itemCount: snapshot.data!.data
                      .length, // Ensure itemCount matches the data length
                  itemBuilder: (ctx, index) {
                    DocumentModel document = snapshot.data!.data[index];
                    return SizedBox(
                      height: 100,
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title,
                            style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: kBlackColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}

Widget _buildProfileImage(String imageUrl) {
  return Image.network(
    imageUrl,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) {
        return child;
      }
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  (loadingProgress.expectedTotalBytes ?? 1)
              : null,
        ),
      );
    },
    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
      return Icon(Icons.error, size: 50, color: Colors.red);
    },
  );
}

Widget _buildProfileImage_cached(String imageUrl) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    placeholder: (context, url) => Center(
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(
      Icons.error,
      size: 50,
      color: Colors.red,
    ),
    fadeInDuration: Duration(milliseconds: 300), // Optional: smooth fade-in
  );
}
