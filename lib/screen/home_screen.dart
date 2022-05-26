// ignore_for_file: avoid_print, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:rest_api/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../auth/app_url.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        logout();
        break;
    }
  }

  // Future<List<dynamic>>? getanime;
  // @override
  // void initState() {
  //   super.initState();
  //   getanime = getAnimeList();
  // }

  //Anime List
  Future<List<dynamic>> getAnimeList() async {
    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
    };

    var response =
        await http.get(Uri.parse(AppUrl.animeAPI), headers: requestHeaders);
    if (response.statusCode == 200) {
      var userData1 = jsonDecode(response.body)['data'];
      print(userData1);
      return userData1;
    } else {
      var userData1 = jsonDecode(response.body)['data'];
      return userData1;
    }
  }

  //Logout API
  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    Map<String, String> requestHeaders = {
      'Accept': 'application/json',
      'authorization': "Token $token"
    };

    var response = await http.post(
      Uri.parse(AppUrl.logout),
      headers: requestHeaders,
    );
    if (response.statusCode == 204) {
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: const LoginScreen(),
        ),
      );
      print('Logged Out');
      return;
    } else {
      print('Error');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: height * 0.9,
          width: height * 0.9,
          child: FutureBuilder<List<dynamic>>(
            future: getAnimeList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.02),
                        child: SizedBox(
                          width: 200.0,
                          height: 100.0,
                          child: Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 224, 224, 224),
                            highlightColor: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width * 0.4,
                                    height: height * 0.02,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    width: width * 0.4,
                                    height: height * 0.25,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                default:
                  if (snapshot.hasError) {
                    Text('${snapshot.error}');
                  } else {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return EachAnime(
                                height: height,
                                width: width,
                                img: snapshot.data[index]['anime_img'],
                                name: snapshot.data[index]['anime_name'],
                              );
                            },
                          )
                        : const Text('No data');
                  }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class EachAnime extends StatelessWidget {
  const EachAnime({
    Key? key,
    required this.height,
    required this.width,
    required this.img,
    required this.name,
  }) : super(key: key);

  final double height;
  final double width;
  final String name;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02, right: width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.02, top: height * 0.02),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Container(
            height: height * 0.3,
            width: width * 0.5,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: NetworkImage(img),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
