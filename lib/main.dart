import 'dart:core';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyB1bWFIjYRp-mETKItUvK2tsiWbyqXOT_Q",
          appId: "1:385059789211:android:cab4f9ae54eb9db68c293e",
          messagingSenderId: "385059789211",
          projectId: "loginapp-922c5"));
  runApp(MaterialApp(
    home: ListPage(),
    debugShowCheckedModeBanner: false));

}


