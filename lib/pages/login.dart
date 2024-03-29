// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState(); //login sayfasını _LoginPageState() a dönüştür
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var size, height, width, _signInWithEmailAndPassword;
    size = MediaQuery.of(context).size; //Ekran boyutları alma
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (width < 700 &&
                width / height < 0.8) //MOBİLDE İF İÇİNDEKİ KODLAR GEÇERLİ
              Column(
                children: [
                  Container(
                    height: height * .45,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/images/arkaplan.png"))),
                    child: Column(
                      children: [
                        Container(
                          height: height * .25,
                          margin:
                              const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(
                                      "assets/images/topkapilogo.png"))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style:
                                TextStyle(fontSize: 24.0, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Merhaba!',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32.0),
                              ),
                              TextSpan(
                                text: '\nHoşgeldin',
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////////ÖĞRENCİ INPUT/////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                          child: TextField(
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              labelText: 'Öğrenci Numarası',
                            ),
                          ),
                        ),
                        ////////////////////////////ŞİFRE INPUT/////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              labelText: 'Şifre',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: SizedBox(
                      height: 40.0,
                      width: 150.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: ElevatedButton(
                          onPressed: _signInWithEmailAndPassword,
                          child: const Text(
                            'Giriş Yap',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else //BİLGİSAYARDA ELSE İÇİNDEKİ KODLAR GEÇERLİ -------------------------
              Container(
                height: height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 138, 35, 50),
                  Color.fromARGB(255, 78, 4, 19),
                ])),
                child: Column(
                  children: [
                    Container(
                      height: height * .25,
                      margin: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fitHeight,
                              image:
                                  AssetImage("assets/images/topkapilogo.png"))),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: Text(
                              "Merhaba, Hoşgeldin!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          ////////////////////////////ÖĞRENCİ INPUT/////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
                            child: SizedBox(
                              width: 500,
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  labelText: 'Öğrenci Numarası',
                                ),
                              ),
                            ),
                          ),
                          ////////////////////////////ŞİFRE INPUT/////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                            child: SizedBox(
                              width: 500,
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  labelText: 'Şifre',
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: SizedBox(
                              height: 50.0,
                              width: 200.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: ElevatedButton(
                                  onPressed: _signInWithEmailAndPassword,
                                  child: const Text(
                                    'Giriş Yap',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
