import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

class CreatePinPage extends StatelessWidget {
  const CreatePinPage({super.key});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileForPin async {
    final path = await _localPath;
    return File('$path/Pin.txt');
  }

  Future<File> createPin(String pin) async {
    final file = await _localFileForPin;
    return file.writeAsString(pin);
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

  @override
  Widget build(BuildContext context) {
    TextEditingController textCont = TextEditingController();
    TextEditingController oldPassCont = TextEditingController();

    return Scaffold(
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
              child: Text("Enter your old pin",
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
              controller: oldPassCont,
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
              height: 25,
            ),
            const Center(
              child: Text("Enter new pin here!",
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
                  readPin().then((value) => {
                        if (value == oldPassCont.text)
                          {
                            print('pin: ${textCont.text}'),
                            createPin(textCont.text),
                            print("pin created"),
                            Navigator.popAndPushNamed(context, '/loginPage'),
                          }
                        else
                          {
                            textCont.value = TextEditingValue.empty,
                            oldPassCont.value = TextEditingValue.empty,
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    backgroundColor: Color(0xff1e88e5),
                                    content: Center(
                                        child: Text(
                                            'Your old pin is incorrect!'))))
                          }
                      });
                  print("oldpin : ${oldPassCont.text}");

                  // Navigator.popUntil(
                  //     context, ModalRoute.withName('/loginPage'));
                },
                color: Colors.white,
              ),
            ),
          ]),
    ));
  }
}
