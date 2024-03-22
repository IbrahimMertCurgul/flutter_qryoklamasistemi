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
          height: height * .40,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/images/arkaplan.png"))),
          child: Column(
            children: [
              Container(
                height: height * .25,
                margin: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: AssetImage("assets/images/topkapilogo.png"))),
              )
            ],
          ),
        )
      ]),
    ));
  }
}
