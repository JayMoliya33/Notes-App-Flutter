import 'package:flutter/material.dart';
import 'package:notes_app_flutter/screens/note_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My notes app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: NoteList(),
    );
  }
}