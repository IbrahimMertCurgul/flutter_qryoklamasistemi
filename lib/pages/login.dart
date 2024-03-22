import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Center(
      child: Column(children: [
        Container(
          height: height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/topkapilogo.png"))),
        )
      ]),
    ));
  }
}
