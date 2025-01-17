import 'package:cached_network_image/cached_network_image.dart';
import 'package:docs_clone/colors.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget{
  HomeScreen({super.key});
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [IconButton(onPressed: (){}, icon: Icon(Icons.add),color: kBlackColor,),
        IconButton(onPressed: (){}, icon: Icon(Icons.logout),color: kRedColor,)
        ],
      ),
      body: Center(
        
        
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(ref.watch(userProvider)!.email),

          Center(
            
        child: _buildProfileImage(ref.watch(userProvider)!.profilePic),
      ),

         
        ],
      ),
      ),
    );
  }
}

Widget _buildProfileImage(String imageUrl) {
    return Image.network(
      imageUrl,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
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
