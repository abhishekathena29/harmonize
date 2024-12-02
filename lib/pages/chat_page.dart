import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:harmonize/pages/about_page.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final chatController = TextEditingController();

  final List<Map<String, String>> messages = [];
  final List<Map<String, dynamic>> chat = [];
  final List<Map<String, dynamic>> songRes = [];

  static const geminiKey = "AIzaSyDclM3W_D4WqUqgvBtLsJeMZFd9fP5ItYQ";

  List<String> _parseResponse(String response) {
    final jsonResponse =
        response.replaceAll("```json", "").replaceAll("```", "").trim();
    print(jsonResponse);

    // Parsing the JSON part
    final parsedJson = jsonDecode(jsonResponse);

    // Accessing the song list
    List<dynamic> songList = parsedJson['songList'];

    // Printing the song list

    List<String> recommendedSong = [];
    for (var song in songList) {
      recommendedSong.add(song);
    }
    // Split the response into lines
    // List<String> lines = response.split('\n');

    // for (var line in lines) {
    //   if (line.trim().startsWith('*')) {
    //     // Extract the song information, remove "**" and trim spaces
    //     String songInfo = line.trim().substring(1).trim();
    //     songInfo = songInfo.replaceAll('**', '');
    //     print("----$songInfo---------");
    //     recommendedSong.add(songInfo);
    //   } else {}
    // }

    return recommendedSong;
  }

  Future<String> geminiAPI() async {
    try {
      final res = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "system_instruction": {
            "parts": {
              "text":
                  "Analyze the musical elements of a given Ukrainian song or Hindi Song, including melody, rhythm, tempo, harmony, and emotional tone. Based on these characteristics, recommend English songs that share similar musical qualities, ensuring the tone and style align closely with the given input. Consider genres, instrumentation, and overall mood to find the closest matches"
            }
          },
          "contents": chat,
        }),
      );
      print(res.statusCode);

      if (res.statusCode == 200) {
        String val = jsonDecode(res.body)['candidates'][0]['content']['parts']
            [0]['text'];
        // content = content.trim();
        print(res.body);

        songRes.add(
          {
            "role": "model",
            "response": _parseResponse(val),
          },
        );
        chat.add({
          "role": "model",
          "parts": [
            {"text": val},
          ]
        });
        setState(() {});
        return res.body;

        // return content;
      }
      print('internal error');
      return 'An internal error occurred';
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  late FocusNode myFocusNode;
  final selectFocus = FocusNode();

  @override
  void initState() {
    myFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        bool isLaptop = constraints.maxWidth >= 1024;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isMobile ? 80.h : 100.h,
                    child: Image.asset('assets/harmonize_logo.png'),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Harmonize',
                              style: TextStyle(
                                  fontSize: isMobile ? 16 : 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            // ElevatedButton(
                            //   onPressed: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => const AboutPage()));
                            //   },
                            //   child: const Text(
                            //     'About Us',
                            //     style: TextStyle(),
                            //   ),
                            // ),
                            // SizedBox(width: 20.w),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AboutPage()));
                              },
                              child: const Text(
                                'About Us',
                                style: TextStyle(),
                              ),
                            )
                          ],
                        ),
                        isMobile || isTablet
                            ? const Text(
                                'At Harmonize, our mission is to bridge cultures through the universal language of music... Stay tuned for further development updates!',
                                style: TextStyle(fontSize: 16),
                              )
                            : const Text(
                                'At Harmonize, our mission is to bridge cultures through the universal language of music.'
                                'By connecting Ukrainian song preferences with tailored English song recommendations, we strive to help create listening experiences that celebrate diversity, foster discovery, and bring people closer to the sounds and stories of the world.'
                                '\n\n'
                                '"We are currently in the process of adding more cutural functionalities to serve users across the globe. Stay tuned for further development updates!" ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                        SizedBox(height: 16.h),
                        const Text(
                          'Example:',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(
                              child: Text(
                                'Ukranian Song Input - Stefania by Kalush',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 30.w),
                            const Expanded(
                              child: Text(
                                '''English Song Ouptut - "Hallelujah" by Leonard Cohen''',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      chat.length,
                      (index) => Card(
                          margin: const EdgeInsets.only(top: 10).copyWith(
                              left: songRes[index]['role'].toString() != 'user'
                                  ? 70.w
                                  : 0),
                          color: Colors.blue[300],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  songRes[index]['role'].toString() == 'user'
                                      ? 'user'
                                      : 'harmony',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SelectionArea(
                                    child: songRes[index]['role'].toString() ==
                                            'user'
                                        ? AnimatedTextKit(
                                            animatedTexts: [
                                              TyperAnimatedText(
                                                songRes[index]['request'],
                                                speed: const Duration(
                                                    milliseconds: 10),
                                                textStyle: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                            totalRepeatCount: 1,
                                          )
                                        : songRes[index]['response'].length != 0
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ...List.generate(
                                                      songRes[index]['response']
                                                          .length,
                                                      (j) => Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text("• ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          25)),
                                                              Expanded(
                                                                child: Text(
                                                                  songRes[index]
                                                                      [
                                                                      'response'][j],
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        20.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))
                                                ],
                                              )
                                            : AnimatedTextKit(
                                                animatedTexts: [
                                                  TyperAnimatedText(
                                                    'Something went wrong or can\'t able to find any english song with the Given Song.',
                                                    speed: const Duration(
                                                        milliseconds: 10),
                                                    textStyle: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                                totalRepeatCount: 1,
                                              )),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(-1, 0),
                              blurRadius: 10,
                              spreadRadius: 1,
                              color: Colors.black26,
                            )
                          ],
                          color: Colors.white),
                      child: TextField(
                        // maxLines: null,
                        focusNode: myFocusNode,
                        autofocus: true,
                        controller: chatController,
                        decoration: const InputDecoration(
                          hintText: 'Write the name of Ukranian song',
                          border: InputBorder.none,
                          // contentPadding: EdgeInsets.all(0),
                        ),
                        onSubmitted: (value) {
                          // messages.add({
                          //   'role': 'user',
                          //   'content': value.trim(),
                          // });
                          String prompt = "Given the song $value"
                              "  Provide a list of English songs that have similar musical qualities "
                              "like melody, tone, rhythm, including genre, instrumentation, and mood. "
                              "Only list the song by bullet don't need to write its analyzation."
                              "Give only 3 song in the form of json like {songList : [...]}";
                          songRes.add({"role": "user", "request": value});
                          chat.add({
                            "role": "user",
                            "parts": [
                              {"text": prompt},
                            ]
                          });

                          geminiAPI();
                          myFocusNode.requestFocus();
                          chatController.clear();
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
