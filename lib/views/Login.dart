import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var textCont = TextEditingController();
  String? pin;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileForPin async {
    final path = await _localPath;
    return File('$path/Pin.txt');
  }

  Future<String?> readPin() async {
    try {
      final file = await _localFileForPin;
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return null;
    }
  }

  Future<File> createPin(String pin) async {
    final file = await _localFileForPin;
    return file.writeAsString(pin);
  }

  @override
  void initState() {
    super.initState();
    print(_localPath);
    readPin().then((value) => {
          setState(() {
            pin = value;
          }),
          print("pin inside the file: $value")
        });
    // if (pin == null) {
    //   Navigator.popAndPushNamed(context, '/home');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return pin != null
        ? Scaffold(
            body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0x990080bf),
                  Color(0xb30080bf),
                  Color(0xcc0080bf),
                  Color(0xff0080bf),
                ])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Enter pin to login!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: PinCodeTextField(
                    controller: textCont,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    pinBoxBorderWidth: 0,
                    pinBoxRadius: 10,
                    pinBoxWidth: 50,
                    pinBoxHeight: 50,
                    pinBoxOuterPadding: const EdgeInsets.all(10),
                    pinTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50)),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_sharp),
                    onPressed: () {
                      print('pin: ${textCont.text}  \n in file: $pin');
                      if (textCont.text == pin) {
                        Navigator.popAndPushNamed(context, '/home');
                      } else {
                        textCont.value = TextEditingValue.empty;

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Center(
                                    child: Text('Please enter correct pin'))));
                      }
                    },
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              duration: Duration(milliseconds: 30),
                                content: Center(
                                    child: Text('So what?'))));
                        },
                        child: const Text(
                          "Forgot your pin?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        )))
              ],
            ),
          ))
        : Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(0x990080bf),
            Color(0xb30080bf),
            Color(0xcc0080bf),
            Color(0xff0080bf),
          ])),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text("Create new pin here",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            PinCodeTextField(
              controller: textCont,
              maxLength: 4,
              keyboardType: TextInputType.number,
              pinBoxBorderWidth: 0,
              pinBoxRadius: 10,
              pinBoxWidth: 50,
              pinBoxHeight: 50,
              pinBoxOuterPadding: const EdgeInsets.all(10),
              pinTextStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50)),
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_sharp),
                onPressed: () {
                  createPin(textCont.text);
                  print("pin pushed into file: ${textCont.text}");
                  ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Color(0xff1e88e5),
                                    duration: Duration(microseconds: 10),
                                    content: Center(
                                        child: Text(
                                            'Your old pin is incorrect!'))));
                  Navigator.popAndPushNamed(context,'/loginPage');
                },
                color: Colors.white,
              ),
            ),
          ]),
    ));
  }
}
