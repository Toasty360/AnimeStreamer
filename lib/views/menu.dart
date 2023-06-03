import 'package:animeapp/models/animeApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/animeDetails_get.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    AnimeDataController cont = Get.find();
    return Scaffold(
        body: Container(
      height: double.infinity,
      color: const Color(0xFF17203A),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(children: [
            Container(
                height: 200,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade200,
                      Colors.blue.shade300,
                      Colors.blue.shade500,
                      Colors.blue.shade600,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                        child: Text(
                      "Human",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.amber,
                          fontWeight: FontWeight.bold),
                    )),
                    const Center(
                      child: Text("Weeb",
                          style: TextStyle(color: Colors.white, height: 2)),
                    ),
                    const Divider(thickness: 2),
                    Expanded(
                        child: Column(children: [
                      const Text("Bucket list",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                      Text(cont.x.length.toString(),
                          style: const TextStyle(
                              height: 2,
                              color: Colors.yellowAccent,
                              fontSize: 18))
                    ])),
                  ],
                )),
            TextButton(
              onPressed: () {
                final _controller = TextEditingController();
        
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: AlertDialog(
                          backgroundColor: const Color(0xFF17203A),
                          title: const Text(
                            "Enter new API base Link",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                          content: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _controller,
                            decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: "Search",
                              fillColor: Colors.white,
                              hintStyle: const TextStyle(color: Colors.white),
                              suffixIcon: IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.white),
                                onPressed: () {
                                  _controller.clear();
                                },
                              ),
                            ),
                            onSubmitted: (value) {
                              ApiGetter apichanger = Get.find();
                              apichanger.updateApi(_controller.text);
                              AnimeApi.changeApi();
                              print("changed ig");
                            },
                          )),
                    );
                  },
                );
              },
              child: const Text("Change API?"),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: const Divider(color: Colors.white),
            ),
            const Center(
              child: Text(
                "Made my Toasty-kun :)",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
        ),
      ),
    ));
  }
}
