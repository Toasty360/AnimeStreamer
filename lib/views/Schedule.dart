import 'dart:convert';

import 'package:animeapp/models/anime.dart';
import 'package:animeapp/views/animeDetailsContainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  static List<dynamic> data = [];

  final String queryString =
      """query (\$weekStart: Int,\$weekEnd: Int,\$page: Int,){
    Page(page: \$page) {
      pageInfo {
        hasNextPage
        total
      }
      airingSchedules(
        airingAt_greater: \$weekStart
        airingAt_lesser: \$weekEnd
        ) {
          id
          episode
          airingAt
          media 
          {
            id
            idMal
            title {
              romaji
              native
              english
            }
            startDate {
              year
              month
              day
            }
            endDate {
                year
                month
                day
              }
                status
                season
                format
                genres
                synonyms
                duration
                popularity
                episodes
                source(version: 2)
                countryOfOrigin
                hashtag
                siteUrl
                description
                bannerImage
                isAdult
                coverImage {
                  extraLarge
                  color
                }
                trailer {
                  id
                  site
                  thumbnail
                }
                rankings {
                  rank
                  type
                  season
                  allTime
                }
            }
          }
        }
      }""";
  final client = GraphQLClient(
    cache: GraphQLCache(),
    link: HttpLink("https://graphql.anilist.co/"),
  );
  bool isLoaded = false;
  int page = 1;
  bool hasNextPage = false;
  queryData() async {
    var time = DateTime.now();
    print(time);

    QueryResult query =
        await client.query(QueryOptions(document: gql(queryString), variables: {
      'weekStart': (time.millisecondsSinceEpoch / 1000).ceil(),
      'weekEnd':
          (time.add(Duration(days: 6)).millisecondsSinceEpoch / 1000).ceil(),
      'page': page,
    }));
    if (data.isEmpty) {
      data = query.data?["Page"]["airingSchedules"];
    } else {
      data.addAll(query.data?["Page"]["airingSchedules"]);
    }
    hasNextPage = query.data?["Page"]["pageInfo"]["hasNextPage"];
    isLoaded = true;
    setState(() {});
    print(
        query.data?["Page"]["airingSchedules"][0]["media"]["title"]["romaji"]);
  }

  @override
  void initState() {
    super.initState();
    if (data.isEmpty) queryData();
  }

  getTime(DateTime time) {
    List<String> months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "July",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    // time=time.toUtc();
    var _min = time.minute;
    return "${time.hour > 12 ? "${time.hour - 12}${time.minute == 0 ? "" : ":${time.minute}"} PM" : "${time.hour}${time.minute == 0 ? "" : ":${time.minute}"} AM"} ${time.timeZoneName} on ${months[time.month - 1]} ${time.day}${time.day == 2 ? "nd" : time.day == 3 ? "rd" : time.day == 4 ? "rth" : "th"}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17203A),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent &&
              hasNextPage &&
              isLoaded) {
            isLoaded = false;
            page++;
            queryData();
          }
          return true;
        },
        child: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: data.isNotEmpty
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        int malid = data[index]["media"]["idMal"];
                        var giturl =
                            "https://raw.githubusercontent.com/MALSync/MAL-Sync-Backup/master/data/myanimelist/anime/$malid.json";
                        try {
                          var response = await http.get(Uri.parse(giturl));
                          if (response.statusCode != 200) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Color(0xFF17203A),
                              content: Text(
                                'Anime not Found!!',
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                              duration: Duration(milliseconds: 200),
                            ));
                          }
                          var gogo =
                              jsonDecode(response.body)["Pages"]["Gogoanime"];
                          if (gogo != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnimeDetailsContainer(
                                        Anime(
                                            animeId: gogo[gogo.keys.first]
                                                ["identifier"],
                                            animeImg: gogo[gogo.keys.first]
                                                ["image"],
                                            animeTitle: gogo[gogo.keys.first]
                                                ["title"],
                                            animeUrl: "null",
                                            status: "null",
                                            subOrDub: "null"))));
                          } else {
                            print(malid);

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              backgroundColor: Color(0xFF17203A),
                              content: Text(
                                'This Anime isn\'t available on GogoAnime :(',
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                              duration: Duration(milliseconds: 200),
                            ));
                          }
                        } catch (e) {
                          print(malid);
                          print(e);
                        }
                      },
                      child: Container(
                          margin: const EdgeInsets.all(10),
                          height: 190,
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(width: 1,color: Colors.white),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              opacity: 0.09,
                              colorFilter:
                                  const ColorFilter.srgbToLinearGamma(),
                              scale: 1.5,
                              image: NetworkImage(data[index]["media"]
                                      ["bannerImage"] ??
                                  data[index]["media"]["coverImage"]
                                      ["extraLarge"]),
                              onError: (exception, stackTrace) {
                                Container(
                                    color: Colors.amber,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Whoops!',
                                      style: TextStyle(fontSize: 10),
                                    ));
                              },
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  data[index]["media"]["coverImage"]
                                      ["extraLarge"],
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                        color: Colors.amber,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Whoops!',
                                          style: TextStyle(fontSize: 10),
                                        ));
                                  },
                                ),
                              ),
                              Container(
                                  width: context.width * 0.55,
                                  height: context.height,
                                  padding:
                                      const EdgeInsets.only(top: 20, left: 20),
                                  // margin: EdgeInsets.only(left: 0),
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(
                                  //         width: 1, color: Colors.white)),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // textDirection: TextDirection.ltr,
                                      children: [
                                        Container(
                                          // width: MediaQuery.of(context).size.width*0.6,
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //         width: 1,
                                          //         color: Colors.white)),
                                          child: Text(
                                            data[index]["media"]["title"]
                                                ["romaji"],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Text(
                                          "Airing at:",
                                          style: TextStyle(color: Colors.amber),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: context.width * 0.4,
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //         width: 1,
                                          //         color: Colors.white)),
                                          child: Text(
                                            getTime(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    data[index]["airingAt"] *
                                                        1000)),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            maxLines: 2,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          // decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //         width: 1,
                                          //         color: Colors.white)),
                                          width: 100,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Ep: ",
                                                  style: TextStyle(
                                                      color: Colors.amber),
                                                ),
                                                Text(
                                                    "${data[index]["episode"]}",
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green))
                                              ]),
                                        )
                                      ])),
                            ],
                          )),
                    );
                  },
                )
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Please wait fetching the latest schedule!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ])),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
