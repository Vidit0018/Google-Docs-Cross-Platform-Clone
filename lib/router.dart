import 'package:docs_clone/screens/document_screen.dart';
import 'package:docs_clone/screens/home_screen.dart';
import 'package:docs_clone/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/' :( (route) => MaterialPage(child: LoginScreen())) ,
  

}
);
final loggedInRoute = RouteMap(routes: {
  '/' :( (route) => MaterialPage(child: HomeScreen())) ,
  '/document/:id' : (route)=> MaterialPage(child: DocumentScreen(id: route.pathParameters['id'] ?? ''))


}
);