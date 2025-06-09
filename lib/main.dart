import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/color.dart';
import 'package:todo/home.dart';
import 'package:todo/provider.dart';

void main() {
  runApp(const MyTodo());
}

class MyTodo extends StatelessWidget {
  const MyTodo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Services(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        theme: ThemeData(
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: kWhiteColor)),
      ),
    );
  }
}
