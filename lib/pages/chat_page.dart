import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
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
    // Split the response into lines
    List<String> lines = response.split('\n');

    List<String> recommendedSong = [];

    for (var line in lines) {
      if (line.trim().startsWith('*')) {
        // Extract the song information, remove "**" and trim spaces
        String songInfo = line.trim().substring(1).trim();
        songInfo = songInfo.replaceAll('**', '');
        print("----$songInfo---------");
        recommendedSong.add(songInfo);
      }
    }

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
                  "Analyze the musical elements of a given Ukrainian song, including melody, rhythm, tempo, harmony, and emotional tone. Based on these characteristics, recommend English songs that share similar musical qualities, ensuring the tone and style align closely with the given input. Consider genres, instrumentation, and overall mood to find the closest matches"
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    chat.length,
                    (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(-1, 0),
                                blurRadius: 5,
                                spreadRadius: 1,
                                color: Colors.black12,
                              )
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   chat[index]['role'].toString(),
                            //   style: const TextStyle(
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black26),
                            // ),
                            // // Add Selection area widget
                            // SelectionArea(
                            //   child: AnimatedTextKit(
                            //     animatedTexts: [
                            //       TyperAnimatedText(
                            //         chat[index]['parts'][0]['text'].toString(),
                            //         speed: const Duration(milliseconds: 10),
                            //         textStyle: const TextStyle(
                            //           fontSize: 20.0,
                            //           fontWeight: FontWeight.w500,
                            //         ),
                            //       ),
                            //     ],
                            //     totalRepeatCount: 1,
                            //   ),
                            // ),
                            Text(
                              songRes[index]['role'].toString(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black26),
                            ),
                            // Add Selection area widget
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
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...List.generate(
                                              songRes[index]['response'].length,
                                              (j) => Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text("• ",
                                                          style: TextStyle(
                                                              fontSize: 25)),
                                                      Expanded(
                                                        child: Text(
                                                          songRes[index]
                                                              ['response'][j],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ))
                                        ],
                                      )),
                          ],
                        )),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
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
                        color: Colors.white,
                      ),
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
                          String prompt =
                              "Given the Ukrainian song $value, Provide a list of English songs that have similar musical qualities like melody, tone, rhythm, including genre, instrumentation, and mood. Only list the song by bullet don't need to write its analyzation.";
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
        ),
      ),
    );
  }
}
