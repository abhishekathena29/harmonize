import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        bool isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 1024;
        bool isLaptop = constraints.maxWidth >= 1024;
        return Column(
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
                    child: Row(
                      children: [
                        const Text(
                          'About Us',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Home',
                            style: TextStyle(),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: What is Harmonize?
                    const Text(
                      'What is Harmonize?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Harmonize was inspired by a conversation I had with one of my Ukrainian buddies,'
                      'who said that many Ukranians living abroad were having a hard time assimilating into the cultures of their adopted homelands.'
                      'They loved Western music culture, but didn’t fully understand it yet and were still exploring their musical preferences.'
                      'Sensing an opportunity to put my CS and Music skills to use for the better of the community,'
                      'I developed Harmonize, an AI chatbot that offers Western music recommendations based on the user’s favorite Ukrainian songs.'
                      'I’m excited to expand this initiative to serve users across the globe in the future, incorporating more languages and cultures into my mission at Harmonize.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section: How It Works
                    const Text(
                      'How It Works',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Harmonize uses advanced generative AI algorithms to analyze various musical components '
                      'such as rhythm, tone, and the overarching music theme of Ukrainian songs. '
                      'By processing this data, Harmonize generates a list of English songs that share '
                      'similar characteristics. Whether it’s a soothing melody or an energetic beat, '
                      'Harmonize finds English music that resonates with your Ukrainian selection.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Section: About the Developer
                    const Text(
                      'About the Developer',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: isMobile ? 80.h : 100.h,
                          foregroundImage: const AssetImage(
                              'assets/advik.jpg'), // Add your image asset here
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Hey there! I’m Advik Vermani, a 12th grader at West Windsor-Plainsboro High School South and the Founder/Developer of Harmonize. As a long-time musician myself who’s played the viola for 8 years and the guitar for a few years as well, I know all about the unifying power of music and the cultural identities it can foster.'
                            'I’m also extremely passionate about supporting vulnerable communities, especially Ukranians.'
                            'Since sophomore year, I’ve been volunteering with EngIN, an organization dedicated to connecting English speaking volunteers with Ukrainian students to improve their English proficiency and improve their educational/work opportunities. In junior year, I founded Unite for Ukraine, EngIN’s New Jersey chapter, to expand EngIN’s mission to my local area and provide support and resources to new volunteers.'
                            'The progress since then has been incredible, with our membership growing to over 60 members within just a year.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Section: Contact Information
                    const Text(
                      'Contact',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'uniteforukrainenj@gmail.com\ninstagram.com/uniteforukrainenj',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
